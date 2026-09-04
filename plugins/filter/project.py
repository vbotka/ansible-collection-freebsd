# (c) 2026 Vladimir Botka <vbotka@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import annotations

from ansible.errors import AnsibleFilterError

DOCUMENTATION = r"""
  name: project
  short_description: Restructure project into host-mapped and class-mapped dictionaries
  version_added: "1.0.4"
  description:
    - Restructures a dictionary of jails and their hosts defined with C(vmm) and C(class)
      attributes.
    - Groups full service specifications under their respective target hypervisor (C(vmm)).
    - Inverts the C(class) attribute into a reverse-lookup dictionary mapping class names to lists
      of service names.
  options:
    _input:
      description:
        - A dictionary of services, keyed by service name.
        - Each service dictionary must contain a string attribute C(vmm) and a list attribute
          C(class).
      type: dict
      required: true
"""

EXAMPLES = r"""
- name: Transform project dictionary
  vars:
    project:
      logserv_1:
        class: [logserv]
        vmm: iocage_01
      http_1:
        class: [http, logclient]
        vmm: iocage_02
      db_1:
        class: [db, logclient]
        vmm: iocage_02
      http_2:
        class: [http, logclient]
        vmm: iocage_04
      db_2:
        class: [db, logclient]
        vmm: iocage_04
  ansible.builtin.set_fact:
    restructured: "{{ project | vbotka.freebsd.project }}"

# Access services running on iocage_02:
# {{ restructured.vmm.iocage_02 }}

# Access all services in class 'logclient':
# {{ restructured.class.logclient }}
"""

RETURN = r"""
  _value:
    description: A dictionary containing two top-level keys C(vmm) and C(class).
    type: dict
    returned: always
    contains:
      vmm:
        description:
          - A dictionary where each key is a VMM host name.
          - Each value is a dictionary of the services allocated to that VMM, preserving original
            service attributes.
        type: dict
        sample:
          iocage_01:
            logserv_1:
              class: [logserv]
              vmm: iocage_01
          iocage_02:
            db_1:
              class: [db, logclient]
              vmm: iocage_02
            http_1:
              class: [http, logclient]
              vmm: iocage_02
      class:
        description:
          - A dictionary where each key is a class category name.
          - Each value is a list of service names associated with that class.
        type: dict
        sample:
          db:
            - db_1
            - db_2
          http:
            - http_1
            - http_2
          logclient:
            - http_1
            - db_1
            - http_2
            - db_2
          logserv:
            - logserv_1
"""


def project(data):
    if not isinstance(data, dict):
        raise AnsibleFilterError(
            f"The 'project' filter expects a dictionary as input, got {type(data).__name__}"
        )

    vmm = {}
    classes = {}

    for name, item in data.items():
        if not isinstance(item, dict):
            raise AnsibleFilterError(
                f"Service definition for '{name}' must be a dictionary, got {type(item).__name__}"
            )

        # Build vmm mapping
        vmm_host = item.get("vmm")
        if vmm_host:
            vmm.setdefault(vmm_host, {})[name] = item

        # Build class mapping (defensively accept string or list/iterable)
        item_classes = item.get("class", [])
        if isinstance(item_classes, str):
            item_classes = [item_classes]
        elif not isinstance(item_classes, (list, tuple, set)):
            raise AnsibleFilterError(
                f"Attribute 'class' in '{name}' must be a list or string, got {type(item_classes).__name__}"
            )

        for cls in item_classes:
            classes.setdefault(cls, []).append(name)

    return {
        "vmm": vmm,
        "class": classes,
    }


class FilterModule(object):
    def filters(self):
        return {"project": project}
