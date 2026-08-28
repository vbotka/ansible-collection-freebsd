# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from typing import Any
from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
name: to_ucl
short_description: Converts Python/YAML data structure to UCL string
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
requirements:
  - ucl
description:
  - Converts a Python/YAML dictionary or list into a Universal Configuration Language (UCL) formatted string.
positional: _input, emitter
options:
  _input:
    description:
      - Python dictionary or data structure to convert.
    type: raw
    required: true
  emitter:
    description:
      - UCL output format style.
    type: str
    default: config
    choices:
      - config
      - json
      - compact_json
      - yaml
      - msgpack
"""

EXAMPLES = r"""
---
pkg_repo_config:
  FreeBSD:
    url: "pkg+http://pkg.FreeBSD.org/${ABI}/quarterly"
    mirror_type: "srv"
    signature_type: "fingerprints"
    fingerprints: "/usr/share/keys/pkg"
    enabled: true
    priority: 100

result: "{{ pkg_repo_config | vbotka.freebsd.to_ucl }}"

# gives:
---
result:
  FreeBSD {
      url = "pkg+http://pkg.FreeBSD.org/${ABI}/quarterly";
      mirror_type = "srv";
      signature_type = "fingerprints";
      fingerprints = "/usr/share/keys/pkg";
      enabled = true;
      priority = 100;
  }

result_json: "{{ pkg_repo_config | vbotka.freebsd.to_ucl('json') }}"
"""

RETURN = r"""
_value:
  description:
    - UCL formatted string (or bytes in case of msgpack).
  type: str
  returned: always
"""

try:
    import ucl
    HAS_LIBUCL = True
except ImportError:
    HAS_LIBUCL = False


def _to_primitive(val: Any) -> Any:
    """Recursively converts Ansible/custom objects into native Python primitives for UCL serialization."""
    if isinstance(val, dict):
        return {str(k): _to_primitive(v) for k, v in val.items()}
    if isinstance(val, (list, tuple, set)):
        return [_to_primitive(item) for item in val]
    if isinstance(val, str):
        return str(val)
    if isinstance(val, bool):
        return bool(val)
    if isinstance(val, int):
        return int(val)
    if isinstance(val, float):
        return float(val)
    if val is None:
        return None
    return str(val)


def _safe_ucl_dump(data: Any, emitter_flag: int) -> str | bytes:
    """Safely dumps data using available ucl functions."""
    if hasattr(ucl, "dump"):
        return ucl.dump(data, emitter_flag)
    if hasattr(ucl, "dumps"):
        return ucl.dumps(data, emitter_flag)
    raise AttributeError("The installed 'ucl' module does not provide 'dump' or 'dumps'.")


def to_ucl(data: Any, emitter: str = "config") -> str | bytes:
    """Converts Python dictionary or structure to UCL format."""
    if not HAS_LIBUCL:
        raise AnsibleFilterError(
            "The 'ucl' Python module is required on the controller to use 'to_ucl'."
        )

    emitters: dict[str, int] = {
        "config": getattr(ucl, "UCL_EMIT_CONFIG", 0),
        "json": getattr(ucl, "UCL_EMIT_JSON", 1),
        "compact_json": getattr(ucl, "UCL_EMIT_JSON_COMPACT", 2),
        "yaml": getattr(ucl, "UCL_EMIT_YAML", 3),
        "msgpack": getattr(ucl, "UCL_EMIT_MSGPACK", 4),
    }

    if emitter not in emitters:
        raise AnsibleFilterError(
            f"Invalid emitter '{emitter}'. Supported options: {', '.join(emitters.keys())}"
        )

    try:
        clean_data = _to_primitive(data)
        return _safe_ucl_dump(clean_data, emitters[emitter])
    except Exception as err:
        raise AnsibleFilterError(
            f"Failed to convert data to UCL: {err}",
            orig_exc=err,
        ) from err


class FilterModule:
    def filters(self) -> dict[str, Any]:
        return {
            "to_ucl": to_ucl,
        }
