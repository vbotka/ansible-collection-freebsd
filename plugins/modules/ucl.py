# Copyright 2021-2026, Vladimir Botka <vbotka@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r"""
module: ucl
short_description: Manage FreeBSD UCL config files
author:
  - Vladimir Botka (@vbotka)
requirements:
  - uclcmd >= 0.1_3
  - libucl >= 0.8.1
description:
  - A CRUD-like interface for managing Universal Configuration Language (UCL) files via C(uclcmd).
extends_documentation_fragment:
  - ansible.builtin.files
  - ansible.builtin.validate
  - ansible.builtin.backup
options:
  path:
    description:
      - Path to the UCL config file to operate on.
    type: path
    required: true
    aliases: [dest, file]
  upath:
    description:
      - The key of the variable in object dot-notation.
    type: str
    default: .
    aliases: [variable, key]
  ipath:
    description:
      - Path to an external file used as input for combining or merging.
      - Mutually exclusive with O(value) and O(icontent).
    type: path
  icontent:
    description:
      - String content provided directly as input to C(uclcmd) via stdin.
      - Mutually exclusive with O(value) and O(ipath).
    type: str
  value:
    description:
      - Desired value of the selected O(upath).
      - Mutually exclusive with O(icontent) and O(ipath).
    type: raw
  vtype:
    description:
      - Explicitly set the data type for the new element.
    type: str
    choices:
      - object
      - array
      - int
      - number
      - float
      - double
      - string
      - bool
      - time
      - date
      - userdata
      - None
  merge:
    description:
      - Whether the input provided by O(value), O(ipath), or O(icontent) should be merged instead of set.
    type: bool
    default: false
  state:
    description:
      - Desired state of the selected O(upath).
    type: str
    choices: [absent, present]
    default: present
    aliases: [ensure]
  delimiter:
    description:
      - Character delimiter used to separate keys in O(upath).
    type: str
    default: .
  lang:
    description:
      - UCL output format style.
    type: str
    choices: [ucl, yaml, json, cjson, msgpack]
    default: ucl
  chdir:
    description:
      - Change into this directory before running C(uclcmd). Useful when UCL includes relative paths.
    type: path
  executable:
    description:
      - Path to the C(uclcmd) binary executable.
      - Can also be set via the E(ANSIBLE_UCLCMD) environment variable.
    type: path
  create:
    description:
      - If specified, creates the target file if it does not already exist.
    type: bool
    default: false
  backup:
    description:
      - Create a backup file including timestamp before overwriting.
    type: bool
    default: false
"""

EXAMPLES = r"""
- name: Get FreeBSD repository URL
  vbotka.freebsd.ucl:
    path: /etc/pkg/FreeBSD.conf
    upath: freebsd.url

- name: Get package configuration in YAML format
  vbotka.freebsd.ucl:
    path: /etc/pkg/FreeBSD.conf
    lang: yaml

- name: Set latest package repository URL
  vbotka.freebsd.ucl:
    path: /etc/pkg/FreeBSD.conf
    upath: freebsd.url
    value: "pkg+http://pkg.FreeBSD.org/${ABI}/latest"

- name: Merge new value to key
  vbotka.freebsd.ucl:
    path: /usr/local/etc/pkg/repos/custom.conf
    upath: Custom
    value:
      url: "pkg+http://custom.repo.local/${ABI}/latest"
      enabled: true
    merge: true
    create: true

- name: Remove key from config
  vbotka.freebsd.ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey
    state: absent
"""

RETURN = r"""
cmd:
  description: The executed C(uclcmd) command list or string.
  returned: always
  type: list
  elements: str
rc:
  description: Return code from C(uclcmd).
  returned: always
  type: int
  sample: 0
stdout:
  description: Standard output from C(uclcmd).
  returned: always
  type: str
stderr:
  description: Standard error from C(uclcmd).
  returned: always
  type: str
msg:
  description: Summary message of operations performed.
  returned: always
  type: str
