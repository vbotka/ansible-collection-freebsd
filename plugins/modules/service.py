# Copyright 2026 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r"""
module: service
short_description: FreeBSD control (start/stop/etc.) or list system services
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
description:
  - A wrapper to C(service) command.
options:
  script:
    description:
      - rc.d script name.
      - Required unless O(list_enabled) is V(true).
    type: str
  command:
    description:
      - rc.d script command.
      - Required when O(script) is specified unless O(synopsis) is V(true).
    type: str
  env:
    description:
      - Set environment before starting the script.
      - Available in FreeBSD 14.0 and later.
    type: dict
  jail:
    description:
      - Perform the given actions under the named jail.
      - The O(jail) value can be either a jail ID or a jail name.
      - Jail name doesn't work in C(iocage) jails. Use JID.
    type: str
  list_enabled:
    description:
      - List enabled services and exit.
      - This option ignores C(check_mode).
    type: bool
    default: false
  synopsis:
    description:
      - Get script commands synopsis. Return attribute C(synopsis) and exit.
      - O(script) is required. Other options are ignored.
      - This option ignores C(check_mode).
    type: bool
    default: false
    version_added: 0.6.6
  wait:
    description:
      - Wait (in seconds) for a command C(service <script> <command>) to complete before capturing status.
      - The status before and after the command is compared and if they are
        different the module returns C(changed=true).
      - The default is 500ms
    type: float
    default: 0.5
    version_added: 0.6.6
notes:
  - Supports C(check_mode) except O(synopsis) and O(list_enabled). These two
    options return data also in C(check_mode). All commands return
    C(changed=False) in C(check_mode).
  - Commands C(rcvar, status, start, stop) return parsed output.
  - The module ignores C(rc=1). For example, the binary C(service) returns
    C(rc=1) for status C(not running) or C(already running). These are not an
    errors in this module. In this case, the module returns C(rc=0) to avoid
    failure.
  - For commands that change the result of C(status) or C(enabled) the module
    reports C(changed=true) when C(status) or C(enabled) before and after the
    command C(service <script> <command>) are different. In this case, the
    module also returns the dictionary C(state).
  - Set environment C(ANSIBLE_DEBUG=true) to enable the debug output. See RETURN
    VALUES C(module_args) in the registered output of the module.
  - The functionality of the binary C(service) options C(-l), C(-R), C(-r), and
    C(-v) are not implemented.
seealso:
  - name: man service
    description: service -- control (start/stop/etc.) or list system services
    link: https://man.freebsd.org/cgi/man.cgi?service(8)
  - name: Practical rc.d scripting in BSD
    description: Reference points for further study of the design and efficient application of rc.d.
    link: https://docs.freebsd.org/en/articles/rc-scripting/
"""

EXAMPLES = r"""
---
- name: Get sshd ON/OFF knob value.
  register: out
  vbotka.freebsd.service:
    script: sshd
    command: rcvar

  out:
    ansible_facts:
      discovered_interpreter_python: /usr/local/bin/python3.11
    changed: false
    failed: false
    rc: 0
    rcvar:
      sshd_enable: 'YES'
    stderr: ''
    stderr_lines: []
    stdout: |-
      # sshd : Secure Shell Daemon
      #
      sshd_enable="YES"
      #   (default: "")
    stdout_lines:
      - '# sshd : Secure Shell Daemon'
      - '#'
      - sshd_enable="YES"
      - '#   (default: "")'
      - ''
---
- name: Get /usr/local/etc/rc.d/apcupsd status.
  register: out
  vbotka.freebsd.service:
    script: apcupsd
    command: status

  out:
    changed: false
    failed: false
    rc: 0
    status: stopped
    stderr: ''
    stderr_lines: []
    stdout: |-
        apcupsd is not running.
    stdout_lines:
      - apcupsd is not running.

