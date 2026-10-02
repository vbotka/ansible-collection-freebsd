# Copyright (c) 2024 Vladimir Botka <vbotka@gmail.com>
# Copyright (c) 2024 Felix Fontein <felix@fontein.de>
# GNU General Public License v3.0+ (see LICENSES/GPL-3.0-or-later.txt or https://www.gnu.org/licenses/gpl-3.0.txt)
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from ansible.errors import AnsibleFilterError
from ansible.parsing.splitter import parse_kv

DOCUMENTATION = r"""
name: remove_keys
short_description: Remove specific keys from dictionaries in a list
version_added: "1.1.0"
author:
  - Vladimir Botka (@vbotka)
  - Felix Fontein (@felixfontein)
description: This filter removes only specified keys from a provided list of dictionaries or key-value string specifications.
options:
  _input:
    description:
      - A list of dictionaries or key-value strings (e.g. C(k1=v1 k2=v2)).
      - Top level keys must be strings.
    type: list
    elements: raw
    required: true
  target:
    description:
      - A single key or key pattern to remove, or a list of keys or keys patterns to remove.
      - If O(matching_parameter=regex) there must be exactly one pattern provided.
    type: raw
    required: true
  matching_parameter:
    description: Specify the matching option of target keys.
    type: str
    default: equal
    choices:
      equal: Matches keys of exactly one of the O(target) items.
      starts_with: Matches keys that start with one of the O(target) items.
      ends_with: Matches keys that end with one of the O(target) items.
      regex:
        - Matches keys that match the regular expression provided in O(target).
        - In this case, O(target) must be a regex string or a list with single regex string.
"""

EXAMPLES = r"""
- l:
    - {k0_x0: A0, k1_x1: B0, k2_x2: [C0], k3_x3: foo}
    - "k0_x0=A1 k1_x1=B1 k3_x3=bar"

# Remove target keys from mixed list of dicts and key=value strings
- t: [k0_x0, k1_x1]
  r: "{{ l | vbotka.freebsd.remove_keys(target=t) }}"
# Returns:
#   - {k2_x2: [C0], k3_x3: foo}
#   - {k3_x3: bar}
"""

RETURN = r"""
_value:
  description: The list of dictionaries with selected keys removed.
  type: list
  elements: dictionary
"""

import re
from collections.abc import Mapping, Sequence


def _keys_filter_params(data, matching_parameter):
    for d in data:
        if not isinstance(d, Mapping):
            raise AnsibleFilterError(f"List items must be dictionaries, got {type(d).__name__}")
        for k in d:
            if not isinstance(k, str):
                raise AnsibleFilterError(f"Dictionary keys must be strings, got {type(k).__name__}")

    valid_params = ("equal", "starts_with", "ends_with", "regex")
    if matching_parameter not in valid_params:
        raise AnsibleFilterError(
            f"matching_parameter must be one of {valid_params}, got '{matching_parameter}'"
        )


def _keys_filter_target_str(target, matching_parameter):
    if matching_parameter == "regex":
        if isinstance(target, Sequence) and not isinstance(target, (str, bytes)):
            if len(target) != 1:
                raise AnsibleFilterError(
                    f"When matching_parameter is 'regex', target must contain exactly one pattern, got {len(target)}"
                )
            target = target[0]
        if not isinstance(target, str):
            raise AnsibleFilterError(f"Regex target must be a string, got {type(target).__name__}")
        try:
            return re.compile(target)
        except re.error as e:
            raise AnsibleFilterError(f"Invalid regular expression '{target}': {e}")

    if isinstance(target, str):
        target = [target]
    elif not isinstance(target, Sequence) or isinstance(target, bytes):
        raise AnsibleFilterError(f"target must be a string or list of strings, got {type(target).__name__}")

    for item in target:
        if not isinstance(item, str):
            raise AnsibleFilterError(f"All target elements must be strings, got {type(item).__name__}")

    if matching_parameter in ("starts_with", "ends_with"):
        return tuple(target)
    return set(target)


def _normalize_dict(item):
    """Convert input item to a dictionary if it is a key=value string."""
    if isinstance(item, Mapping):
        return dict(item)
    if isinstance(item, str):
        return parse_kv(item)
    raise AnsibleFilterError(
        f"Input list items must be dictionaries or 'k=v' strings, got {type(item).__name__}"
    )


def remove_keys(data, target=None, matching_parameter="equal"):
    """remove specific keys from dictionaries in a list"""
    if not isinstance(data, Sequence) or isinstance(data, (str, bytes)):
        raise AnsibleFilterError(f"Input must be a list, got {type(data).__name__}")

    data = [_normalize_dict(d) for d in data]

    _keys_filter_params(data, matching_parameter)
    tt = _keys_filter_target_str(target, matching_parameter)

    if matching_parameter == "equal":

        def keep_key(key):
            return key not in tt

    elif matching_parameter == "starts_with":

        def keep_key(key):
            return not key.startswith(tt)

    elif matching_parameter == "ends_with":

        def keep_key(key):
            return not key.endswith(tt)

    elif matching_parameter == "regex":

        def keep_key(key):
            return tt.match(key) is None

    return [{k: v for k, v in d.items() if keep_key(k)} for d in data]


class FilterModule:
    def filters(self):
        return {
            "remove_keys": remove_keys,
        }
