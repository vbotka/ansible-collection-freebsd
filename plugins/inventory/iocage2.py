# Copyright (c) 2026 Vladimir Botka <vbotka@gmail.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations

DOCUMENTATION = r"""
name: iocage2
short_description: iocage_lib-powered iocage inventory source
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
requirements:
  - python312, py312-iocage and py312-libzfs on the target host.
description:
  - Get inventory hosts from the iocage jail manager running on O(host) using native iocage_lib python modules.
  - By default, O(host) is V(localhost). If O(host) is not V(localhost), the control node connects via SSH/sudo.
  - Uses a configuration file ending in C(iocage2.yml) or C(iocage2.yaml).
extends_documentation_fragment:
  - ansible.builtin.constructed
  - ansible.builtin.inventory_cache
options:
  plugin:
    description: Name of this plugin. Must be V(vbotka.freebsd.iocage2).
    required: true
    choices: ['vbotka.freebsd.iocage2']
    type: str
  host:
    description: The IP/hostname of the iocage target host.
    type: str
    default: localhost
  user:
    description: User account to connect to O(host) over SSH.
    type: str
  sudo:
    description: Enable execution as root on the target node.
    type: bool
    default: false
  sudo_preserve_env:
    description: Preserve environment if O(sudo) is enabled.
    type: bool
    default: false
  get_properties:
    description:
      - Get jails' properties. Creates dictionary C(iocage_properties) for each added host.
    type: bool
    default: false
  env:
    description: User's environment on O(host).
    type: dict
    default: {}
  hooks_results:
    description:
      - List of paths to files inside jails to read remotely.
    type: list
    elements: path
  inventory_hostname_tag:
    description:
      - Tag name in C(iocage properties notes) containing the jail alias.
    type: str
  inventory_hostname_required:
    description:
      - Requires O(inventory_hostname_tag) to be present on all jails.
    type: bool
    default: false
"""

EXAMPLES = r"""
---
# Remote execution over SSH with sudo
plugin: vbotka.freebsd.iocage2
host: 10.1.0.73
user: admin
sudo: true
get_properties: true
hooks_results:
  - /var/db/dhclient-hook.address.epair0b
compose:
  ansible_host: iocage_ip4
groups:
  test: inventory_hostname.startswith('test')
keyed_groups:
  - prefix: release
    key: iocage_release
  - prefix: state
    key: iocage_state
"""

import base64
import json
import os
import re
import shlex
from subprocess import PIPE, Popen

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.module_utils.common.text.converters import to_text
from ansible.plugins.inventory import BaseInventoryPlugin, Cacheable, Constructable
from ansible.utils.display import Display

display = Display()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# INLINED REMOTE ENGINE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REMOTE_ENGINE_CODE = r"""
import json, os, subprocess, sys, traceback

def get_active_jids():
    jids = {}
    try:
        out = subprocess.check_output(["jls", "-h", "jid", "name", "path"], text=True)
        lines = out.strip().split("\n")[1:]
        for line in lines:
            p = line.split()
            if len(p) >= 3:
                jid, k_name, path = p[0], p[1], p[2]
                jids[path] = jid
                jids[k_name] = jid
                if k_name.startswith("iocage-"):
                    jids[k_name.replace("iocage-", "")] = jid
    except Exception:
        pass
    return jids

