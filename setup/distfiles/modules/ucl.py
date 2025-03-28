#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright 2021, Vladimir Botka <vbotka@gmail.com>
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
# THIS SOFTWARE IS PROVIDED BY [COPYRIGHT HOLDER] AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL [COPYRIGHT HOLDER] OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# SPDX-License-Identifier: BSD-2-Clause

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: ucl

short_description: Manage FreeBSD UCL config files

description: A CRUD-like interface to managing UCL files.

options:
  path:
    description:
      - Path to the file to operate on.
    type: path
    aliases: [dest, file]
    required: yes
  upath:
    description:
      - The key of the variable in object notation.
    type: str
    default: .
    aliases: [variable, key]
  ipath:
    description:
      - File as additional input for combining or merging.
      - Can not be used together with I(value) or I(icontent) options.
    type: path
  icontent:
    description:
      - When used instead of I(ipath), sets the additional input
        directly to the specified string.
      - This string will be used as stdin of the command B(uclcmd).
      - Can not be used together with I(value) or I(ipath) options.
    type: str
  value:
    description:
      - Desired value of the selected I(upath).
      - Either a string, or to unset a value, the Python C(None)
        keyword (YAML Equivalent, C(null)).
      - Can not be used together with I(icontent) or I(ipath) options.
    type: raw
  vtype:
    description:
      - Make the new element this type.
    choices: [object, array, int, number, float, double, string, bool, time, date, userdata, None]
    type: str
  merge:
    description:
      - Whether the input provided by I(value), I(ipath), or
        I(icontent) should be merged.
    type: bool
    default: no
  state:
    description:
      - Desired state of the selected I(upath).
      - Whether the I(upath) should be there or not.
    type: str
    choices: [absent, present]
    default: present
    aliases: [ensure]
  delimiter:
    description:
      - Character to use as element delimiter.
    type: str
    default: .
  lang:
    description:
      - Output format language
    type: str
    choices: [ucl, yaml, json, cjson, msgpack]
    default: ucl
  chdir:
    description:
      - Change into this directory before running the command
        B(uclcmd). This is the root of the included UCL files if the
        attribute path of the .include macro is relative.
    type: path
  executable:
    description:
      - This expects an absolute path to the B(uclcmd) executable.
      - C(ANSIBLE_UCLCMD) environment variable can be used instead on
        the node where the B(uclcmd) is executed.
      - Ansible will search for B(uclcmd) when neither the option
        nor the environment variable is supplied.
    type: path
  create:
    description:
      - Used with C(state=present).
      - If specified, the file will be created if it does not already exist.
      - By default it will fail if the file is missing.
    type: bool
    default: no
  backup:
    description:
      - Create a backup file including the timestamp information so
        you can get the original file back if you somehow clobbered it
        incorrectly.
    type: bool
    default: no
extends_documentation_fragment:
  - files
  - validate
requirements:
  - uclcmd >= 0.1_3
  - libucl >= 0.8.1
notes:
  - Supports C(check_mode).
  - The check mode will fail if I(path) is missing even when C(create=yes).
  - Get missing I(upath) returns C(rc=0) and empty both C(stdout="")
    and C(stderr="").
  - Remove missing I(upath) from I(path) returns C(rc=0) and
    C(stderr=Failed to find key <upath>, skipping...)
  - The changes of I(path) content are determined by the function
    B(difflib.unified_diff). The command B(uclcmd) will not be
    executed if this function does not find any changes between the
    content of I(path) and the stdout of the dry-run command
    B(uclcmd).
seealso:
  - name: FreeBSD Universal Configuration Language
    description: Wiki
    link: https://wiki.freebsd.org/UniversalConfigurationLanguage
  - name: Source code devel/uclcmd
    description: Command line tool for working with UCL config files.
    link: https://github.com/allanjude/uclcmd
  - name: Source code libucl
    description: UCL library
    link: https://github.com/vstakhov/libucl/
  - name: Source code libucl
    description: Macros support
    link: https://github.com/vstakhov/libucl/#macros-support
author: "Vladimir Botka (@vbotka)"
'''

EXAMPLES = r'''
- name: Get FreeBSD repository of packages
  ucl:
    path: /etc/pkg/FreeBSD.conf
    upath: freebsd.url

- name: Get configuration of packages in YAML format
  ucl:
    path: /etc/pkg/FreeBSD.conf
    lang: yaml

