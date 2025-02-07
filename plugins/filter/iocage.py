# -*- coding: utf-8 -*-
# Copyright 2025 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r"""
name: iocage
short_description: Parse iocage lists
version_added: "0.5.0"
author: Vladimir Botka (@vbotka)
description: This filter parses iocage list output.
options:
  _input:
    description:
      - Either a dictionary of iocage list outputs or a string of a single iocage list output.
      - If the option dataset is None the type of the input must be a dictionary.
      - Otherwise, the type of the input must be a string.
    required: true
  dataset:
    description:
      - Type of the iocage dataset.
    type: str
    choices: [jails, plugins, releases, templates]
    version_added: "0.5.5"
"""

EXAMPLES = r"""
---
# By default a dictionary is expected on the input.
# Put commands output into the keys:
#   jails: <iocage list --long>
#   plugins: <iocage list --plugins>
#   releases: <iocage list --release --header>
#   templates: <iocage list --template --long>
# The dictionary can be incomplete. Select datasets you want to parse. For example, jails and releases

ansible_local:
  iocage:
    jails: |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
      | JID  |      NAME      | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
      +======+================+======+=======+======+=================+===================+=====+================+==========+
      | None | ansible_client | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.199/24 | -   | -              | no       |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
      | None | test_111       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24 | -   | ansible_client | no       |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
    releases: |
      14.1-RELEASE

result: "{{ ansible_local.iocage | vbotka.freebsd.iocage }}"

result:
  jails:
    ansible_client:
      basejail: 'no'
      boot: 'off'
      ip4: 10.1.0.199
      ip4_dict:
        ip4:
          - ifc: em0
            ip: 10.1.0.199
            mask: '24'
        msg: ''
      ip6: '-'
      jid: None
      release: 14.1-RELEASE-p6
      state: down
      template: '-'
      type: jail
    test_111:
      basejail: 'no'
      boot: 'off'
      ip4: 10.1.0.111
      ip4_dict:
        ip4:
          - ifc: em0
            ip: 10.1.0.111
            mask: '24'
        msg: ''
      ip6: '-'
      jid: None
      release: 14.1-RELEASE-p6
      state: down
      template: ansible_client
      type: jail
  releases:
    - 14.1-RELEASE
---
# The type of the input must be a string if the option dataset is not None.
# For example, the output of the command 'iocage list --long'

iocage_jails: |
  +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
  | JID  |      NAME      | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
  +======+================+======+=======+======+=================+===================+=====+================+==========+
  | None | ansible_client | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.199/24 | -   | -              | no       |
  +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
  | None | test_111       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24 | -   | ansible_client | no       |
  +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+

jails:: "{{ iocage_jails | vbotka.freebsd.iocage('jails') }}"

jails:
    ansible_client:
        basejail: 'no'
        boot: 'off'
        ip4: 10.1.0.199
        ip4_dict:
            ip4:
              - ifc: em0
                ip: 10.1.0.199
                mask: '24'
            msg: ''
        ip6: '-'
        jid: None
        release: 14.1-RELEASE-p6
        state: down
        template: '-'
        type: jail
    test_111:
        basejail: 'no'
        boot: 'off'
        ip4: 10.1.0.111
        ip4_dict:
            ip4:
              - ifc: em0
                ip: 10.1.0.111
                mask: '24'
            msg: ''
        ip6: '-'
        jid: None
        release: 14.1-RELEASE-p6
        state: down
        template: ansible_client
        type: jail
---
# The type of the input must be a string if the option dataset is not None.
# For example, the output of the command 'iocage list --release'

iocage_releases: |
  14.1-RELEASE

releases: "{{ iocage_releases | vbotka.freebsd.iocage('releases') }}"

releases:
  - 14.1-RELEASE
"""

RETURN = r"""
_value:
  description:
    - A dictionary of all iocage C(datasets) present on the input if the option O(dataset) is V(None).
    - A dictionary of the iocage C(dataset) if the option O(dataset) is V(jails), V(plugins), or V(templates).
    - A list of the fetched C(releases) if the option O(dataset) is V(releases).