"""

import difflib
import json
import os
import tempfile
from dataclasses import dataclass, field
from typing import Any

from ansible.module_utils.basic import (
    AnsibleModule,
    env_fallback,
    is_executable,
    json_dict_bytes_to_unicode,
)
from ansible.module_utils.common.text.converters import to_bytes, to_native


@dataclass
class ExecutionState:
    created: bool = False
    changed: bool = False
    messages: list[str] = field(default_factory=list)
    content_diff: dict[str, str] = field(default_factory=dict)
    attr_diff: dict[str, str] = field(default_factory=dict)

    def add_msg(self, msg: str) -> None:
        self.messages.append(msg)

    @property
    def full_msg(self) -> str:
        return " ".join(self.messages)


def _format_value(val: Any) -> str:
    """Formats Python data types into strings suitable for uclcmd CLI arguments."""
    if isinstance(val, bool):
        return "true" if val else "false"
    if isinstance(val, (dict, list)):
        return json.dumps(val)
    if val is None:
        return "null"
    return str(val)


def _build_base_flags(params: dict[str, Any], include_vtype: bool = True) -> list[str]:
    flags = [f"--{params['lang']}", "--delimiter", params["delimiter"]]
    if include_vtype and params.get("vtype"):
        flags.extend(["--type", params["vtype"]])
    return flags


def run_cmd(
    module: AnsibleModule,
    cmd: list[str],
    data: str | None = None,
    cwd: str | None = None,
) -> tuple[int, str, str]:
    b_cwd = to_bytes(cwd, errors="surrogate_or_strict") if cwd else None
    rc, out, err = module.run_command(cmd, data=data, cwd=b_cwd, errors="surrogate_or_strict")
    return rc, out, err


def get_value(
    module: AnsibleModule,
    uclcmd: str,
    state: ExecutionState,
) -> tuple[list[str], int, str, str]:
    p = module.params
    cmd = [uclcmd, "get"] + _build_base_flags(p, include_vtype=False) + ["--file", p["path"], p["upath"]]
    rc, out, err = run_cmd(module, cmd, cwd=p["chdir"])

    if rc != 0:
        module.fail_json(msg=f"Command failed: {' '.join(cmd)}", rc=rc, stdout=out, stderr=err)

    state.add_msg("Command get executed.")
    return cmd, rc, out, err


def create_content_diff(
    module: AnsibleModule,
    cmd_before: list[str],
    cmd_after: list[str],
    state: ExecutionState,
) -> tuple[int, str, str]:
    p = module.params
    rc_b, out_before, err_b = run_cmd(module, cmd_before, cwd=p["chdir"])
    if rc_b != 0:
        module.fail_json(msg=f"Failed reading current state: {' '.join(cmd_before)}", rc=rc_b, stdout=out_before, stderr=err_b)

    rc_a, out_after, err_a = run_cmd(module, cmd_after, data=p["icontent"], cwd=p["chdir"])
    if rc_a != 0:
        module.fail_json(msg=f"Failed dry-run verification: {' '.join(cmd_after)}", rc=rc_a, stdout=out_after, stderr=err_a)

    before_lines = out_before.splitlines(keepends=True)
    after_lines = out_after.splitlines(keepends=True)

    udiff = list(difflib.unified_diff(before_lines, after_lines, fromfile=f"{p['path']} (before)", tofile=f"{p['path']} (after)"))
    if udiff:
        state.changed = True
        state.content_diff = {
            "before": out_before,
            "after": out_after,
            "before_header": f"{p['path']} (content)",
            "after_header": f"{p['path']} (content)",
            "diff": "".join(udiff),
        }

    return rc_a, out_after, err_a


def set_value(
    module: AnsibleModule,
    uclcmd: str,
    state: ExecutionState,
) -> tuple[list[str], int, str, str]:
    p = module.params
    path = p["path"]
    upath = p["upath"]
    ipath = p["ipath"]
    icontent = p["icontent"]
    value = p["value"]
    operation = "merge" if p["merge"] else "set"

    cmd_before = [uclcmd, "get"] + _build_base_flags(p, include_vtype=False) + ["--file", path, "."]

    # Build base modification command
    cmd_dry = [uclcmd, operation] + _build_base_flags(p, include_vtype=True) + ["--noop", "--file", path]
    if value is not None:
        cmd_dry.extend([upath, _format_value(value)])
    elif ipath is not None:
        cmd_dry.extend(["-i", ipath, upath])
    elif icontent is not None:
        cmd_dry.extend([upath])

    rc, out, err = create_content_diff(module, cmd_before, cmd_dry, state)
    state.add_msg(f"Dry-run executed for {operation}.")

    cmd_exec = cmd_dry
    if state.changed:
        if module.check_mode:
            state.add_msg("Check mode: changes not applied.")
        else:
            with tempfile.NamedTemporaryFile(dir=module.tmpdir, delete=False) as tmp:
                tmpfile = tmp.name

            try:
                cmd_exec = [uclcmd, operation] + _build_base_flags(p, include_vtype=True) + ["--file", path, "--output", tmpfile]
                if value is not None:
                    cmd_exec.extend([upath, _format_value(value)])
                elif ipath is not None:
                    cmd_exec.extend(["-i", ipath, upath])
                elif icontent is not None:
                    cmd_exec.extend([upath])

                rc, out, err = run_cmd(module, cmd_exec, data=icontent, cwd=p["chdir"])
                if rc != 0:
                    module.fail_json(msg=f"Command execution failed: {' '.join(cmd_exec)}", rc=rc, stdout=out, stderr=err)

                validate_backup_write(module, tmpfile, state)
                state.add_msg("Content updated.")
            finally:
                if os.path.exists(tmpfile):
                    os.remove(tmpfile)

    return cmd_exec, rc, out, err


def remove_upath(
    module: AnsibleModule,
    uclcmd: str,
    state: ExecutionState,
) -> tuple[list[str], int, str, str]:
    p = module.params
    path = p["path"]
    upath = p["upath"]

    cmd_before = [uclcmd, "get"] + _build_base_flags(p, include_vtype=False) + ["--file", path, "."]
    cmd_dry = [uclcmd, "remove"] + _build_base_flags(p, include_vtype=False) + ["--noop", "--file", path, upath]

    rc, out, err = create_content_diff(module, cmd_before, cmd_dry, state)
    state.add_msg("Dry-run executed for remove.")

    cmd_exec = cmd_dry
    if state.changed:
        if module.check_mode:
            state.add_msg("Check mode: changes not applied.")
        else:
            with tempfile.NamedTemporaryFile(dir=module.tmpdir, delete=False) as tmp:
                tmpfile = tmp.name

            try:
                cmd_exec = [uclcmd, "remove"] + _build_base_flags(p, include_vtype=False) + ["--file", path, "--output", tmpfile, upath]
                rc, out, err = run_cmd(module, cmd_exec, cwd=p["chdir"])
                if rc != 0:
                    module.fail_json(msg=f"Remove operation failed: {' '.join(cmd_exec)}", rc=rc, stdout=out, stderr=err)

                validate_backup_write(module, tmpfile, state)
                state.add_msg("Key removed.")
            finally:
                if os.path.exists(tmpfile):
                    os.remove(tmpfile)

    return cmd_exec, rc, out, err


def validate_backup_write(module: AnsibleModule, tmpfile: str, state: ExecutionState) -> None:
    path = module.params["path"]
    backup = module.params["backup"]
    unsafe_writes = module.params["unsafe_writes"]
    validate = module.params.get("validate")

    if validate:
        if "%s" not in validate:
            module.fail_json(msg=f"Validate string must contain %%s: {validate}")
        v_cmd = validate % tmpfile
        rc, out, err = module.run_command(to_bytes(v_cmd, errors="surrogate_or_strict"))
        if rc != 0:
            module.fail_json(msg=f"Validation failed: {v_cmd}", rc=rc, stdout=out, stderr=err)
        state.add_msg("Validation passed.")

    if backup and os.path.exists(path):
        backup_path = module.backup_local(path)
        state.add_msg(f"Backup created: {backup_path}.")

    dest_real = to_native(os.path.realpath(to_bytes(path, errors="surrogate_or_strict")), errors="surrogate_or_strict")
    module.atomic_move(tmpfile, dest_real, unsafe_writes=unsafe_writes)


def ensure_file_exists(module: AnsibleModule, state: ExecutionState) -> None:
    path = module.params["path"]
    b_path = to_bytes(path, errors="surrogate_or_strict")
    create = module.params["create"]

    if not os.path.exists(b_path):
        if not create:
            module.fail_json(msg=f"File {path} does not exist and create=false.")
        if module.check_mode:
            state.changed = True
            state.add_msg(f"File {path} will be created.")
            return

        with open(b_path, "w", encoding="utf-8") as f:
            f.write("")
        state.created = True
        state.changed = True
        state.add_msg(f"File {path} created.")

    attr_diff: dict[str, str] = {
        "before_header": f"{path} (file attributes)",
        "after_header": f"{path} (file attributes)",
    }
    file_args = module.load_file_common_arguments(module.params)
    if module.set_fs_attributes_if_different(file_args, False, attr_diff):
        if not state.created:
            state.attr_diff = attr_diff
            state.changed = True
            state.add_msg("File attributes updated.")


def main() -> None:
    module_args = dict(
        path=dict(type="path", aliases=["dest", "file"], required=True),
        upath=dict(type="str", aliases=["variable", "key"], default="."),
        ipath=dict(type="path"),
        icontent=dict(type="str"),
        value=dict(type="raw"),
        vtype=dict(
            type="str",
            choices=[
                "object",
                "array",
                "int",
                "number",
                "float",
                "double",
                "string",
                "bool",
                "time",
                "date",
                "userdata",
                "None",
            ],
        ),
        merge=dict(type="bool", default=False),
        state=dict(type="str", aliases=["ensure"], default="present", choices=["absent", "present"]),
        delimiter=dict(type="str", default="."),
        lang=dict(type="str", default="ucl", choices=["ucl", "yaml", "json", "cjson", "msgpack"]),
        chdir=dict(type="path"),
        executable=dict(type="path", fallback=(env_fallback, ["ANSIBLE_UCLCMD"])),
        create=dict(type="bool", default=False),
        backup=dict(type="bool", default=False),
        validate=dict(type="str"),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        add_file_common_args=True,
        supports_check_mode=True,
        mutually_exclusive=[("value", "ipath", "icontent")],
    )

    state = ExecutionState()
    state.add_msg(f"File: {module.params['path']};")

    # Locate uclcmd binary
    if module.params["executable"]:
        uclcmd = module.params["executable"]
        if not is_executable(uclcmd):
            module.fail_json(msg=f"Specified executable '{uclcmd}' is not executable.")
    else:
        uclcmd = module.get_bin_path("uclcmd", required=True)

    # Initialize file target and handle create
    ensure_file_exists(module, state)

    val = json_dict_bytes_to_unicode(module.params["value"])
    module.params["value"] = val
    ipath = module.params["ipath"]
    icontent = module.params["icontent"]
    target_state = module.params["state"]

    if target_state == "present" and (val is not None or ipath is not None or icontent is not None):
        cmd, rc, stdout, stderr = set_value(module, uclcmd, state)
    elif target_state == "present":
        cmd, rc, stdout, stderr = get_value(module, uclcmd, state)
    elif target_state == "absent":
        cmd, rc, stdout, stderr = remove_upath(module, uclcmd, state)
    else:
        module.fail_json(msg=f"Unhandled state: {target_state}")

    result: dict[str, Any] = {
        "cmd": cmd,
        "changed": state.changed,
        "failed": rc != 0,
        "msg": state.full_msg,
        "rc": rc,
        "stderr": stderr,
        "stderr_lines": stderr.splitlines(),
        "stdout": stdout,
        "stdout_lines": stdout.splitlines(),
    }

    if module._diff:
        diffs = []
        if state.content_diff:
            diffs.append(state.content_diff)
        if state.attr_diff:
            diffs.append(state.attr_diff)
        if diffs:
            result["diff"] = diffs

    module.exit_json(**result)


if __name__ == "__main__":
    main()
