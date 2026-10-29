# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: BSD-2-Clause

from __future__ import annotations

DOCUMENTATION = r'''
---
module: cgetent
short_description: A BSD cgetent capability database parser
description:
  - Runs capability database queries on BSD systems against files like C(/etc/login.conf),
    C(/etc/printcap), or C(/etc/termcap).
  - Similar to M(ansible.builtin.getent), results are registered in the C(ansible_facts) namespace.
  - Recognizes string (C(=)), numeric (C(#)), boolean (bare name), commented out (C(.) prefix),
    and absent/cancelled (C(@) suffix) capability types.
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
'''

EXAMPLES = r'''
- name: Fetch default login class attributes from /etc/login.conf
  vbotka.freebsd.cgetent:
    database: /etc/login.conf
    key: default

- name: Debug retrieved login.conf records
  ansible.builtin.debug:
    var: ansible_facts.cgetent['default']

- name: Retrieve printcap entries and do not fail on missing key
  vbotka.freebsd.cgetent:
    database: /etc/printcap
    key: lp
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
from typing import Any
from ansible.module_utils.basic import AnsibleModule


def parse_capability_file(filepath: str, split_char: str | None = None) -> dict[str, dict[str, Any]]:
    """
    Parses a BSD capability database (getcap(3) / login.conf format):
      - Non-indented lines are record keys.
      - Indented lines are capability lines.
      - Colons (:) separate capabilities on a line.
      - String capabilities use '='.
      - Numeric capabilities use '#'.
      - Boolean capabilities are bare names (value True).
      - Capabilities starting with '.' are commented out and skipped.
      - Capabilities ending with '@' indicate absent/cancelled entries (value False).
    """
    records: dict[str, dict[str, Any]] = {}
    current_key: str | None = None

    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            stripped = line.strip()
            if not stripped or stripped.startswith('#'):
                continue

            # Non-indented lines define the record key / class name
            if line[0] not in (' ', '\t'):
                key_name = stripped.rstrip('\\').strip().strip(':')
                current_key = key_name
                records[current_key] = {}
            else:
                if current_key is None:
                    continue

                # Strip trailing continuation slashes, whitespace, and bounding colons
                cap_line = stripped.rstrip('\\').strip().strip(':')
                if not cap_line:
                    continue

                # Split indented lines on colons ':'
                items = cap_line.split(':')
                for item in items:
                    item = item.strip()
                    if not item:
                        continue

                    # Commented out capability (starts with '.')
                    if item.startswith('.'):
                        continue

                    # Absent / cancelled capability (ends with '@')
                    if item.endswith('@'):
                        cap_name = item[:-1].strip()
                        records[current_key][cap_name] = False
                        continue

                    # String capability (contains '=')
                    if '=' in item:
                        k, v = item.split('=', 1)
                        k = k.strip()
                        v = v.strip()
                        if split_char:
                            records[current_key][k] = [val.strip() for val in v.split(split_char)]
                        else:
                            records[current_key][k] = v
                    # Numeric capability (contains '#')
                    elif '#' in item:
                        k, v = item.split('#', 1)
                        k = k.strip()
                        try:
                            records[current_key][k] = int(v.strip())
                        except ValueError:
                            records[current_key][k] = v.strip()
                    # Boolean capability (bare name)
                    else:
                        records[current_key][item] = True

    return records


def run_module() -> None:
    module_args = dict(
        database=dict(type='path', required=True),
        key=dict(type='str', required=False, default=None, no_log=False),
        split=dict(type='str', required=False, default=None),
        fail_key=dict(type='bool', default=True),
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True,
    )

    database: str = module.params['database']
    key: str | None = module.params['key']
    split_char: str | None = module.params['split']
    fail_key: bool = module.params['fail_key']

    if not os.path.isfile(database):
        module.fail_json(msg=f"Capability database file not found: {database}")

    try:
        all_records = parse_capability_file(database, split_char)
    except Exception as e:
        module.fail_json(msg=f"Failed to parse {database}: {str(e)}")

    results: dict[str, Any] = {}
    if key is not None:
        if key in all_records:
            results[key] = all_records[key]
        else:
            # Check if key matches an alias in pipe-separated headers (e.g. 'russian')
            matched_alias = None
            for rec_name, rec_data in all_records.items():
                aliases = [a.strip() for a in rec_name.split('|')]
                if key in aliases:
                    matched_alias = rec_data
                    break

            if matched_alias is not None:
                results[key] = matched_alias
            elif fail_key:
                module.fail_json(msg=f"Key '{key}' not found in capability database '{database}'")
            else:
                results[key] = None
    else:
        results = all_records

    module.exit_json(
        changed=False,
        ansible_facts=dict(cgetent=results),
    )


def main() -> None:
    run_module()


if __name__ == '__main__':
    main()
