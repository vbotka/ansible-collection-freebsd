# Copyright 2026 Vladimir Botka <vbotka@gmail.com>
# Simplified BSD License, https://opensource.org/licenses/BSD-2-Clause
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r'''
---
module: cgetent
short_description: A wrapper to the BSD cgetent capability database parser
description:
  - Runs capability database queries on BSD systems against files like C(/etc/login.conf),
    C(/etc/printcap), or C(/etc/termcap).
  - Similar to M(ansible.builtin.getent), results are registered in the C(ansible_facts) namespace.
  - Supports recursive capability inheritance via table continuation (C(tc=)).
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
options:
  database:
    description:
      - The capability file or database path to query (e.g., C(/etc/login.conf)).
    type: path
    required: true
  key:
    description:
      - Key or record name to look up (e.g., C(default), C(staff), C(daemon)).
      - If omitted, all records found in the capability database will be retrieved.
    type: str
  split:
    description:
      - Character used to separate sub-values in string capabilities (e.g., C(,) in environment variables).
    type: str
  fail_key:
    description:
      - If set to C(true), the module will fail if the requested C(key) is not found.
      - If set to C(false), missing keys will return an empty record or null.
    type: bool
    default: true
  resolve_tc:
    description:
      - Whether to recursively resolve table continuations (C(tc=)).
      - When set to C(true), capabilities from inherited records are merged, with current entry attributes taking precedence.
    type: bool
    default: true
'''

EXAMPLES = r'''
- name: Fetch default login class attributes from /etc/login.conf
  vbotka.freebsd.cgetent:
    database: /etc/login.conf
    key: default

- name: Retrieve developer login class with recursive inheritance resolved
  vbotka.freebsd.cgetent:
    database: /etc/login.conf
    key: developer
    resolve_tc: true

- name: Retrieve printcap raw record without tc= resolution
  vbotka.freebsd.cgetent:
    database: /etc/printcap
    key: lp
    resolve_tc: false
    fail_key: false

- name: Fetch all records from /etc/login.conf
  vbotka.freebsd.cgetent:
    database: /etc/login.conf
'''

RETURN = r'''
ansible_facts:
  description: Facts populated with retrieved capability database records.
  returned: always
  type: dict
  contains:
    cgetent:
      description: Dictionary mapping queried record keys to their capability key-value pairs.
      type: dict
'''

import os
import re
from typing import Any
from ansible.module_utils.basic import AnsibleModule


def parse_raw_records(filepath: str, split_char: str | None = None) -> dict[str, dict[str, Any]]:
    """
    Parses a BSD capability database into a raw dictionary mapping record
    names to their immediate capabilities, preserving 'tc' keys.
    """
    records: dict[str, dict[str, Any]] = {}

    with open(filepath, 'r', encoding='utf-8') as f:
        raw_lines = f.readlines()

    # Step 1: Strip comments and collect non-empty lines
    cleaned_lines: list[str] = []
    for line in raw_lines:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        cleaned_lines.append(line)

    # Step 2: Join backslash continuation lines
    content = " ".join(cleaned_lines).replace(r"\ ", "")

    # Step 3: Split into individual record blocks
    raw_entries = re.split(r':(?=\s*[a-zA-Z0-9_.-]+[:|])', content)

    for entry in raw_entries:
        entry = entry.strip().strip(':')
        if not entry:
            continue

        parts = [p.strip() for p in entry.split(':') if p.strip()]
        if not parts:
            continue

        names = [n.strip() for n in parts[0].split('|')]
        capabilities: dict[str, Any] = {}

        for cap in parts[1:]:
            if '=' in cap:
                k, v = cap.split('=', 1)
                if split_char:
                    capabilities[k] = [val.strip() for val in v.split(split_char)]
                else:
                    capabilities[k] = v
            elif '#' in cap:
                k, v = cap.split('#', 1)
                try:
                    capabilities[k] = int(v)
                except ValueError:
                    capabilities[k] = v
            elif cap.endswith('@'):
                capabilities[cap[:-1]] = None  # Disabled capability indicator
            else:
                capabilities[cap] = True       # Boolean capability

        for name in names:
            records[name] = capabilities

    return records


def resolve_record(
    name: str,
    raw_records: dict[str, dict[str, Any]],
    visited: list[str] | None = None,
) -> dict[str, Any]:
    """
    Recursively resolves 'tc=' table continuations for a given record.
    Child capabilities take precedence over parent capabilities.
    Detects and prevents cyclic inheritance loops.
    """
    if visited is None:
        visited = []

    if name in visited:
        cycle_chain = " -> ".join(visited + [name])
        raise ValueError(f"Cyclic tc= reference detected: {cycle_chain}")

    visited.append(name)
    current = raw_records.get(name, {}).copy()

    if 'tc' in current:
        parent_name = current.pop('tc')
        if parent_name not in raw_records:
            raise KeyError(f"Referenced tc='{parent_name}' not found in capability database")

        parent_resolved = resolve_record(parent_name, raw_records, list(visited))

        # Merge order: parent first, current entry overwrites parent
        merged = parent_resolved.copy()
        merged.update(current)
        return merged

    return current


def run_module() -> None:
    module_args = dict(
        database=dict(type='path', required=True),
        key=dict(type='str', required=False, default=None, no_log=False),
        split=dict(type='str', required=False, default=None),
        fail_key=dict(type='bool', default=True),
        resolve_tc=dict(type='bool', default=True),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True,
    )

    database: str = module.params['database']
    key: str | None = module.params['key']
    split_char: str | None = module.params['split']
    fail_key: bool = module.params['fail_key']
    resolve_tc: bool = module.params['resolve_tc']

    if not os.path.isfile(database):
        module.fail_json(msg=f"Capability database file not found: {database}")

    try:
        raw_records = parse_raw_records(database, split_char)
    except Exception as e:
        module.fail_json(msg=f"Failed to parse {database}: {str(e)}")

    results: dict[str, Any] = {}

    if key is not None:
        if key in raw_records:
            try:
                if resolve_tc:
                    results[key] = resolve_record(key, raw_records)
                else:
                    results[key] = raw_records[key]
            except Exception as e:
                module.fail_json(msg=f"Failed resolving capabilities for key '{key}': {str(e)}")
        else:
            if fail_key:
                module.fail_json(msg=f"Key '{key}' not found in capability database '{database}'")
            else:
                results[key] = None
    else:
        for rec_key in raw_records:
            try:
                if resolve_tc:
                    results[rec_key] = resolve_record(rec_key, raw_records)
                else:
                    results[rec_key] = raw_records[rec_key]
            except Exception as e:
                module.fail_json(msg=f"Failed resolving capabilities for key '{rec_key}': {str(e)}")

    module.exit_json(
        changed=False,
        ansible_facts=dict(cgetent=results),
    )


def main() -> None:
    run_module()


if __name__ == '__main__':
    main()
