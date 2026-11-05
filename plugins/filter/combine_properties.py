# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import absolute_import, division, print_function

DOCUMENTATION = r"""
  name: combine_properties
  collection: vbotka.freebsd
  short_description: Combine VMM jail/VM properties and notes into key=value string
  version_added: "1.1.0"
  description:
    - Merges default/global properties with specification-specific VMM properties.
    - Concatenates notes from multiple levels preserving a specific precedence order.
    - Supports configurable metadata attributes appended to notes (such as C(vmm), C(class), C(swarm)).
    - Accepts C(spec) directly as a mapping, a string identifier, or a C(dict2items) element (with C(key) and C(value)).
    - Removes existing C(notes) keys from property dicts and appends a single C(notes="...") attribute.
    - Formats all output key=value pairs into a single space-delimited string.
  positional: _input, host, spec
  options:
    _input:
      description:
        - Base/global properties dictionary.
      type: dictionary
      required: true
    host:
      description:
        - Target inventory hostname (e.g. C(inventory_hostname)) used for the C(vmm=...) note attribute.
      type: string
      required: true
    spec:
      description:
        - The specification dictionary (defining a jail or a swarm) or an item from C(dict2items).
        - May also be passed as a plain string identifier.
      type: raw
      required: true
    notes:
      description:
        - List of metadata keys to append to the notes string in order.
        - Supports standard dynamic keys like C(vmm), C(class), and specification attributes like C(swarm).
      type: list
      elements: string
      default: ['vmm', 'class']
      required: false
  return:
    _value:
      description:
        - Space-delimited string of property assignments ending with C(notes="...").
      type: string
"""

EXAMPLES = r"""
# Using jails or swarms with dict2items (default notes: vmm, class):
- name: Combine jail/swarm properties in a dict2items loop
  ansible.builtin.debug:
    msg: "{{ properties | d({}) | vbotka.freebsd.combine_properties(inventory_hostname, item) }}"
  loop: "{{ jails | dict2items }}"

# Appending custom notes attributes (swarm):
- name: Combine properties and append swarm to notes
  ansible.builtin.debug:
    msg: "{{ properties | d({}) | vbotka.freebsd.combine_properties(inventory_hostname, item, notes=['vmm', 'class', 'swarm']) }}"
  loop: "{{ swarms | dict2items }}"
"""

RETURN = r"""
  _value:
    description: Single-line string containing combined key=value pairs and notes.
    type: string
    sample: 'bpf=1 dhcp=1 vnet=1 boot=1 notes="alias=www_02 vmm=iocage_06 class=nginx swarm=swarm_01"'
"""

from collections.abc import Mapping, Sequence


def _resolve_note_key(key, host, spec_name, data):
    """Resolve value for dynamic and arbitrary note keys."""
    if key == "vmm":
        return f"vmm={host}"
    elif key == "class":
        classes = data.get("class", [])
        if isinstance(classes, list):
            class_str = ",".join(str(c) for c in classes)
        elif classes:
            class_str = str(classes)
        else:
            class_str = ""
        return f"class={class_str}"
    elif key == "swarm":
        swarm_val = data.get("swarm", spec_name)
        return f"swarm={swarm_val}" if swarm_val else ""
    elif key in data:
        val = data[key]
        if isinstance(val, list):
            val_str = ",".join(str(v) for v in val)
        else:
            val_str = str(val)
        return f"{key}={val_str}"
    return ""


def combine_properties(properties, host, spec, notes=None):
    """
    Combines global/host properties with spec-specific properties and notes,
    extracting data directly from spec (jail or swarm specification).
    """
    properties = dict(properties) if isinstance(properties, Mapping) else {}

    # Extract specification dictionary and name
    if isinstance(spec, Mapping):
        if "value" in spec and isinstance(spec["value"], Mapping):
            # Formatted via dict2items: {'key': ..., 'value': {...}}
            data = dict(spec["value"])
            spec_name = str(spec.get("key", ""))
        else:
            data = dict(spec)
            spec_name = str(spec.get("key", spec.get("name", "")))
    else:
        spec_name = str(spec)
        data = {}

    spec_props = data.get("properties", {})
    if not isinstance(spec_props, Mapping):
        spec_props = {}

    if notes is None:
        notes_keys = ["vmm", "class"]
    elif isinstance(notes, (list, tuple, Sequence)) and not isinstance(notes, (str, bytes)):
        notes_keys = list(notes)
    else:
        notes_keys = [notes]

    # 1. Base user notes in order
    notes_source = [
        data.get("notes", ""),
        spec_props.get("notes", ""),
        properties.get("notes", ""),
    ]

    # 2. Append optional metadata note keys in specified order
    for key in notes_keys:
        val = _resolve_note_key(str(key), host, spec_name, data)
        if val:
            notes_source.append(val)

    notes_combined = " ".join([str(n) for n in notes_source if n])

    # 3. Combine properties (spec properties override global properties)
    combined = dict(properties)
    combined.update(spec_props)
    combined.pop("notes", None)

    # 4. Format output
    tokens = [f"{k}={v}" for k, v in combined.items()]
    tokens.append(f'notes="{notes_combined}"')

    return " ".join(tokens)


class FilterModule(object):
    """Ansible jinja2 filter plugin definitions."""

    def filters(self):
        return {
            "combine_properties": combine_properties,
        }
