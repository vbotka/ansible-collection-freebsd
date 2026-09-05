# -*- coding: utf-8 -*-
# Copyright: (c) 2026, Ansible Project
# Simplified BSD License (see licenses/simplified_bsd.txt or https://opensource.org/licenses/BSD-2-Clause)

from __future__ import absolute_import, division, print_function
__metaclass__ = type

import tempfile
import traceback

from ansible.errors import AnsibleFilterError

DOCUMENTATION = r'''
  name: to_haproxy
  short_description: Convert dictionary to HAProxy configuration syntax
  version_added: "1.0.0"
  description:
    - Converts structured Python dictionaries into valid HAProxy configuration blocks.
  options:
    data:
      description: Dictionary containing global, defaults, frontends, and backends configurations.
      type: dict
      required: true
'''

HAS_PYHAPROXY = True
PYHAPROXY_IMPORT_ERROR = None

try:
    from pyhaproxy.parse import Parser
    from pyhaproxy.render import Render
except ImportError:
    HAS_PYHAPROXY = False
    PYHAPROXY_IMPORT_ERROR = traceback.format_exc()


def _format_lines_from_dict(data):
    """Unroll dictionary directives into indented HAProxy configuration lines."""
    lines = []
    preferred_order = ['bind', 'mode', 'options', 'acls', 'use_backends', 'default_backend']
    sorted_keys = [k for k in preferred_order if k in data] + [k for k in data if k not in preferred_order]

    for key in sorted_keys:
        value = data[key]

        if key == 'acls' and isinstance(value, dict):
            for acl_name, criterion in value.items():
                lines.append(f"    acl {acl_name} {criterion}".rstrip())

        elif key == 'use_backends':
            if isinstance(value, list):
                for rule in value:
                    backend = rule.get('backend', '')
                    condition = rule.get('condition', '')
                    lines.append(f"    use_backend {backend} {condition}".rstrip())
            elif isinstance(value, dict):
                for backend, condition in value.items():
                    lines.append(f"    use_backend {backend} {condition}".rstrip())

        elif key == 'options' and isinstance(value, dict):
            for opt_name, opt_val in value.items():
                if isinstance(opt_val, bool):
                    if opt_val:
                        lines.append(f"    option {opt_name}")
                else:
                    lines.append(f"    option {opt_name} {opt_val}".rstrip())

        elif key == 'timeouts' and isinstance(value, dict):
            for timeout_type, timeout_val in value.items():
                lines.append(f"    timeout {timeout_type} {timeout_val}")

        elif key == 'servers' and isinstance(value, dict):
            for srv_name, srv_conf in value.items():
                parts = [srv_name, srv_conf.get('address', '')]
                if srv_conf.get('check', False):
                    parts.append('check')
                if 'inter' in srv_conf:
                    parts.append(f"inter {srv_conf['inter']}")
                if 'fall' in srv_conf:
                    parts.append(f"fall {srv_conf['fall']}")
                if 'rise' in srv_conf:
                    parts.append(f"rise {srv_conf['rise']}")
                lines.append(f"    server {' '.join(parts)}".rstrip())

        elif isinstance(value, bool):
            if value:
                lines.append(f"    {key}")
        else:
            lines.append(f"    {key} {value}".rstrip())

    return lines


def to_haproxy(data):
    """Convert a structured Python dictionary into HAProxy config via pyhaproxy."""
    if not HAS_PYHAPROXY:
        raise AnsibleFilterError(
            f"The 'to_haproxy' filter requires the Python library 'pyhaproxy'. "
            f"Error details: {PYHAPROXY_IMPORT_ERROR}"
        )

    if not isinstance(data, dict):
        raise AnsibleFilterError(f"to_haproxy expects a dictionary, got {type(data).__name__}")

    raw_blocks = []

    # 1. Global
    if 'global' in data:
        raw_blocks.append("global")
        raw_blocks.extend(_format_lines_from_dict(data['global']))
        raw_blocks.append("")

    # 2. Defaults
    if 'defaults' in data:
        raw_blocks.append("defaults")
        raw_blocks.extend(_format_lines_from_dict(data['defaults']))
        raw_blocks.append("")

    # 3. Frontends
    for fe_name, fe_conf in data.get('frontends', {}).items():
        raw_blocks.append(f"frontend {fe_name}")
        raw_blocks.extend(_format_lines_from_dict(fe_conf))
        raw_blocks.append("")

    # 4. Backends
    for be_name, be_conf in data.get('backends', {}).items():
        raw_blocks.append(f"backend {be_name}")
        raw_blocks.extend(_format_lines_from_dict(be_conf))
        raw_blocks.append("")

    intermediate_text = "\n".join(raw_blocks)

    try:
        with tempfile.NamedTemporaryFile(mode='w+', delete=True) as tmp:
            tmp.write(intermediate_text)
            tmp.flush()

            config = Parser(tmp.name).build_configuration()
            renderer = Render(config)

            if hasattr(renderer, 'render_configuration'):
                return renderer.render_configuration()
            if hasattr(renderer, 'dumps'):
                return renderer.dumps()
            if hasattr(renderer, 'render'):
                return renderer.render()
            raise AttributeError("Render object has no recognized rendering method")

    except Exception as e:
        raise AnsibleFilterError(
            f"Failed to generate and validate HAProxy configuration via pyhaproxy: {e}"
        ) from e


class FilterModule(object):
    """Ansible filter plugin definitions."""

    def filters(self):
        return {
            'to_haproxy': to_haproxy,
        }