def main():
    try:
        import libzfs
        from iocage_lib.ioc_json import IOCJson

        zfs = libzfs.ZFS()
        pool_name = None

        for p in zfs.pools:
            try:
                zfs.get_dataset(f"{p.name}/iocage")
                pool_name = p.name
                break
            except libzfs.ZFSException:
                continue

        if not pool_name:
            print(json.dumps({"pool": None, "jails": {}}))
            return

        try:
            jails_ds = zfs.get_dataset(f"{pool_name}/iocage/jails")
        except libzfs.ZFSException:
            print(json.dumps({"pool": pool_name, "jails": {}}))
            return

        jids = get_active_jids()
        jails_map = {}

        for child in jails_ds.children:
            name = child.name.split("/")[-1]
            if not name or name in ["jails", "templates", "+"]:
                continue

            mp = child.properties["mountpoint"].value
            if not mp or mp in ["none", "readonly", "-"]:
                mp = f"/{pool_name}/iocage/jails/{name}"

            all_props = {}
            try:
                ioc_json = IOCJson(location=mp)
                all_props = ioc_json.json_get_value("all")
            except Exception:
                pass

            if not isinstance(all_props, dict):
                all_props = {}

            # Parse template from ZFS origin or property keys
            tpl = "-"
            origin_str = ""
            try:
                if "origin" in child.properties:
                    origin_str = str(child.properties["origin"].value)
            except Exception:
                pass

            for tk in ["source_template", "cloned_from"]:
                tv = all_props.get(tk)
                if tv and str(tv).strip().lower() not in ["none", "", "-", "null", "false", "0", "1", "true"]:
                    tpl = str(tv).strip()
                    break

            if tpl == "-":
                if "/iocage/templates/" in origin_str:
                    tpl = origin_str.split("/iocage/templates/")[1].split("@")[0]
                elif "/iocage/jails/" in origin_str:
                    tpl = origin_str.split("/iocage/jails/")[1].split("@")[0]
                else:
                    notes_val = str(all_props.get("notes", "")).strip()
                    if "template=" in notes_val:
                        tags = dict(tag.split("=", 1) for tag in notes_val.split() if "=" in tag)
                        if "template" in tags:
                            tpl = tags["template"]

            root_p = os.path.join(mp, "root")
            uuid = all_props.get("host_hostuuid", name)
            jid = jids.get(mp, jids.get(root_p, jids.get(name, jids.get(uuid, "None"))))
            state_str = "up" if jid != "None" else "down"

            boot = "on" if str(all_props.get("boot", "0")).lower() in ["1", "on", "yes", "true"] else "off"
            base = "yes" if str(all_props.get("basejail", "0")).lower() in ["1", "on", "yes", "true"] else "no"

            raw_type = all_props.get("type", "jail")
            jail_type = "jail" if str(raw_type).lower() in ["filesystem", "none", "", "-"] else str(raw_type)

            raw_ip6 = str(all_props.get("ip6_addr", "-")).strip()
            clean_ip6 = "-" if raw_ip6.lower() in ["none", "none,none", "", "null"] else raw_ip6

            all_props["state"] = state_str
            all_props["boot"] = "1" if boot == "on" else "0"
            all_props["type"] = jail_type

            jails_map[name] = {
                "jid": jid,
                "boot": boot,
                "state": state_str,
                "type": jail_type,
                "release": str(all_props.get("release", "-")),
                "raw_ip4": str(all_props.get("ip4_addr", "-")),
                "ip6": clean_ip6,
                "template": tpl,
                "basejail": base,
                "properties": {str(k): str(v) for k, v in all_props.items()}
            }

        print(json.dumps({"pool": pool_name, "jails": jails_map}))
    except ImportError as e:
        print(json.dumps({"error": f"Failed to import required libraries on target host: {str(e)}"}))
    except Exception as e:
        print(json.dumps({"error": f"Remote engine exception: {str(e)}\n{traceback.format_exc()}"}))

if __name__ == "__main__":
    main()
