# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations

DOCUMENTATION = r"""
name: dict_to_ast
short_description: Converts YAML dictionary to AST list
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
description:
  - Converts YAML dictionary to crossplane AST (Abstract Syntax Tree) list.
options:
  _input:
    description:
      - A YAML dictionary.
    required: true
"""

EXAMPLES = r"""
---
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

# gives:
---
result:
  - args: [auto]
    directive: worker_processes
  - args: []
    block:
      - args: ['1024']
        directive: worker_connections
    directive: events
  - args: []
    block:
      - args: [/etc/nginx/mime.types]
        directive: include
      - args: []
        block:
          - args: ['80']
            directive: listen
          - args: [example.com, www.example.com]
            directive: server_name
          - args: [/]
            block:
              - args: ['200', Hello from Crossplane!]
                directive: return
            directive: location
        directive: server
    directive: http
"""

RETURN = r"""
_value:
  description:
    - AST list.
    - An empty list if the input is not a dictionary.
"""


def dict_to_ast(data: dict) -> list[dict]:
    """Transforms YAML dict to crossplane AST list."""
    ast = []
    if not isinstance(data, dict):
        return ast

    for key, value in data.items():
        parts = str(key).split()
        directive = parts[0]
        args = parts[1:]

        if isinstance(value, dict):
            # Nested block (e.g., events, http, server, location)
            ast.append({
                "directive": directive,
                "args": args,
                "block": dict_to_ast(value),
            })
        else:
            # Directive arguments (list or scalar)
            if isinstance(value, list):
                args.extend(value)
            elif value is not None:
                args.append(value)

            ast.append({
                "directive": directive,
                "args": [str(a) for a in args],
            })
    return ast


class FilterModule(object):
    def filters(self):
        return {
            'dict_to_ast': dict_to_ast,
        }