---
- name: Get /usr/local/etc/rc.d/apcupsd rcvar.
  register: out
  vbotka.freebsd.service:
    script: apcupsd
    command: rcvar

  out:
    changed: false
    failed: false
    rc: 0
    rcvar:
      apcupsd_enable: 'NO'
    stderr: ''
    stderr_lines: []
    stdout: |-
        # apcupsd
        #
        apcupsd_enable="NO"
        #   (default: "")
    stdout_lines:
      - '# apcupsd'
      - '#'
      - apcupsd_enable="NO"
      - '#   (default: "")'
      - ''

---
- name: Start apcupsd.
  register: out
  vbotka.freebsd.service:
    script: apcupsd
    command: onestart

  out:

    changed: true
    failed: false
    onestart: Starting apcupsd.
    rc: 0
    status:
      post: |-
          apcupsd is running as pid 88647.
      pre: |-
          apcupsd is not running.
    stderr: ''
    stderr_lines: []
    stdout: |-
        Starting apcupsd.
    stdout_lines:
      - Starting apcupsd.

---
- name: List enabled services.
  register: out
  vbotka.freebsd.service:
    list_enabled: true

  out:
    changed: false
    failed: false
    rc: 0
    stderr: ''
    stderr_lines: []
    stdout: |-
        /etc/rc.d/auditd
        /etc/rc.d/bgfsck
        /etc/rc.d/blacklistd
        /etc/rc.d/cleanvar
        ...

---
- name: Get script sshd commands synopsis.
  register: out
  vbotka.freebsd.service:
    script: sshd
    synopsis: true

  out:
    changed: false
    failed: false
    rc: 0
    stderr: |-
        Usage: /etc/rc.d/sshd [fast|force|one|quiet] \
                              (start|stop|restart|rcvar|enable|disable|delete|enabled|describe|extracommands|configtest|keygen|reload|status|poll)
    stderr_lines:
      - 'Usage: /etc/rc.d/sshd [fast|force|one|quiet] \
                               (start|stop|restart|rcvar|enable|disable|delete|enabled|describe|extracommands|configtest|keygen|reload|status|poll)'
    stdout: ''
    stdout_lines: []
    synopsis:
      cmds:
        - start
        - stop
        - restart
        - rcvar
        - enable
        - disable
        - delete
        - enabled
        - describe
        - extracommands
        - configtest
        - keygen
        - reload
        - status
        - poll
      prefix:
        - fast
        - force
        - one
        - quiet

---
- name: Get sshd_enable values from the jails.
  register: out
  vbotka.freebsd.service:
    jail: "{{ item }}"
    script: sshd
    command: rcvar
    env:
      HOME: /
      PATH: /sbin:/bin:/usr/sbin:/usr/bin
  loop: [147, 148, 149]

- name: Display the dictionary. Use stdout.
  vars:
    jail_rcvar: "{{ dict(keys | zip(vals)) }}"
    keys: "{{ out.results
              | map(attribute='item') }}"
    vals: "{{ out.results
              | map(attribute='stdout')
              | map('community.general.jc', 'ini') }}"
  ansible.builtin.debug:
    var: jail_rcvar

  jail_rcvar:
    147:
      sshd_enable: 'YES'
    148:
      sshd_enable: 'YES'
    149:
      sshd_enable: 'YES'

- name: Display the dictionary. Use rcvar.
  vars:
    jail_rcvar: "{{ dict(keys | zip(vals)) }}"
    keys: "{{ out.results | map(attribute='item') }}"
    vals: "{{ out.results | map(attribute='rcvar') }}"
  ansible.builtin.debug:
    var: jail_rcvar

  jail_rcvar:
    147:
      sshd_enable: '"YES"'
    148:
      sshd_enable: '"YES"'
    149:
      sshd_enable: '"YES"'

---
- name: Option script is required if list_enabled=false (default).
  vbotka.freebsd.service:
    list_enabled: false

# fatal: [test_23]: FAILED! =>
#   changed: false
#   msg: Script is required.

---
- name: Option command is required if script is required.
  vbotka.freebsd.service:
    script: sshd

# fatal: [test_23]: FAILED! =>
#   changed: false
#   msg: Command is required for script sshd.
"""

RETURN = r"""
module_args:
  description: Information on how the module was invoked.
  returned: debug
  type: dict
