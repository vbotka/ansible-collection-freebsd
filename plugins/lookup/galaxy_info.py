# Copyright 2025 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r"""
name: galaxy_info
author: Vladimir Botka (@vbotka)
version_added: "0.8.0"
description: Get the meta data from galaxy.yml
options:
  _attr:
    description:
      - Get the meta data attribute from galaxy.yml. For example V(version)
      - Use V(all) to get the complete meta data dictionary from galaxy.yml
    type: list
    elements: str
    required: true
"""

EXAMPLES = r"""
- name: Get the complete meta data dictionary from galaxy.yml
  ansible.builtin.debug:
    msg: "{{ lookup('vbotka.freebsd.galaxy_info', 'all') }}"

- name: Get the attributes authors and version.
  ansible.builtin.debug:
    msg: "{{ lookup('vbotka.freebsd.galaxy_info', 'authors', 'version') }}"
"""

RETURN = r"""
_raw:
  description:
    - The meta data from galaxy.yml
    - If O(_attr) is V(all) returnes C(dict), othewise C(list) of O(str).
"""

import os
import yaml
from importlib import import_module

from ansible.errors import AnsibleLookupError
from ansible.plugins.lookup import LookupBase


class LookupModule(LookupBase):
    def run(self, attr, variables=None, **kwargs):
        result = []

        collection = import_module('ansible_collections.vbotka.freebsd')
        path = os.path.dirname(collection.__file__)
        galaxy_path = os.path.join(path, 'galaxy.yml')

        if os.path.exists(galaxy_path):
            with open(galaxy_path, 'r') as f:
                data = yaml.safe_load(f)
        else:
            raise AnsibleLookupError(f'"{galaxy_path}" does not exist.')

        if 'all' in attr:
            result.append(data)
        else:
            for i in attr:
                if i in data:
                    result.append(data[i])

        return result
