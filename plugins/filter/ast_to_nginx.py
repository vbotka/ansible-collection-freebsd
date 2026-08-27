# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations

DOCUMENTATION = r"""
name: ast_to_nginx
short_description: Converts AST list to NGINX config
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
requirements:
  - crossplane
description:
  - Converts crossplane AST (Abstract Syntax Tree) list to NGINX config.
options:
  _input:
    description:
      - AST list.
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

nginx_ast: "{{ nginx_conf | vbotka.freebsd.dict_to_ast }}"

# gives:
---
nginx_ast:
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

result: "{{ nginx_ast | vbotka.freebsd.ast_to_nginx }}"

# gives:
---
result:
  worker_processes auto;
  events {
      worker_connections 1024;
  }
  http {
      include /etc/nginx/mime.types;
      server {
          listen 80;
          server_name example.com www.example.com;
          location / {
              return 200 'Hello from Crossplane!';
          }
      }
  }
"""

RETURN = r"""
_value:
  description:
    - NGINX config.
    - An empty string if the input is not a list.
"""

import crossplane


def ast_to_nginx(data: list[dict], indent: int = 4, tabs: bool = False) -> str:
    """Converts crossplane AST list to NGINX config syntax."""
    if not isinstance(data, list):
        return ""
    return crossplane.build(data, indent=indent, tabs=tabs)


class FilterModule(object):
    def filters(self):
        return {
            'ast_to_nginx': ast_to_nginx,
        }
