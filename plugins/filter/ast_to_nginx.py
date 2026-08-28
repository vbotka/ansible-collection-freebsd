# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from typing import Any
from ansible.errors import AnsibleFilterError
from ansible.module_utils.basic import missing_required_lib

DOCUMENTATION = r"""
name: ast_to_nginx
short_description: Converts AST list to NGINX config
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
requirements:
  - crossplane
description:
  - Converts crossplane AST (Abstract Syntax Tree) list to NGINX config.
positional: _input, indent, tabs
options:
  _input:
    description:
      - AST list.
    type: list
    elements: dict
    required: true
  indent:
    description:
      - Number of spaces to use for indentation.
    type: int
    default: 4
  tabs:
    description:
      - Whether to use tabs instead of spaces for indentation.
    type: bool
    default: false
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

result: "{{ nginx_ast | vbotka.freebsd.ast_to_nginx }}"
"""

RETURN = r"""
_value:
  description:
    - NGINX config.
    - An empty string if the input is not a list.
  type: str
  returned: always
"""

try:
    import crossplane
    HAS_CROSSPLANE = True
    CROSSPLANE_IMPORT_ERROR = None
except ImportError as err:
    HAS_CROSSPLANE = False
    CROSSPLANE_IMPORT_ERROR = err


def ast_to_nginx(data: list[dict[str, Any]], indent: int = 4, tabs: bool = False) -> str:
    """Converts crossplane AST list to NGINX config syntax."""
    if not HAS_CROSSPLANE:
        raise AnsibleFilterError(
            missing_required_lib("crossplane"),
            orig_exc=CROSSPLANE_IMPORT_ERROR,
        )

    if not isinstance(data, list):
        return ""

    try:
        return crossplane.build(data, indent=indent, tabs=tabs)
    except Exception as err:
        raise AnsibleFilterError(
            f"Failed to build NGINX config from AST: {err}",
            orig_exc=err,
        ) from err


class FilterModule:
    def filters(self) -> dict[str, Any]:
        return {
            "ast_to_nginx": ast_to_nginx,
        }