- name: Set repo with latest versions of packages
  ucl:
    path: /etc/pkg/FreeBSD.conf
    upath: freebsd.url
    value: "pkg+http://pkg.FreeBSD.org/${ABI}/latest"

- name: Merge new value to upath in path. Set executable.
  ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey.key
    value: newvalue
    merge: yes
    executable: /usr/local/bin/uclcmd

- name: Merge new value to upath in path. Set executable by
        environment on remote node.
  ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey.key
    value: newvalue
    merge: yes
  environment:
    ANSIBLE_UCLCMD: /usr/local/bin/uclcmd

- name: Merge value from the UCL file on remote node to upath in path
  ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey.key
    ipath: merge.ucl
    merge: yes

- name: Merge value from the UCL file on controller to upath in path
  ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey.key
    icontent: "{{ lookup('file', 'merge.ucl') }}"
    merge: yes

- name: Remove upath rootkey.subkey.key from path
  ucl:
    path: /foo/bar.conf
    upath: rootkey.subkey.key
    state: absent
'''

RETURN = r'''
cmd:
  description: Run string of B(uclcmd).
  returned: always
  type: str
  sample: '/usr/local/bin/uclcmd get --ucl --delimiter . --file /etc/pkg/FreeBSD.conf freebsd.url'
rc:
  description: Return code from C(cmd).
  returned: always
  type: int
  sample: 0
stdout:
  description: Standard output from C(cmd).
  returned: always
  type: str
  sample: 'pkg+http://pkg.FreeBSD.org/${ABI}/latest'
stderr:
  description: Standard error from C(cmd).
  returned: always
  type: str
  sample: 'Failed to find destination node: freebsd.foo.bar Error: Failed to apply the set operation.'
msg:
  description: Message from the module.
  returned: always
  type: str
  sample: 'File: /etc/pkg/FreeBSD.conf; uclcmd: /usr/local/bin/uclcmd; Command get executed.'