synopsis:
  description: Script commands synopsis
  returned: When O(synopsis) is V(True)
  type: dict
"""

import itertools
import json
import re
from time import sleep

from ansible.module_utils.basic import AnsibleModule


def _command_fail(module, label, cmd, rc, stdout, stderr):
    """Command fails. Create output and terminate module."""
    cmd_str = " ".join(cmd) if isinstance(cmd, list) else str(cmd)
    module.fail_json(msg=label, cmd=cmd_str, rc=rc, stdout=stdout, stderr=stderr)


def _parse_command_output(script, command, rc, out, err):
    """Parse command output."""
    data = out if rc == 0 else err

    if command.endswith('enabled'):
        return rc == 0

    if command.endswith('rcvar'):
        if rc == 1:
            return data
        parsed = {}
        # Matches key="val" or key=val ignoring comments
        pattern = re.compile(r'^\s*([A-Za-z0-9_]+)=["\']?(.*?)["\']?\s*$')
        for line in data.splitlines():
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            match = pattern.match(line)
            if match:
                key, val = match.groups()
                parsed[key] = val
        return parsed

    if command.endswith('status'):
        data = out  # Status often returns info on stdout even with rc=1
        if re.search(rf'\b{re.escape(script)}\s+is\s+running\b', data, re.IGNORECASE):
            return 'running'
        elif re.search(rf'\b{re.escape(script)}\s+is\s+not\s+running\b', data, re.IGNORECASE):
            return 'stopped'
        return 'unknown'

    if command.endswith('start') or command.endswith('stop'):
        lines = [line.strip() for line in data.splitlines() if line.strip()]
        if not lines:
            return 'void'
        elif len(lines) == 1:
            return lines[0]
        else:
            return lines[1].rstrip('.')

    return 'Not parsed.'


def _parse_script_synopsis(module, script_path, err):
    """
    Parse script commands synopsis.
    Handles standard rc.d usage lines:
    'Usage: /etc/rc.d/sshd [fast|force|one|quiet](start|stop|restart)'
    'Usage: /usr/local/etc/rc.d/custom {start|stop|restart}'
    """
    first_line = err.splitlines()[0] if err else ""

    # Check for prefix + command pattern: [prefix](cmds) or {cmds}
    prefix_match = re.search(r'\[(.*?)\]\s*[\(\{](.*?)[\)\}]', first_line)
    simple_match = re.search(r'[\(\{](.*?)[\)\}]', first_line)

    prefix = []
    cmds = []

    if prefix_match:
        prefix = [p.strip() for p in prefix_match.group(1).split('|') if p.strip()]
        cmds = [c.strip() for c in prefix_match.group(2).split('|') if c.strip()]
    elif simple_match:
        cmds = [c.strip() for c in simple_match.group(1).split('|') if c.strip()]
    else:
        # Fallback if non-standard usage line output
        cmds = ['start', 'stop', 'restart', 'status', 'rcvar', 'reload', 'enable', 'disable', 'enabled']

    commands = cmds.copy()
    if prefix:
        commands.extend([''.join(c) for c in itertools.product(prefix, cmds)])

    return commands, cmds, prefix


def _state(module, script_path, command, cmds, wait):
    """Record state of the service."""
    commands_status = ['start', 'stop', 'restart', 'reload', 'keygen']
    commands_enabled = ['enable', 'disable']

    if any(command.endswith(s) for s in commands_status) and 'status' in cmds:
        if wait > 0:
            sleep(wait)
        rc, out, err = module.run_command([script_path, 'status'])
        if rc > 1:
            _command_fail(module, "Status check failed.", [script_path, 'status'], rc, out, err)
        return out.strip()

    if any(command.endswith(s) for s in commands_enabled) and 'enabled' in cmds:
        rc, out, err = module.run_command([script_path, 'enabled'])
        if rc > 1:
            _command_fail(module, "Enabled check failed.", [script_path, 'enabled'], rc, out, err)
        return rc == 0

    return None


def run_module():
    module_args = dict(
        script=dict(type='str'),
        command=dict(type='str'),
        env=dict(type='dict'),
        jail=dict(type='str'),
        list_enabled=dict(type='bool', default=False),
        synopsis=dict(type='bool', default=False),
        wait=dict(type='float', default=0.5),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        required_one_of=[['list_enabled', 'script']],
        mutually_exclusive=[
            ['list_enabled', 'synopsis'],
            ['list_enabled', 'command'],
        ],
        supports_check_mode=True,
    )

    p = module.params
    script = p['script']
    command = p['command']
    env = p['env']
    jail = p['jail']
    list_enabled = p['list_enabled']
    synopsis = p['synopsis']
    wait = p['wait']

    # Custom conditional validation:
    # Require 'script' only if we are NOT listing enabled services
    if not list_enabled and not script:
        module.fail_json(msg="Parameter 'script' is required unless 'list_enabled' is true.")

    # Require 'command' if running a script action (unless getting synopsis)
    if not list_enabled and not synopsis and not command:
        module.fail_json(msg=f"Parameter 'command' is required when running script '{script}'.")

    commands_state_deny = ['describe', 'enabled', 'rcvar', 'status']
    service_path = module.get_bin_path('service', required=True)

    base_cmd = [service_path]
    if jail:
        base_cmd.extend(['-j', jail])

    if env:
        for k, v in env.items():
            base_cmd.extend(['-E', f"{k}={v}"])

    # Option 1: List enabled services
    if list_enabled:
        cmd = base_cmd + ['-e']
        rc, out, err = module.run_command(cmd)
        if rc != 0:
            _command_fail(module, "Command failed.", cmd, rc, out, err)

        result = dict(
            changed=False,
            rc=rc,
            stdout='\n'.join(sorted(out.splitlines())),
            stderr=err,
        )
        if module._debug:
            result['module_args'] = json.dumps(module.params, indent=2)
        module.exit_json(**result)

    # Option 2: Script handling
    script_path = module.get_bin_path(script, opt_dirs=['/etc/rc.d', '/usr/local/etc/rc.d'])
    if not script_path:
        module.fail_json(msg=f"Could not find rc.d script '{script}' in system paths.")

    # Get script synopsis/usage
    rc, out, err = module.run_command([script_path])
    if rc > 1:
        _command_fail(module, "Failed to execute rc.d script for usage synopsis.", script_path, rc, out, err)

    commands, cmds, prefix = _parse_script_synopsis(module, script_path, err or out)

    if synopsis:
        result = dict(
            changed=False,
            rc=0,
            stdout=out,
            stderr=err,
            synopsis=dict(prefix=prefix, cmds=cmds),
        )
        if module._debug:
            result['module_args'] = json.dumps(module.params, indent=2)
        module.exit_json(**result)

    # Validate command requirement
    if not command:
        module.fail_json(msg=f"Parameter 'command' is required when running script '{script}'.")

    if command not in commands:
        module.fail_json(msg=f"Command '{command}' is invalid for {script_path}. Valid options: {commands}")

    full_cmd = base_cmd + [script, command]

    # Check mode handling
    if module.check_mode:
        module.exit_json(changed=False, msg=f"In check mode, command '{' '.join(full_cmd)}' would have run.")

    # Pre-execution state snapshot
    state_pre = None
    if not any(command.endswith(s) for s in commands_state_deny):
        state_pre = _state(module, script_path, command, cmds, 0)

    # Run service execution
    rc, out, err = module.run_command(full_cmd)

    if rc > 1:
        _command_fail(module, "Service command failed.", full_cmd, rc, out, err)

    result = dict(
        stdout=out,
        stderr=err,
        rc=0,
    )

    result[command] = _parse_command_output(script, command, rc, out, err)

    # Post-execution state assessment
    if not any(command.endswith(s) for s in commands_state_deny):
        state_post = _state(module, script_path, command, cmds, wait)
        if state_pre != state_post:
            result['changed'] = True
            result['state'] = dict(pre=state_pre, post=state_post)
        else:
            result['changed'] = False
    else:
        result['changed'] = False

    if module._debug:
        result['module_args'] = json.dumps(module.params, indent=2)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
