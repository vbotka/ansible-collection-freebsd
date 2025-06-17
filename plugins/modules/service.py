# -*- coding: utf-8 -*-
# Copyright 2025 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r"""
module: service
short_description: FreeBSD control (start/stop/etc.) or list system services
version_added: 0.6.3
author:
  - Vladimir Botka (@vbotka)
description:
  - A wrapper to C(service) command.
options:
  script:
    description:
      - rc.d script name.
      - This option is required if O(list_enabled) is V(false) (default).
    type: str
  command:
    description:
      - rc.d script command.
      - This option is required if O(script) is required and O(synopsis) is
        V(false) (default).
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
      - This option ignores the C(check_mode)
    type: bool
    default: false
  synopsis:
    description:
      - Get script commands synopsis. Return attribute C(synopsis) and exit.
      - O(script) is required. Other options are ignored.
      - This option ignores the C(check_mode)
    type: bool
    default: false
    version_added: 0.6.5
  wait:
    description:
      - Wait for a command C(service <script> <command>) to complete. Then, get
        the status.
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
    changed: false
    failed: false
    rc: 0
    rcvar:
      sshd_enable: '"YES"'
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
      apcupsd_enable: '"NO"'
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
- name: List services that are enabled.
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
- name: Git script sshd commands synopsis.
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
from time import sleep

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_bytes


def _command_fail(module, label, cmd, rc, stdout, stderr):
    """Command fails. Create output and terminate module."""
    module.fail_json(msg=f"{label}", rc=rc, stdout=f"{stdout}", stderr=f"{stderr}")


def _parse_command_output(script, command, rc, out, err):
    """Parse command output."""
    if rc == 0:
        data = out
    else:
        data = err

    if command.endswith('enabled'):
        return rc == 0

    if command.endswith('rcvar'):
        if rc == 1:
            return data
        lines = data.splitlines()
        return {k: v for i in lines if i and not i.startswith('#') for k, v in [i.split('=')]}

    if command.endswith('status'):
        data = out  # Command status returns data in stdout when rc=1
        if data.startswith(script + ' is not running'):
            return 'stopped'
        if data.startswith(script + ' is running'):
            return 'running'
        else:
            return 'unknown'

    if command.endswith('start'):
        lines = data.splitlines()
        if len(lines) == 0:
            return 'void'
        elif len(lines) == 1:
            return lines[0]
        else:
            return lines[1][:-1]

    if command.endswith('stop'):
        lines = data.splitlines()
        if len(lines) == 0:
            return 'void'
        elif len(lines) == 1:
            return lines[0]
        else:
            return lines[1][:-1]

    return 'Not parsed.'


def _parse_script_synopsis(module, script_path, err):
    """
    Parse script commands synopsis. Expecting err form
    Usage: /etc/rc.d/sshd [fast|force|one|quiet](start|stop|restart)
    """
    lines = err.splitlines()
    if len(lines) > 1:
        module.fail_json(msg=f"Expecting a single line output from '{script_path}'.")
    arr = lines[0].split(' ')
    # TODO: test arr items
    synopsis = arr[2].split('](')
    prefix = synopsis[0][1:].split('|')
    cmds = synopsis[1][:-1].split('|')
    commands = cmds.copy()
    commands.extend((''.join(c) for c in itertools.product(prefix, cmds)))
    return (commands, cmds, prefix)


def _state(module, script_path, command, cmds, wait):
    """Record state of the service."""

    # TODO: configurable
    commands_status = ['start', 'stop', 'restart', 'reload', 'keygen']
    commands_enabled = ['enable', 'disable']

    # status
    if any(command.endswith(s) for s in commands_status) and 'status' in cmds:
        if wait:
            sleep(wait)
        rc, out, err = module.run_command(to_bytes(f"{script_path} status", errors='surrogate_or_strict'),
                                          errors='surrogate_or_strict')
        if rc > 1:
            _command_fail(module, "Command failed.", f"{script_path} status", rc, out, err)
        return out

    # enabled
    if any(command.endswith(s) for s in commands_enabled) and 'enabled' in cmds:
        rc, out, err = module.run_command(to_bytes(f"{script_path} enabled", errors='surrogate_or_strict'),
                                          errors='surrogate_or_strict')
        if rc > 1:
            _command_fail(module, "Command failed.", f"{script_path} enabled", rc, out, err)
        return rc == 0