'''

# TODO: DOCUMENTATION. Get rid of the SELinux stuff included by the
# extended documentation fragments if possible.


import difflib
import json
import os
import tempfile

from ansible.module_utils.basic import AnsibleModule, env_fallback, is_executable, json_dict_bytes_to_unicode
from ansible.module_utils._text import to_bytes, to_native


# Global variables
ucl_created = False
ucl_changed = False
ucl_message = ''
ucl_content_diff = {}
ucl_attr_diff = {}


def get_value(module, uclcmd, options):
    """ Get value of upath from path. """

    global ucl_message

    p = module.params
    path = p['path']
    chdir = p['chdir']
    b_chdir = to_bytes(chdir, errors='surrogate_or_strict')
    upath = p['upath']

    cmd = "%s get %s --file %s %s" % (uclcmd, options['run'], path, upath)
    rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                      cwd=b_chdir,
                                      errors='surrogate_or_strict')
    if rc != 0:
        command_failed(module, cmd, rc, out, err)
    ucl_message += ' Command get executed;'

    return (cmd, rc, out, err)


def set_value(module, uclcmd, options):
    """ Set value of upath in path. Optionally merge the values. """

    global ucl_message

    p = module.params
    path = p['path']
    chdir = p['chdir']
    b_chdir = to_bytes(chdir, errors='surrogate_or_strict')
    upath = p['upath']
    ipath = p['ipath']
    icontent = p['icontent']
    value = json_dict_bytes_to_unicode(p['value'])
    merge = p['merge']

    # Create *ucl_content_diff* and *ucl_changed* without any
    # modification of the *path* content. The command *cmd_before*
    # reads the file from *path*. The command *cmd* dry runs (--noop)
    # *uclcmd*.  The function *create_content_diff* creates the
    # dictionary *ucl_content_diff*. This dictionary serves the
    # purpose of displaying the changes upon the --diff option of the
    # utility *ansible-playbook*. The function also returns
    # *ucl_changed* True if *difflib.unified_diff* finds any
    # differences between the content of *path* and the output of the
    # command *cmd*.
    cmd_before = "%s get %s --file %s ." % (uclcmd, options['before'], path)
    opt = 'merge' if merge else 'set'
    if value is not None:
        cmd = "%s %s %s --file %s %s %s" % (uclcmd, opt, options['after'], path, upath, value)
    elif ipath is not None:
        cmd = "%s %s %s --file %s -i %s %s" % (uclcmd, opt, options['after'], path, ipath, upath)
    elif icontent is not None:
        cmd = "%s %s %s --file %s %s" % (uclcmd, opt, options['after'], path, upath)
    rc, out, err = create_content_diff(module, cmd_before, cmd)
    ucl_message += ' Command dry run: %s;' % cmd

    # Execute if the previous section found potential changes. The
    # function *difflib.unified_diff* compares the file's content to
    # the potential changes, created by the command. As a result, the
    # idempotency of this module is equivalent to the idempotency of
    # this function, i.e. if this function doesn't find any changes
    # the command won't be executed.
    # TODO: Optionally execute the command despite the fact that
    # difflib found nothing? If the rest of the code is left as is
    # this would validate, backup, and rewrite the file *path* without
    # indicating *changed*.
    if ucl_changed:
        ucl_message += ' diff not empty;'
        if module.check_mode:
            ucl_message += ' Check mode;'
        else:
            tmpfd, tmpfile = tempfile.mkstemp(dir=module.tmpdir)
            if value is not None:
                cmd = "%s %s %s --file %s --output %s %s %s" % (uclcmd, opt, options['run'], path, tmpfile, upath, value)
                rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                                  cwd=b_chdir,
                                                  errors='surrogate_or_strict')
            elif ipath is not None:
                cmd = "%s %s %s --file %s -i %s --output %s %s" % (uclcmd, opt, options['run'], path, ipath, tmpfile, upath)
                rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                                  cwd=b_chdir,
                                                  errors='surrogate_or_strict')
            elif icontent is not None:
                cmd = "%s %s %s --file %s --output %s %s" % (uclcmd, opt, options['run'], path, path, upath)
                rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                                  data=icontent,
                                                  cwd=b_chdir,
                                                  errors='surrogate_or_strict')
            else:
                module.fail_json(msg='Undefined state 2.')
            if rc != 0:
                command_failed(module, cmd, rc, out, err)
            ucl_message += ' Command executed: %s;' % cmd
            # Optionally validate *tempfile* and backup *path*. Write
            # *tempfile* to *path*.
            validate_backup_write(module, tmpfile)
    else:
        ucl_message += ' diff empty;'

    return (cmd, rc, out, err)


def remove_upath(module, uclcmd, options):
    """ Remove upath from path. """

    global ucl_message

    p = module.params
    path = p['path']
    chdir = p['chdir']
    b_chdir = to_bytes(chdir, errors='surrogate_or_strict')
    upath = p['upath']

    # Create *ucl_content_diff* and *ucl_changed* without any
    # modification of the *path* content. (See the details in the
    # comment of the function *set_value*.)
    cmd_before = "%s get %s --file %s ." % (uclcmd, options['before'], path)
    cmd = "%s remove %s --file %s %s" % (uclcmd, options['after'], path, upath)
    rc, out, err = create_content_diff(module, cmd_before, cmd)
    ucl_message += ' Command dry run: %s;' % cmd

    # Execute if the previous part found potential changes. (See the
    # details in the comment of the function *set_value*.)
    if ucl_changed:
        ucl_message += ' diff not empty;'
        if module.check_mode:
            ucl_message += ' Check mode;'
        else:
            tmpfd, tmpfile = tempfile.mkstemp(dir=module.tmpdir)
            cmd = "%s remove %s --file %s --output %s %s" % (uclcmd, options['run'], path, tmpfile, upath)
            rc, out, err = module.run_command(to_bytes(cmd, errors='surrogate_or_strict'),
                                              cwd=b_chdir,
                                              errors='surrogate_or_strict')
            if rc != 0:
                command_failed(module, cmd, rc, out, err)
            ucl_message += ' Command executed: %s;' % cmd

            # Optionally validate *tempfile* and backup *path*. Write
            # *tempfile* to *path*.
            validate_backup_write(module, tmpfile)
    else:
        ucl_message += ' diff empty;'

    return (cmd, rc, out, err)


def create_content_diff(module, cmd_before, cmd_after):
    """
    Create dictionary ucl_content_diff. In diff mode the attribute
    diff will be added. This dictionary will be available to the user
    in the registered variable of the task. Set ucl_changed=True if
    the diff is not empty.
    """

    global ucl_changed, ucl_content_diff

    p = module.params
    path = p['path']
    icontent = p['icontent']
    chdir = p['chdir']
    b_chdir = to_bytes(chdir, errors='surrogate_or_strict')

    # Set the context of *difflib.unified_diff*.
    udiff_number_of_context_lines = 0
    udiff_include = True

    # Read the content of the file *path* to stdout.
    rc, out_before, err = module.run_command(to_bytes(cmd_before, errors='surrogate_or_strict'),
                                             cwd=b_chdir,
                                             errors='surrogate_or_strict')
    if rc != 0:
        command_failed(module, cmd_before, rc, out_before, err)

    # Dry run the command (--noop) and get potential changes of the
    # file's content in stdout.
    rc, out, err = module.run_command(to_bytes(cmd_after, errors='surrogate_or_strict'),
                                      data=icontent,
                                      cwd=b_chdir,
                                      errors='surrogate_or_strict')
    if rc != 0:
        command_failed(module, cmd_after, rc, out, err)

    # Find diff.
    udiff = list(difflib.unified_diff(out_before.splitlines(),
                                      out.splitlines(),
                                      fromfile='%s' % path,
                                      tofile='%s' % path,
                                      n=udiff_number_of_context_lines))
    # Set *ucl_changed* and fill the dictionary *ucl_content_diff* if
    # any changes have been found.
    ucl_changed = len(udiff) > 0
    if ucl_changed:
        ucl_content_diff['before'] = '%s\n' % ('\n'.join(list(difflib.restore(udiff, 1))))
        ucl_content_diff['after'] = '%s\n' % ('\n'.join(list(difflib.restore(udiff, 2))))
        ucl_content_diff['before_header'] = '%s (content)' % path
        ucl_content_diff['after_header'] = '%s (content)' % path
        # Include diff in diff mode.
        if udiff_include:
            ucl_content_diff['diff'] = '%s\n' % ('\n'.join(udiff))

    return (rc, out, err)


def command_failed(module, cmd, rc, out, err):
    """ Command failed. """

    module.fail_json(msg='Command failed:\ncmd: %s\nrc: %s\nstdout: %s\nstderr: %s' % (cmd, rc, out, err))


def validate_backup_write(module, tmpfile):
    """ Optionally validate tmpfile and backup path. Write tmpfile to path. """

    global ucl_message

    p = module.params
    path = p['path']
    backup = p['backup']
    unsafe_writes = p['unsafe_writes']

    # Use the methods provided by *AnsibleModule* to validate the
    # content of *tmpfile*, create backup of the file *path*, and move
    # *tmpfile* to *path* if valid.
    validate = module.params.get('validate', None)
    valid = not validate
    if validate is not None:
        if '%s' not in validate:
            module.fail_json(msg='Validate must contain %%s: %s' % validate)
        rc, out, err = module.run_command(to_bytes(validate % tmpfile, errors='surrogate_or_strict'))
        valid = rc == 0
        if rc != 0:
            module.fail_json(msg='Failed to validate:\ncmd: %s\nrc: %s\nstdout: %s\nstderr: %s' % (validate, rc, out, err))
        ucl_message += ' Validated;'
    if valid:
        if backup:
            backup_path = module.backup_local(path)
            ucl_message += ' Backup created: %s;' % (backup_path)
        module.atomic_move(tmpfile,
                           to_native(os.path.realpath(to_bytes(path, errors='surrogate_or_strict')), errors='surrogate_or_strict'),
                           unsafe_writes=unsafe_writes)
        ucl_message += ' Content changed;'


def set_file(module):
    """
    Create empty file path if missing and create=yes. Fail otherwise.
    Check mode will fail if path is missing even when create=yes.
    """

    global ucl_created, ucl_changed, ucl_message, ucl_attr_diff

    p = module.params
    path = p['path']
    b_path = to_bytes(path, errors='surrogate_or_strict')
    create = p['create']

    if not os.path.exists(b_path):
        if not create:
            module.fail_json(msg='File %s does not exist! Creation not allowed.' % path)
        else:
            if module.check_mode:
                # TODO: Create temporary empty file if *create=yes*?
                module.fail_json(msg='File %s does not exist! Will not be created in check mode.' % path)
            else:
                open(path, 'w').close()
                ucl_created = True
                ucl_changed = True
                ucl_message += ' File %s created;' % path

    # Use the methods provided by *AnsibleModule* to set the arguments
    # of the file *path*.
    attr_diff = {}
    attr_diff['before_header'] = '%s (file attributes)' % path
    attr_diff['after_header'] = '%s (file attributes)' % path
    file_args = module.load_file_common_arguments(module.params)
    # file_args = module.load_file_common_arguments(module.params, path=None)
    # Ansible 2.9 error:
    # in set_file: TypeError: load_file_common_arguments() got an
    # unexpected keyword argument 'path'
    if module.set_fs_attributes_if_different(file_args, False, attr_diff):
        # Do not report changes if created.
        if not ucl_created:
            ucl_attr_diff = attr_diff
            ucl_changed = True
            ucl_message += ' Ownership or permissions changed;'


def run_module():
    """ Run module """

    module_args = dict(
        path=dict(type='path', aliases=['dest', 'file'], required=True),
        upath=dict(type='str', aliases=['variable', 'key'], default='.'),
        ipath=dict(type='path'),
        icontent=dict(type='str'),
        value=dict(type='raw'),
        vtype=dict(type='str', choices=['object', 'array', 'int', 'number', 'float', 'double', 'string', 'bool', 'time', 'date', 'userdata', 'None']),
        merge=dict(type='bool', default=False),
        state=dict(type='str', aliases=['ensure'], default='present', choices=['absent', 'present']),
        delimiter=dict(type='str', default='.'),
        lang=dict(type='str', default='ucl', choices=['ucl', 'yaml', 'json', 'cjson', 'msgpack']),
        chdir=dict(type='path'),
        executable=dict(type='path', fallback=(env_fallback, ['ANSIBLE_UCLCMD'])),
        create=dict(type='bool', default=False),
        backup=dict(type='bool', default=False),
        validate=dict(type='str'),
    )

    module = AnsibleModule(argument_spec=module_args,
                           add_file_common_args=True,
                           supports_check_mode=True,
                           mutually_exclusive=[('value', 'ipath', 'icontent'), ],
                           )

    p = module.params
    path = p['path']
    ipath = p['ipath']
    icontent = p['icontent']
    value = json_dict_bytes_to_unicode(p['value'])
    vtype = p['vtype']
    state = p['state']
    delimiter = p['delimiter']
    lang = p['lang']

    # Begin message
    global ucl_message
    ucl_message = 'File: %s;' % path

    # Find executable uclcmd
    if p['executable'] is not None:
        uclcmd = p['executable']
        if not is_executable(uclcmd):
            module.fail_json(msg='%s not executable!' % uclcmd)
    else:
        uclcmd = module.get_bin_path('uclcmd', True)
        if not uclcmd:
            module.fail_json(msg='Utility uclcmd not found!')
    ucl_message += ' uclcmd: %s;' % uclcmd

    # Options of the *uclcmd* utility. The *before* options are used to
    # read the content of the file *path*. The *after* options are used
    # to dry run the command. The purpose is to compare the stdout of
    # the command to the content of the file *path*. If the contents
    # are different the *run* options are used to execute the command.
    options = {}
    options['before'] = '--%s --delimiter %s' % (lang, delimiter)
    options['run'] = '--%s --delimiter %s' % (lang, delimiter)
    if vtype is not None:
        options['run'] += ' --type %s' % (vtype)
    options['after'] = options['run'] + ' --noop'

    # Set file *path*. Create empty file *path* if missing and
    # *create=yes*. Fail otherwise.
    set_file(module)

    # Set value of *upath* in *path* if any from *value*, *ipath*, or
    # *icontent* is defined.
    if state == 'present' and (value is not None or ipath is not None or icontent is not None):
        cmd, rc, stdout, stderr = set_value(module, uclcmd, options)

    # Get value of *upath* from *path* if none from *value*, *ipath*,
    # and *icontent* is defined.
    elif state == 'present':
        cmd, rc, stdout, stderr = get_value(module, uclcmd, options)

    # Remove *upath* from *path*.
    elif state == 'absent':
        cmd, rc, stdout, stderr = remove_upath(module, uclcmd, options)

    else:
        module.fail_json(msg='Undefined state 1.')

    # Close the *message* and create *result*.
    ucl_message = ucl_message[:-1] + '.'
    result = dict(cmd=cmd,
                  changed=ucl_changed,
                  failed=False if rc == 0 else True,
                  msg=ucl_message,
                  rc=rc,
                  stderr=stderr,
                  stderr_lines=stderr.splitlines(),
                  stdout=stdout,
                  stdout_lines=stdout.splitlines(),
                  )
    if module._diff:
        result['diff'] = [ucl_content_diff, ucl_attr_diff]
    if module._debug:
        result['module_args'] = '%s' % json.dumps(module.params, indent=4)

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
