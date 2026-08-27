# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import absolute_import, division, print_function
from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
name: from_ucl
short_description: Parse UCL string into a YAML dictionary
version_added: 1.0.0
author:
  - Vladimir Botka (@vbotka)
requirements:
  - ucl
description:
  - Parse UCL string into a YAML dictionary.
options:
  _input:
    description:
      - UCL string.
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

pkg_repo_ucl: "{{ pkg_repo_config | vbotka.freebsd.to_ucl }}"

# gives:
---
pkg_repo_ucl:
  FreeBSD {
      url = "pkg+http://pkg.FreeBSD.org/${ABI}/quarterly";
      mirror_type = "srv";
      signature_type = "fingerprints";
      fingerprints = "/usr/share/keys/pkg";
      enabled = true;
      priority = 100;
  }

result: "{{ pkg_repo_ucl | vbotka.freebsd.from_ucl }}"

# gives:
---
result:
  FreeBSD:
    enabled: true
    fingerprints: /usr/share/keys/pkg
    mirror_type: srv
    priority: 100
    signature_type: fingerprints
    url: pkg+http://pkg.FreeBSD.org/${ABI}/quarterly
"""

RETURN = r"""
_value:
  description:
    - YAML dictionary.
"""

try:
    import ucl
    HAS_LIBUCL = True
except ImportError:
    HAS_LIBUCL = False


def from_ucl(data):
    """Parse UCL string into a Python dictionary."""
    if not HAS_LIBUCL:
        raise AnsibleFilterError(
            "The 'ucl' Python module is required on the controller to use 'from_ucl'."
        )

    try:
        return ucl.loads(data)
    except Exception as err:
        raise AnsibleFilterError(f"Failed to parse UCL string: {err}")


class FilterModule(object):
    def filters(self):
        return {
            'from_ucl': from_ucl,
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
