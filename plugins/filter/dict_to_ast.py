# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations

DOCUMENTATION = r"""
name: dict_to_ast
short_description: Converts YAML dictionary or data structure to Crossplane AST list
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
description:
  - Converts a YAML dictionary or structured data into a crossplane-compatible AST (Abstract Syntax Tree) list for NGINX configuration generation.
positional: _input
options:
  _input:
    description:
      - A YAML dictionary or list representing NGINX configuration structure.
    type: raw
    required: true
"""

EXAMPLES = r"""
---
# Example 1: Standard dictionary configuration
nginx_conf:
  worker_processes: ['auto']
  events:
    worker_connections: ['1024']
  http:
    include: ['/etc/nginx/mime.types']
    server:
      listen: ['80']
      server_name: ['example.com', 'www.example.com']
      location /:
        return: ['200', 'Hello from Crossplane!']

result: "{{ nginx_conf | vbotka.freebsd.dict_to_ast }}"

# Example 2: Repeated blocks (multiple server blocks) using a list of dicts
nginx_conf_multi:
  http:
    server:
      - listen: ['80']
        server_name: ['example.com']
      - listen: ['443', 'ssl']
        server_name: ['secure.example.com']

result_multi: "{{ nginx_conf_multi | vbotka.freebsd.dict_to_ast }}"
"""

RETURN = r"""
_value:
  description:
    - Crossplane AST list representing the NGINX configuration.
    - An empty list if the input format is invalid.
  type: list
  elements: dict
  returned: always
"""


def _process_item(key: str | int, value: any) -> list[dict]:
    """Processes an individual directive or block entry into AST nodes."""
    parts = str(key).split()
    if not parts:
        return []

    directive = parts[0]
    base_args = parts[1:]

    # Case 1: Nested block (single dict)
    if isinstance(value, dict):
        return [{
            "directive": directive,
            "args": base_args,
            "block": dict_to_ast(value),
        }]

    # Case 2: List of nested blocks or repeated multi-argument directives
    if isinstance(value, list):
        # List of dicts represents multiple repeated blocks (e.g., multiple `server` or `location` blocks)
        if any(isinstance(i, dict) for i in value):
            nodes = []
            for item in value:
                if isinstance(item, dict):
                    nodes.append({
                        "directive": directive,
                        "args": base_args,
                        "block": dict_to_ast(item),
                    })
                else:
                    nodes.append({
                        "directive": directive,
                        "args": [str(a) for a in base_args + ([item] if not isinstance(item, list) else item)],
                    })
            return nodes

        # List of lists (e.g. repeated directives: include: [['file1.conf'], ['file2.conf']])
        if any(isinstance(i, list) for i in value):
            nodes = []
            for sublist in value:
                args = base_args + (sublist if isinstance(sublist, list) else [sublist])
                nodes.append({
                    "directive": directive,
                    "args": [str(a) for a in args],
                })
            return nodes

        # Standard directive arguments: `worker_processes: ['auto']` or `server_name: ['a.com', 'b.com']`
        args = base_args + value
        return [{
            "directive": directive,
            "args": [str(a) for a in args],
        }]

    # Case 3: Directive with a scalar value or no argument (None)
    args = base_args.copy()
    if value is not None:
        args.append(value)

    return [{
        "directive": directive,
        "args": [str(a) for a in args],
    }]


def dict_to_ast(data: dict | list) -> list[dict]:
    """Transforms YAML structure (dict or list) to crossplane AST list."""
    if not isinstance(data, (dict, list)):
        return []

    ast: list[dict] = []

    if isinstance(data, dict):
        for key, value in data.items():
            ast.extend(_process_item(key, value))
    elif isinstance(data, list):
        for item in data:
            if isinstance(item, dict):
                ast.extend(dict_to_ast(item))

    return ast


class FilterModule(object):

    def filters(self):
        return {
            "dict_to_ast": dict_to_ast,
        }