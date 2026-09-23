# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from typing import Any


DOCUMENTATION = r"""
name: clean_unsafe
short_description: Recursively remove __ansible_unsafe wrappers
version_added: 1.1.0
author:
  - Vladimir Botka (@vbotka)
description:
  - Recursively traverses nested data structures (dictionaries, lists, sets, tuples)
    and removes C(__ansible_unsafe) wrapper dictionaries or Ansible unsafe string objects.
  - Converts unwrapped values to their clean native Python types, allowing serialization
    to YAML or JSON without emitting C(__ansible_unsafe) keys.
options:
  _input:
    description: Data structure or scalar containing C(__ansible_unsafe) objects.
    type: raw
    required: true
"""

EXAMPLES = r"""
# Raw structure with __ansible_unsafe wrappers:
# jail_vars:
#   log-server-01:
#     iocage_basejail:
#       __ansible_unsafe: 'no'
#     iocage_ip4:
#       __ansible_unsafe: 172.16.99.10
#     iocage_hooks:
#       - __ansible_unsafe: '-'

- name: Clean unsafe wrapper objects from inventory hostvars
  ansible.builtin.set_fact:
    clean_hostvars: "{{ jail_vars | vbotka.freebsd.clean_unsafe }}"

# clean_hostvars is now:
#   log-server-01:
#     iocage_basejail: 'no'
#     iocage_ip4: '172.16.99.10'
#     iocage_hooks:
#       - '-'

- name: Display cleaned dictionary as YAML without __ansible_unsafe artifacts
  ansible.builtin.debug:
    msg: "{{ jail_vars | vbotka.freebsd.clean_unsafe | to_nice_yaml }}"
"""

RETURN = r"""
_value:
  description: The cleaned data structure with all C(__ansible_unsafe) wrappers stripped.
  type: raw
"""


def clean_unsafe(data: Any) -> Any:
    """Recursively strip `__ansible_unsafe` wrapper objects from data structures."""
    if isinstance(data, dict):
        if len(data) == 1 and "__ansible_unsafe" in data:
            return clean_unsafe(data["__ansible_unsafe"])
        return {k: clean_unsafe(v) for k, v in data.items()}
    if isinstance(data, list):
        return [clean_unsafe(item) for item in data]
    if isinstance(data, tuple):
        return tuple(clean_unsafe(item) for item in data)
    if isinstance(data, set):
        return {clean_unsafe(item) for item in data}

    # If it's an AnsibleUnsafe wrapper type directly, cast it to standard native str
    if hasattr(data, "__class__") and "AnsibleUnsafe" in data.__class__.__name__:
        return str(data)

    return data


class FilterModule:
    """Ansible jinja2 filter to clean __ansible_unsafe objects."""

    def filters(self) -> dict[str, Any]:
        return {
            "clean_unsafe": clean_unsafe,
            "strip_unsafe": clean_unsafe,
        }