"""


def _parse_ip4(ip4_str, default_ifc="dhcp"):
    """Format IPv4 address into the standard iocage_ip4_dict structure."""
    iocage_ip4_dict = {"ip4": [], "msg": ""}
    if not ip4_str or ip4_str in ["-", "none", "DHCP"]:
        return iocage_ip4_dict

    items = ip4_str.split(",")
    for item in items:
        if re.match(r"^\w+\|(?:[0-9]{1,3}\.){3}[0-9]{1,3}.*$", item):
            parts = re.split(r"\||/", item)
            if len(parts) == 3:
                iocage_ip4_dict["ip4"].append(
                    {"ifc": parts[0], "ip": parts[1], "mask": parts[2]}
                )
            else:
                iocage_ip4_dict["ip4"].append(
                    {"ifc": parts[0], "ip": parts[1], "mask": "-"}
                )
        else:
            # Handle plain IP strings (e.g. injected from dhclient hooks)
            clean_ip = item.strip()
            if re.match(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$", clean_ip):
                iocage_ip4_dict["ip4"].append(
                    {"ifc": default_ifc, "ip": clean_ip, "mask": "-"}
                )
            else:
                iocage_ip4_dict["msg"] += item
    return iocage_ip4_dict


class InventoryModule(BaseInventoryPlugin, Constructable, Cacheable):
    NAME = "vbotka.freebsd.iocage2"

    def verify_file(self, path):
        valid = False
        if super().verify_file(path):
            if path.endswith(("iocage2.yaml", "iocage2.yml")):
                valid = True
            else:
                self.display.vvv(
                    'Skipping due to inventory source not ending in "iocage2.yaml" nor "iocage2.yml"'
                )
        return valid

    def parse(self, inventory, loader, path, cache=True):
        super().parse(inventory, loader, path)

        self._read_config_data(path)
        cache_key = self.get_cache_key(path)

        user_cache_setting = self.get_option("cache")
        attempt_to_read_cache = user_cache_setting and cache
        cache_needs_update = user_cache_setting and not cache

        if attempt_to_read_cache:
            try:
                results = self._cache[cache_key]
            except KeyError:
                cache_needs_update = True

        if not attempt_to_read_cache or cache_needs_update:
            results = self.get_inventory(path)

        if cache_needs_update:
            self._cache[cache_key] = results

        self.populate(results)

    def get_inventory(self, path):
        host = self.get_option("host")
        sudo = self.get_option("sudo")
        sudo_preserve_env = self.get_option("sudo_preserve_env")
        env = self.get_option("env")
        get_properties = self.get_option("get_properties")
        hooks_results = self.get_option("hooks_results")
        inventory_hostname_tag = self.get_option("inventory_hostname_tag")
        inventory_hostname_required = self.get_option("inventory_hostname_required")

        b64_code = base64.b64encode(REMOTE_ENGINE_CODE.encode("utf-8")).decode("utf-8")
        python_exec = f"import base64; exec(base64.b64decode('{b64_code}').decode('utf-8'))"

        my_env = os.environ.copy()
        cmd_list = []

        if host == "localhost":
            my_env.update({str(k): str(v) for k, v in env.items()})
            if sudo:
                cmd_list.extend(["sudo", "-n"])
                if sudo_preserve_env:
                    cmd_list.append("--preserve-env")
            cmd_list.extend(["python3.12", "-c", python_exec])
        else:
            user = self.get_option("user")
            cmd_list.extend(["ssh", f"{user}@{host}"])

            remote_cmd = []
            if env:
                remote_cmd.extend([f"{k}={v}" for k, v in env.items()])
            if sudo:
                remote_cmd.extend(["sudo", "-n"])
                if sudo_preserve_env:
                    remote_cmd.append("--preserve-env")

            remote_cmd.extend(["python3.12", "-c", shlex.quote(python_exec)])
            cmd_list.append(" ".join(remote_cmd))

        try:
            p = Popen(cmd_list, stdout=PIPE, stderr=PIPE, env=my_env)
            stdout, stderr = p.communicate()

            t_stdout = to_text(stdout, errors="surrogate_or_strict").strip()
            t_stderr = to_text(stderr, errors="surrogate_or_strict").strip()

            if p.returncode != 0:
                raise AnsibleError(
                    f"Failed to run inventory engine (rc={p.returncode}).\nCommand: {' '.join(cmd_list)}\nStderr: {t_stderr}"
                )

            if not t_stdout:
                raise AnsibleError(
                    f"Inventory engine returned empty output.\nCommand: {' '.join(cmd_list)}\nStderr: {t_stderr}"
                )

            remote_data = json.loads(t_stdout)
            if "error" in remote_data:
                raise AnsibleError(f"Inventory engine error: {remote_data['error']}")
        except json.JSONDecodeError as e:
            raise AnsibleError(
                f"Invalid JSON received from inventory engine: {e}\nRaw output: {t_stdout}\nStderr: {t_stderr}"
            ) from e
        except Exception as e:
            raise AnsibleParserError(
                f"Failed to execute inventory engine on {host}: {e}"
            ) from e

        results = {"_meta": {"hostvars": {}}}
        iocage_pool = remote_data.get("pool")
        jails_raw = remote_data.get("jails", {})

        for jail_name, info in jails_raw.items():
            ip4_dict = _parse_ip4(info["raw_ip4"])
            clean_ip4 = (",".join([d["ip"] for d in ip4_dict["ip4"]]) if ip4_dict["ip4"] else "-")

            host_entry = {
                "iocage_jid": info["jid"],
                "iocage_boot": info["boot"],
                "iocage_state": info["state"],
                "iocage_type": info["type"],
                "iocage_release": info["release"],
                "iocage_ip4_dict": ip4_dict,
                "iocage_ip4": clean_ip4,
                "iocage_ip6": info["ip6"],
                "iocage_template": info["template"],
                "iocage_basejail": info["basejail"],
            }

            if get_properties:
                host_entry["iocage_properties"] = info["properties"]

            results["_meta"]["hostvars"][jail_name] = host_entry

        if hooks_results and iocage_pool:
            for hostname in list(results["_meta"]["hostvars"].keys()):
                iocage_hooks = []
                for hook in hooks_results:
                    hook_path = (f"/{iocage_pool}/iocage/jails/{hostname}/root{hook}")

                    if host == "localhost":
                        cmd_cat = []
                        if sudo:
                            cmd_cat.extend(["sudo", "-n"])
                            if sudo_preserve_env:
                                cmd_cat.append("--preserve-env")
                        cmd_cat.extend(["cat", hook_path])
                    else:
                        user = self.get_option("user")
                        cat_parts = [f"{k}={v}" for k, v in env.items()]
                        if sudo:
                            cat_parts.extend(["sudo", "-n"])
                            if sudo_preserve_env:
                                cat_parts.append("--preserve-env")
                        cat_parts.extend(["cat", hook_path])
                        cmd_cat = ["ssh", f"{user}@{host}", " ".join(cat_parts)]

                    try:
                        p = Popen(cmd_cat, stdout=PIPE, stderr=PIPE, env=my_env)
                        stdout, stderr = p.communicate()
                        if p.returncode != 0:
                            iocage_hooks.append("-")
                        else:
                            iocage_hooks.append(
                                to_text(
                                    stdout, errors="surrogate_or_strict"
                                ).strip()
                            )
                    except Exception:
                        iocage_hooks.append("-")

                results["_meta"]["hostvars"][hostname]["iocage_hooks"] = iocage_hooks

                # If IP address could not be parsed from ip4_addr, resolve from hooks
                current_ip4 = results["_meta"]["hostvars"][hostname]["iocage_ip4"]
                if current_ip4 in ["-", "none", "DHCP"]:
                    for idx, hook_res in enumerate(iocage_hooks):
                        if hook_res and hook_res != "-":
                            hook_def = hooks_results[idx]
                            match = re.search(r"dhclient-hook\.address\.([a-zA-Z0-9]+)", hook_def)
                            default_ifc = match.group(1) if match else "dhcp"
                            parsed_hook_ip = _parse_ip4(hook_res, default_ifc=default_ifc)
                            if parsed_hook_ip["ip4"]:
                                results["_meta"]["hostvars"][hostname]["iocage_ip4_dict"] = parsed_hook_ip
                                results["_meta"]["hostvars"][hostname]["iocage_ip4"] = ",".join(
                                    [d["ip"] for d in parsed_hook_ip["ip4"]]
                                )
                                break

        if inventory_hostname_tag:
            if not get_properties:
                raise AnsibleError(
                    "Jail properties are needed to use inventory_hostname_tag. Enable get_properties"
                )
            update = {}
            for hostname, host_vars in results["_meta"]["hostvars"].items():
                notes_str = host_vars.get("iocage_properties", {}).get("notes", "")
                tags = dict(tag.split("=", 1) for tag in notes_str.split() if "=" in tag)
                if inventory_hostname_tag in tags:
                    update[hostname] = tags[inventory_hostname_tag]
                elif inventory_hostname_required:
                    raise AnsibleError(
                        f"Mandatory tag {inventory_hostname_tag!r} is missing in the properties notes."
                    )
            for hostname, alias in update.items():
                results["_meta"]["hostvars"][alias] = results["_meta"]["hostvars"].pop(hostname)

        return results

    def populate(self, results):
        strict = self.get_option("strict")

        for hostname, host_vars in results["_meta"]["hostvars"].items():
            self.inventory.add_host(hostname, group="all")
            for var, value in host_vars.items():
                self.inventory.set_variable(hostname, var, value)
            self._set_composite_vars(
                self.get_option("compose"), host_vars, hostname, strict=strict
            )
            self._add_host_to_composed_groups(
                self.get_option("groups"), host_vars, hostname, strict=strict
            )
            self._add_host_to_keyed_groups(
                self.get_option("keyed_groups"),
                host_vars,
                hostname,
                strict=strict,
            )
