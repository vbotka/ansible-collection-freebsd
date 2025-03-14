# -*- coding: utf-8 -*-
# Copyright 2025 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r'''
module: service
short_description: FreeBSD control (start/stop/etc.) or list system services
version_added: 0.6.3
author:
  - Vladimir Botka (@vbotka)
description:
  - The M(vbotka.freebsd.service) module is wrapper to B(service) command.
options:
  script:
    description:
      - rc.d script name.
      - This option is required if O(list_enabled) is V(False) (default).
    type: str
  command:
    description:
      - rc.d script command.
      - This option is required if O(script) is required.
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
      - List enabled services.
    type: bool
    default: False
  synopsis:
    description:
      - Get script commands synopsis.
    type: bool
    default: False
    version_added: 0.6.5
notes:
  - Supports C(check_mode).
  - To parse C(stdout) of C(rcvar) use the filter community.general.jc('ini').
  - Set environment C(ANSIBLE_DEBUG=true) to enable the debug output. See RETURN
    VALUES C(module_args) in the registered output of the module.
  - Options C(-l), C(-R), C(-r), and C(-v) are not implemented.
seealso:
  - name: man service
    description: service -- control (start/stop/etc.) or list system services
    link: https://man.freebsd.org/cgi/man.cgi?service(8)
  - name: Practical rc.d scripting in BSD
    description: Reference points for further study of the design and efficient application of rc.d.
    link: https://docs.freebsd.org/en/articles/rc-scripting/
'''

EXAMPLES = r'''
---
- name: Get the sshd ON/OFF knob value.
  register: out
  vbotka.freebsd.service:
    script: sshd
    command: rcvar

  out:
    changed: true
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
- name: Status returns rc=1 when apcupsd is not running.
  register: out
  failed_when: out.rc > 1
  vbotka.freebsd.service:
    script: apcupsd
    command: status

  out:
    changed: false
    failed: false
    failed_when_result: false
    msg: Command failed.
    rc: 1
    stderr: ''
    stderr_lines: []
    stdout: |-
        apcupsd is not running.

---
- name: Command returns rc=1 when apcupsd does not exist.
  register: out
  failed_when: out.rc > 1
  vbotka.freebsd.service:
    script: apcupsd
    command: rcvar

  out:
    changed: false
    failed: false
    failed_when_result: false
    msg: Command failed.
    rc: 1
    stderr: ''
    stderr_lines: []
    stdout: |-
        apcupsd does not exist in /etc/rc.d or the local startup
        directories (/usr/local/etc/rc.d), or is not executable

---
- name: Start apcupsd.
  register: out
  vbotka.freebsd.service:
    script: apcupsd
    command: onestart

  out:
    changed: true
    failed: false
    rc: 0
    stderr: ''
    stderr_lines: []
    stdout: |-
        Starting apcupsd.

---
- name: List services that are enabled.
  register: out
  vbotka.freebsd.service:
    list_enabled: true

  out:
    changed: true
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
    synoposis: true

  out:
    changed: true
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

- name: Display the dictionary.
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
'''

RETURN = r'''
module_args:
  description: Information on how the module was invoked.
  returned: debug
  type: dict
'''

import itertools
import json

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_bytes


def _command_fail(module, label, cmd, rc, stdout, stderr):
    '''Command fail. Create output and terminate module.
    '''
    module.fail_json(msg=f"{label}", rc=rc, stdout=f"{stdout}", stderr=f"{stderr}")


def _command_output_parse(script, command, out):
    '''Parse command output.
    '''
    if command == 'rcvar':
        lines = out.splitlines()
        return {k: v for i in lines if i and not i.startswith('#') for k, v in [i.split('=')]}

    if command == 'status':
        if out.startswith(script + ' is not running'):
            return 'stopped'
        if out.startswith(script + ' is running'):
            return 'running'
        else:
            return 'unknown'
    return 'Not parsed. See module vbotka.freebsd.service.py'


def _script_commands_parse(module, script_path, out):
    '''Parse script commands. Expecting out form
       Usage: /etc/rc.d/sshd [fast|force|one|quiet](start|stop|restart)
    '''
    line = out.splitlines()
    if len(line) > 1:
        module.fail_json(msg=f"Expecting a single line output from {script_path}.")
    arr = line[0].split(' ')
    # TODO: test arr items
    synopsis = arr[2].split('](')
    prefix = synopsis[0][1:].split('|')
    cmds = synopsis[1][:-1].split('|')
    commands = cmds.copy()
    commands.extend((''.join(c) for c in itertools.product(prefix, cmds)))
    return (commands, cmds, prefix)


def run_module():

    module_args = dict(
        script=dict(type='str'),
        command=dict(type='str'),
        env=dict(type='dict'),
        jail=dict(type='str'),
        list_enabled=dict(type='bool', default=False),
        synopsis=dict(type='bool', default=False),)

    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)

    service_path = module.get_bin_path('service', True)
    if not service_path:
        module.fail_json(msg="Utility service not found.")

    p = module.params
    script = p['script']
    command = p['command']
    env = p['env']
    jail = p['jail']
    list_enabled = p['list_enabled']
    synopsis = p['synopsis']

    cmd = f"{service_path}"
    if jail:
        cmd += f" -j {jail}"

    # List services that are enabled.
    if list_enabled:
        cmd += " -e"
        if module.check_mode:
            module.exit_json(changed=True, msg=f"In check mode, command \"{cmd}\" would have run.")
        rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                          errors='surrogate_or_strict')
        if rc != 0:
            _command_fail(module, "Command failed.", cmd, rc, out, err)
        else:
            result = dict(changed=True,
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

    script_path = module.get_bin_path(f"/etc/rc.d/{script}", True)
    if not script_path:
        script_path = module.get_bin_path(f"/usr/local/etc/rc.d/{script}", True)
        if not script_path:
            module.fail_json(msg=f"Script {script} not found.")

    if env:
        _env = ' '.join((f"-E {k}={v}" for k, v in env.items()))
        cmd += f" {_env}"

    rc, out, err = module.run_command(to_bytes(script_path, errors='surrogate_or_strict'),
                                      errors='surrogate_or_strict')
    if rc > 1:
        _command_fail(module, "Command failed.", script_path, rc, out, err)

    commands, cmds, prefix = _script_commands_parse(module, script_path, err)

    if synopsis:
        result = dict(changed=True,
                      rc=0,
                      stdout=out,
                      stderr=err,
                      synopsis=dict(prefix=prefix,
                                    cmds=cmds)
                      )
        if module._debug:
            result['module_args'] = f"{(json.dumps(module.params, indent=2))}"
        module.exit_json(**result)

    if command is None:
        module.fail_json(msg=f"Command is required for script {script}.")

    if command not in commands:
        module.fail_json(msg=f"Command {command} not in {commands} for {script_path}.")

    cmd += f" {script} {command}"
    if module.check_mode:
        module.exit_json(changed=True, msg=f"In check mode, command \"{cmd}\" would have run.")
    rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                      errors='surrogate_or_strict')
    if rc != 0:
        _command_fail(module, "Command failed.", cmd, rc, out, err)
    else:
        result = dict(changed=True,
                      rc=rc,
                      stdout=out,
                      stderr=err,
                      )
        result[command] = _command_output_parse(script, command, out)

    if module._debug:
        result['module_args'] = f"{(json.dumps(module.params, indent=2))}"
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
