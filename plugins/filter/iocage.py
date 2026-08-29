# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations
from typing import Any
from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
name: iocage
short_description: Parse iocage lists
version_added: "1.0.0"
author:
  - Vladimir Botka (@vbotka)
description:
  - Parses FreeBSD C(iocage) list command outputs into structured dictionaries or lists.
positional: _input, dataset
options:
  _input:
    description:
      - Either a dictionary of C(iocage) list outputs or a string of a single C(iocage) list output.
      - If option O(dataset) is V(None), the type of the input must be a dictionary.
      - Otherwise, the type of the input must be a string.
    type: raw
    required: true
  dataset:
    description:
      - Type of the C(iocage) dataset to parse.
    type: str
    choices:
      - jails
      - plugins
      - releases
      - templates
"""

EXAMPLES = r"""
---
# Example 1: Parse multiple dataset outputs passed as a dictionary
ansible_local:
  iocage:
    jails: |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
      | JID  |      NAME      | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
      +======+================+======+=======+======+=================+===================+=====+================+==========+
      | None | ansible_client | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.199/24 | -   | -              | no       |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
      | None | test_111       | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24 | -   | ansible_client | no       |
      +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
    releases: |
      14.1-RELEASE

result: "{{ ansible_local.iocage | vbotka.freebsd.iocage }}"

# Example 2: Parse a single dataset output directly
iocage_jails: |
  +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
  | JID  |      NAME      | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
  +======+================+======+=======+======+=================+===================+=====+================+==========+
  | None | ansible_client | off  | down  | jail | 14.1-RELEASE-p6 | em0|10.1.0.199/24 | -   | -              | no       |
  +------+----------------+------+-------+------+-----------------+-------------------+-----+----------------+----------+

jails: "{{ iocage_jails | vbotka.freebsd.iocage('jails') }}"
"""

RETURN = r"""
_value:
  description:
    - A dictionary of all parsed datasets if option O(dataset) is V(None).
    - A dictionary of dataset entries if option O(dataset) is V(jails), V(plugins), or V(templates).
    - A list of releases if option O(dataset) is V(releases).
  type: raw
  returned: always
"""

import re


def _parse_ip4(ip4_raw: str) -> dict[str, Any]:
    """Parse IPv4 configuration strings in the format interface|IP[/mask]."""
    iocage_ip4_dict: dict[str, Any] = {"ip4": [], "msg": ""}

    if not ip4_raw or ip4_raw == "-":
        return iocage_ip4_dict

    items = [item.strip() for item in ip4_raw.split(",") if item.strip()]
    ip_pattern = re.compile(r"^([\w\.\-]+)\|((?:\d{1,3}\.){3}\d{1,3})(?:/(\d{1,2}))?$")

    for item in items:
        match = ip_pattern.match(item)
        if match:
            ifc, ip, mask = match.groups()
            iocage_ip4_dict["ip4"].append({
                "ifc": ifc,
                "ip": ip,
                "mask": mask if mask is not None else "-",
            })
        else:
            iocage_ip4_dict["msg"] = f"{iocage_ip4_dict['msg']} {item}".strip()

    return iocage_ip4_dict


def _parse_ascii_table(data: str) -> list[dict[str, str]]:
    """Generic ASCII table parser for iocage tabular outputs."""
    lines = [line.strip() for line in data.splitlines() if line.strip()]
    if len(lines) < 3:
        return []

    # Find line index containing headers (usually line index 1)
    header_idx = -1
    for idx, line in enumerate(lines):
        if "|" in line and not line.startswith("+="):
            header_idx = idx
            break

    if header_idx == -1 or header_idx + 2 >= len(lines):
        return []

    header_line = lines[header_idx]
    col_indices = [i for i, char in enumerate(header_line) if char == "|"]
    if len(col_indices) < 2:
        return []

    headers = [
        header_line[i + 1:j].strip().lower().replace(" ", "_")
        for i, j in zip(col_indices[:-1], col_indices[1:])
    ]

    records: list[dict[str, str]] = []
    for line in lines[header_idx + 2:]:
        if line.startswith("+") or "|" not in line:
            continue
        cells = [
            line[i + 1:j].strip()
            for i, j in zip(col_indices[:-1], col_indices[1:])
        ]
        if len(cells) == len(headers):
            records.append(dict(zip(headers, cells)))

    return records


def _get_jails(data: str) -> dict[str, dict[str, Any]]:
    """Parse 'iocage list --long' or 'iocage list --template --long' output."""
    if not isinstance(data, str):
        return {}

    result: dict[str, dict[str, Any]] = {}
    records = _parse_ascii_table(data)

    for item in records:
        name = item.get("name")
        if not name:
            continue

        ip4_raw = item.get("ip4", "-")
        ip4_dict = _parse_ip4(ip4_raw)
        ip4_summary = (
            ",".join(d["ip"] for d in ip4_dict["ip4"])
            if ip4_dict["ip4"]
            else "-"
        )

        entry = dict(item)
        entry["ip4"] = ip4_summary
        entry["ip4_dict"] = ip4_dict
        result[name] = entry

    return result


def _get_plugins(data: str) -> dict[str, dict[str, Any]]:
    """Parse 'iocage list --plugins' output."""
    return _get_jails(data)


def _get_releases(data: str) -> list[str]:
    """Parse 'iocage list --release --header' output."""
    if not isinstance(data, str):
        return []
    return [
        line.strip()
        for line in data.splitlines()
        if line.strip() and not line.startswith(("+", "="))
    ]


def iocage(data: Any, dataset: str | None = None) -> Any:
    """Parse iocage dataset(s)."""
    dataset_handlers = {
        "jails": _get_jails,
        "plugins": _get_plugins,
        "releases": _get_releases,
        "templates": _get_jails,
    }

    if dataset is not None:
        if dataset not in dataset_handlers:
            valid_opts = ", ".join(dataset_handlers.keys())
            raise AnsibleFilterError(
                f"Invalid dataset '{dataset}'. Valid choices are: {valid_opts}"
            )
        if not isinstance(data, str):
            raise AnsibleFilterError(
                f"When 'dataset' is specified, input data must be a string, got {type(data).__name__}"
            )
        return dataset_handlers[dataset](data)

    if not isinstance(data, dict):
        raise AnsibleFilterError(
            f"When 'dataset' is not specified, input data must be a dictionary of datasets, got {type(data).__name__}"
        )

    results: dict[str, Any] = {}
    for key, handler in dataset_handlers.items():
        if key in data:
            results[key] = handler(data[key])

    return results


class FilterModule:
    def filters(self) -> dict[str, Any]:
        return {
            "iocage": iocage,
        }
