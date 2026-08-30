# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from typing import Any
from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
name: from_ucl
short_description: Parses UCL string to a Python dictionary
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
requirements:
  - ucl
description:
  - Parses a Universal Configuration Language (UCL) string into a dictionary/data structure.
positional: _input
options:
  _input:
    description:
      - UCL string to parse.
    type: str
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
    - Parsed Python dictionary or data structure from UCL.
  type: raw
  returned: always
"""

try:
    import ucl
    HAS_LIBUCL = True
except ImportError:
    HAS_LIBUCL = False


def _safe_ucl_load(data: str | bytes) -> Any:
    """Safely calls ucl.loads or ucl.load depending on module interface."""
    if hasattr(ucl, "loads"):
        return ucl.loads(data)
    if hasattr(ucl, "load"):
        return ucl.load(data)
    raise AttributeError("The installed 'ucl' module does not provide 'load' or 'loads'.")


def from_ucl(data: Any) -> Any:
    """Parse UCL string into a Python dictionary."""
    if not HAS_LIBUCL:
        raise AnsibleFilterError(
            "The 'ucl' Python module is required on the controller to use 'from_ucl'."
        )

    if not isinstance(data, (str, bytes)):
        raise AnsibleFilterError(
            f"Invalid input type for 'from_ucl': expected str or bytes, got {type(data).__name__}"
        )

    try:
        return _safe_ucl_load(data)
    except Exception as err:
        raise AnsibleFilterError(
            f"Failed to parse UCL string: {err}",
            orig_exc=err,
        ) from err


class FilterModule:
    def filters(self) -> dict[str, Any]:
        return {
            "from_ucl": from_ucl,
        }