def run_module():

    module_args = dict(
        script=dict(type='str'),
        command=dict(type='str'),
        env=dict(type='dict'),
        jail=dict(type='str'),
        list_enabled=dict(type='bool', default=False),
        synopsis=dict(type='bool', default=False),
        wait=dict(type='float', default=0.5),)

    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)

    p = module.params
    script = p['script']
    command = p['command']
    env = p['env']
    jail = p['jail']
    list_enabled = p['list_enabled']
    synopsis = p['synopsis']
    wait = p['wait']

    # Do not return state for listed commands.
    commands_state_deny = ['describe', 'enabled', 'rcvar', 'status']

    service_path = module.get_bin_path('service')
    cmd = f"{service_path}"

    # Perform the given actions under the named jail.
    if jail:
        cmd += f" -j {jail}"

    # Set the environment variables before starting the script.
    if env:
        _env = ' '.join((f"-E {k}={v}" for k, v in env.items()))
        cmd += f" {_env}"

    # >>> List enabled services and exit.
    if list_enabled:
        cmd += " -e"
        rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                          errors='surrogate_or_strict')
        if rc != 0:
            _command_fail(module, "Command failed.", cmd, rc, out, err)

        result = dict(changed=False,
                      rc=rc,
                      stdout='\n'.join(sorted(out.splitlines())),
                      stderr=err,
                      )

        if module._debug:
            result['module_args'] = f"{(json.dumps(module.params, indent=2))}"
        module.exit_json(**result)

    # Run rc.d script.
    if script is None:
        module.fail_json(msg="Script is required.")

    script_path = module.get_bin_path(f"{script}", opt_dirs=['/etc/rc.d', '/usr/local/etc/rc.d'])

    # Get script's usage and parse synopsis.
    rc, out, err = module.run_command(to_bytes(script_path, errors='surrogate_or_strict'),
                                      errors='surrogate_or_strict')
    # A script without any argument returns rc=1
    if rc > 1:
        _command_fail(module, "Command failed.", script_path, rc, out, err)

    # Parse script's usage.
    commands, cmds, prefix = _parse_script_synopsis(module, script_path, err)

    # >>> Create synopsis dictionary and exit.
    if synopsis:
        result = dict(changed=False,
                      rc=0,  # We ignore rc=1. No argument is not an error here.
                      stdout=out,
                      stderr=err,
                      synopsis=dict(prefix=prefix,
                                    cmds=cmds)
                      )
        if module._debug:
            result['module_args'] = f"{(json.dumps(module.params, indent=2))}"
        module.exit_json(**result)

    # Run service <script> <command>
    if command is None:
        module.fail_json(msg=f"Command is required for script {script}.")

    if command not in commands:
        module.fail_json(msg=f"Command {command} not in {commands} for {script_path}.")

    cmd += f" {script} {command}"

    # >>> Check mode.
    if module.check_mode:
        module.exit_json(changed=False, msg=f"In check mode, command '{cmd}' would have run.")

    # Store state before the command
    if not any(command.endswith(s) for s in commands_state_deny):
        state_pre = _state(module, script_path, command, cmds, 0)

    # >>> Run service <script> <command> and exit.
    rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                      errors='surrogate_or_strict')

    # The binary service often returns rc=1 in situations like status is 'not
    # running' or 'already running?'.
    if rc > 1:
        _command_fail(module, "Command failed.", cmd, rc, out, err)

    result = dict(stdout=out,
                  stderr=err,
                  rc=0,  # We ignore rc=1. For example, 'not running' is not an error here.
                  )

    result[command] = _parse_command_output(script, command, rc, out, err)

    if not any(command.endswith(s) for s in commands_state_deny):
        state_post = _state(module, script_path, command, cmds, wait)
        if state_pre != state_post:
            result['changed'] = True
            result['state'] = dict(pre=state_pre,
                                   post=state_post,
                                   )
    else:
        result['changed'] = False

    if module._debug:
        result['module_args'] = f"{(json.dumps(module.params, indent=2))}"

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