"""

import re


def _parse_ip4(ip4):
    ''' Return dictionary iocage_ip4_dict. default = {ip4: [], msg: ''}.
        If item matches ifc|IP or ifc|CIDR parse ifc, ip, and mask.
        Otherwise, append item to msg.
    '''

    iocage_ip4_dict = {}
    iocage_ip4_dict['ip4'] = []
    iocage_ip4_dict['msg'] = ''

    items = ip4.split(',')
    for item in items:
        if re.match('^\\w+\\|(?:\\d{1,3}\\.){3}\\d{1,3}.*$', item):
            i = re.split('\\||/', item)
            if len(i) == 3:
                iocage_ip4_dict['ip4'].append({'ifc': i[0], 'ip': i[1], 'mask': i[2]})
            else:
                iocage_ip4_dict['ip4'].append({'ifc': i[0], 'ip': i[1], 'mask': '-'})
        else:
            iocage_ip4_dict['msg'] += item

    return iocage_ip4_dict


def _get_jails(data):
    """ Parse the output of 'iocage list --long', or
                            'iocage list --long --template'
    """

    result = {}

    lines = data.splitlines()
    if len(lines) < 5:
        return result

    indices = [i for i, val in enumerate(lines[1]) if val == '|']
    for line in lines[3::2]:
        jail = [line[i + 1:j].strip() for i, j in zip(indices[:-1], indices[1:])]
        iocage_name = jail[1]
        iocage_ip4_dict = _parse_ip4(jail[6])
        if iocage_ip4_dict['ip4']:
            iocage_ip4 = ','.join([d['ip'] for d in iocage_ip4_dict['ip4']])
        else:
            iocage_ip4 = '-'
        result[iocage_name] = {}
        result[iocage_name]['jid'] = jail[0]
        result[iocage_name]['boot'] = jail[2]
        result[iocage_name]['state'] = jail[3]
        result[iocage_name]['type'] = jail[4]
        result[iocage_name]['release'] = jail[5]
        result[iocage_name]['ip4_dict'] = iocage_ip4_dict
        result[iocage_name]['ip4'] = iocage_ip4
        result[iocage_name]['ip6'] = jail[7]
        result[iocage_name]['template'] = jail[8]
        result[iocage_name]['basejail'] = jail[9]

    return result


def _get_plugins(data):
    """ Parse the output of 'iocage list --plugins'
    """

    result = {}

    lines = data.splitlines()
    if len(lines) < 5:
        return result

    indices = [i for i, val in enumerate(lines[1]) if val == '|']
    for line in lines[3::2]:
        jail = [line[i + 1:j].strip() for i, j in zip(indices[:-1], indices[1:])]
        iocage_name = jail[1]
        iocage_ip4_dict = _parse_ip4(jail[6])
        if iocage_ip4_dict['ip4']:
            iocage_ip4 = ','.join([d['ip'] for d in iocage_ip4_dict['ip4']])
        else:
            iocage_ip4 = '-'
        result[iocage_name] = {}
        result[iocage_name]['jid'] = jail[0]
        result[iocage_name]['boot'] = jail[2]
        result[iocage_name]['state'] = jail[3]
        result[iocage_name]['type'] = jail[4]
        result[iocage_name]['release'] = jail[5]
        result[iocage_name]['ip4_dict'] = iocage_ip4_dict
        result[iocage_name]['ip4'] = iocage_ip4
        result[iocage_name]['ip6'] = jail[7]
        result[iocage_name]['template'] = jail[8]
        result[iocage_name]['portal'] = jail[9]
        result[iocage_name]['doc_url'] = jail[10]

    return result


def _get_releases(data):
    """ Parse the output of 'ocage list --release --header'
    """

    result = data.splitlines()
    return result


def iocage(data, dataset=None):
    """ Parse iocage dataset(s)
    """

    results = {}
    fnc_dict = {'jails': _get_jails,
                'plugins': _get_plugins,
                'releases': _get_releases,
                'templates': _get_jails}

    if dataset:
        if dataset in fnc_dict:
            results = fnc_dict[dataset](data)
    else:
        for d in fnc_dict:
            if d in data:
                list = data[d]
                results[d] = fnc_dict[d](list)

    return results


class FilterModule(object):

    def filters(self):
        return {
            'iocage': iocage,
        }
