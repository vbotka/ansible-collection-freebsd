# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from importlib import import_module
from typing import Any
from ansible.errors import AnsibleLookupError
from ansible.plugins.lookup import LookupBase

DOCUMENTATION = r"""
name: galaxy_info
short_description: Get metadata from collection galaxy.yml or MANIFEST.json
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
description:
  - Retrieves metadata attributes from the collection's C(MANIFEST.json) or development C(galaxy.yml).
options:
  _terms:
    description:
      - Metadata attribute name(s) to fetch (for example, V(version), V(authors), V(tags)).
      - Use V(all) to get the complete metadata dictionary.
    type: list
    elements: str
    required: true
"""

EXAMPLES = r"""
- name: Get the complete metadata dictionary
  ansible.builtin.debug:
    msg: "{{ lookup('vbotka.freebsd.galaxy_info', 'all') }}"

- name: Get the collection version
  ansible.builtin.debug:
    msg: "{{ lookup('vbotka.freebsd.galaxy_info', 'version') }}"

- name: Get multiple attributes
  ansible.builtin.debug:
    msg: "{{ lookup('vbotka.freebsd.galaxy_info', 'authors', 'version') }}"
"""

RETURN = r"""
_raw:
  description:
    - The collection metadata attribute value(s) or dictionary.
  type: raw
  returned: always
"""

import json
import os
import yaml


class LookupModule(LookupBase):
    def _find_collection_path(self) -> str:
        """Dynamically locates the root directory of the collection."""
        # Derive collection package from plugin's module name (e.g., ansible_collections.vbotka.freebsd)
        parts = self.__module__.split(".")
        if len(parts) >= 3 and parts[0] == "ansible_collections":
            collection_pkg = ".".join(parts[:3])
        else:
            collection_pkg = "ansible_collections.vbotka.freebsd"

        try:
            collection_mod = import_module(collection_pkg)
            return os.path.dirname(os.path.abspath(collection_mod.__file__))
        except Exception as err:
            raise AnsibleLookupError(
                f"Failed to resolve collection path for '{collection_pkg}': {err}"
            ) from err

    def _load_metadata(self, collection_root: str) -> dict[str, Any]:
        """Loads metadata from MANIFEST.json (installed) or galaxy.yml (development)."""
        manifest_path = os.path.join(collection_root, "MANIFEST.json")
        galaxy_path = os.path.join(collection_root, "galaxy.yml")

        # 1. Check for installed collection MANIFEST.json
        if os.path.isfile(manifest_path):
            try:
                with open(manifest_path, "r", encoding="utf-8") as f:
                    manifest_data = json.load(f)
                    return manifest_data.get("collection_info", manifest_data)
            except Exception as err:
                raise AnsibleLookupError(
                    f"Failed to read '{manifest_path}': {err}"
                ) from err

        # 2. Fall back to galaxy.yml for local development checkouts
        if os.path.isfile(galaxy_path):
            try:
                with open(galaxy_path, "r", encoding="utf-8") as f:
                    return yaml.safe_load(f) or {}
            except Exception as err:
                raise AnsibleLookupError(
                    f"Failed to read '{galaxy_path}': {err}"
                ) from err

        raise AnsibleLookupError(
            f"Neither 'MANIFEST.json' nor 'galaxy.yml' was found in '{collection_root}'."
        )

    def run(self, terms: list[str], variables: dict[str, Any] | None = None, **kwargs: Any) -> list[Any]:
        if not terms:
            raise AnsibleLookupError("No attribute specified for 'galaxy_info' lookup.")

        collection_root = self._find_collection_path()
        data = self._load_metadata(collection_root)

        if "all" in terms:
            return [data]

        result = []
        for attr in terms:
            if attr in data:
                result.append(data[attr])
            else:
                raise AnsibleLookupError(
                    f"Unknown collection metadata attribute '{attr}'. Available keys: {', '.join(data.keys())}"
                )

        return result
