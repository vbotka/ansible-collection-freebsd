# -*- coding: utf-8 -*-
# Copyright 2025 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r"""
name: iocage
short_description: Parse iocage lists
version_added: "0.5.0"
author: Vladimir Botka (@vbotka)
description: This filter parses iocage list output.
options:
  _input:
    description:
      - A dictionary of iocage list outputs.
    type: dictionary
    elements: string
    required: true
"""

EXAMPLES = r"""
ansible_local:
  iocage:
    jails: |-
        +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
        | JID  |      NAME      | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
        +======+================+======+=======+======+=================+===================+=====+================+==========+
        | None | ansible_client | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.199/24 | -   | -              | no       |
        +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
        | None | test_111       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24 | -   | ansible_client | no       |
        +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
        | None | test_112       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.112/24 | -   | ansible_client | no       |
        +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
        | None | test_113       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.113/24 | -   | ansible_client | no       |
        +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+

result: "{{ ansible_local.iocage | vbotka.freebsd.iocage }}"
"""

RETURN = r"""
_value:
  description: The dictionary of the iocage lists.
  type: dictionary
  elements: list
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
        result[iocage_name]['iocage_jid'] = jail[0]
        result[iocage_name]['iocage_boot'] = jail[2]
        result[iocage_name]['iocage_state'] = jail[3]
        result[iocage_name]['iocage_type'] = jail[4]
        result[iocage_name]['iocage_release'] = jail[5]
        result[iocage_name]['iocage_ip4_dict'] = iocage_ip4_dict
        result[iocage_name]['iocage_ip4'] = iocage_ip4
        result[iocage_name]['iocage_ip6'] = jail[7]
        result[iocage_name]['iocage_template'] = jail[8]
        result[iocage_name]['iocage_basejail'] = jail[9]

    return result


def iocage(data):
    """parse dictionary of iocage lists"""

    results = {}

    if 'jails' in data:
        jails = data['jails']
        results['jails'] = _get_jails(jails)

    return results


class FilterModule(object):

    def filters(self):
        return {
            'iocage': iocage,
        }
