# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import absolute_import, division, print_function
from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
name: to_ucl
short_description: Converts YAML dictionary to UCL string
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
requirements:
  - ucl
description:
  - Converts YAML dictionary to UCL string.
options:
  _input:
    description:
      - YAML dictionary.
    required: true
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
"""

RETURN = r"""
_value:
  description:
    - UCL string.
"""

try:
    import ucl
    HAS_LIBUCL = True
except ImportError:
    HAS_LIBUCL = False


def to_ucl(data, emitter='config'):
    """Converts Python dictionary to UCL format."""
    if not HAS_LIBUCL:
        raise AnsibleFilterError(
            "The 'ucl' Python module is required on the controller to use 'to_ucl'."
        )

    emitters = {
        'config': ucl.UCL_EMIT_CONFIG,
        'json': ucl.UCL_EMIT_JSON,
        'compact_json': ucl.UCL_EMIT_JSON_COMPACT,
        'yaml': ucl.UCL_EMIT_YAML,
        'msgpack': ucl.UCL_EMIT_MSGPACK,
    }

    if emitter not in emitters:
        raise AnsibleFilterError(
            f"Invalid emitter '{emitter}'. Supported options: {', '.join(emitters.keys())}"
        )

    try:
        return ucl.dumps(data, emitters[emitter])
    except Exception as err:
        raise AnsibleFilterError(f"Failed to convert data to UCL: {err}")


class FilterModule(object):
    def filters(self):
        return {
            'to_ucl': to_ucl,
        }

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ucl 0.8.1 needs the below helper.
#
# /home/user/penv/lib/python3.13/site-packages/ucl-dumps.pth
# import _ucl_patch
#
# /home/user/penv/lib/python3.13/site-packages/_ucl_patch.py
# import ucl
#
# def _to_primitive(val):
#     if isinstance(val, dict):
#         return {str(k): _to_primitive(v) for k, v in val.items()}
#     elif isinstance(val, (list, tuple, set)):
#         return [_to_primitive(item) for item in val]
#     elif isinstance(val, str):
#         return str(val)
#     elif isinstance(val, bool):
#         return bool(val)
#     elif isinstance(val, int):
#         return int(val)
#     elif isinstance(val, float):
#         return float(val)
#     return val
#
# def _safe_dumps(obj, *args, **kwargs):
#     clean_obj = _to_primitive(obj)
#     return ucl.dump(clean_obj, *args, **kwargs)
#
# def _safe_loads(data, *args, **kwargs):
#     return ucl.load(data, *args, **kwargs)
#
# setattr(ucl, "dumps", _safe_dumps)
# setattr(ucl, "loads", _safe_loads)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
