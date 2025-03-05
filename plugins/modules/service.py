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
- name: Get the apcupsd ON/OFF knob value.
  register: out
  vbotka.freebsd.service:
    script: apcupsd
    command: rcvar

  out:
    changed: true
    failed: false
    rc: 0
    stderr: ''
    stderr_lines: []
    stdout: |-
        # apcupsd
        #
        apcupsd_enable="NO"
        #   (default: "")

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

import json

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils._text import to_bytes


def _command_fail(module, label, cmd, rc, stdout, stderr):
    '''Command fail. Create output and terminate module.'''
    module.fail_json(msg=f"{label}", rc=rc, stdout=f"{stdout}", stderr=f"{stderr}")


def run_module():

    module_args = dict(
        script=dict(type='str'),
        command=dict(type='str'),
        env=dict(type='dict'),
        jail=dict(type='str'),
        list_enabled=dict(type='bool', default=False),)

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
    else:
        if env:
            _env = ' '.join((f"-E {k}={v}" for k, v in env.items()))
            cmd += f" {_env}"
        if command is None:
            module.fail_json(msg=f"Command is required for script {script}.")
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
        if module._debug:
            result['module_args'] = f"{(json.dumps(module.params, indent=2))}"
        module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
