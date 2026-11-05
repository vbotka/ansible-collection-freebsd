.. _ug_pb_comparison_clients_vs_project:

Comparison: pb_iocage_ansible_clients vs pb_iocage_project_create
-----------------------------------------------------------------

.. contents::
   :local:
   :depth: 2

.. index::
   single: pb_iocage_ansible_clients.yml; comparison
   single: pb_iocage_project_create.yml; comparison
   single: playbooks comparison; iocage

Overview
^^^^^^^^

The collection provides two primary playbooks for deploying and orchestrating
FreeBSD jails across iocage jail manager hosts:

- :ref:`ug_pb-iocage-ansible-clients`: A modular lifecycle playbook designed for
  hybrid deployments involving static named instances (clones) and dynamic,
  horizontally scaled batches (swarms).
- :ref:`ug_pb-iocage-project-create`: A declarative, top-down orchestration
  playbook designed for multi-tier infrastructures where full topology, role
  classes, and host allocations are defined in a centralized data model.

Feature Matrix
^^^^^^^^^^^^^^

.. list-table:: Feature & Design Comparison
   :widths: 24 38 38
   :header-rows: 1

   * - Aspect
     - pb_iocage_ansible_clients
     - pb_iocage_project_create

   * - **Design Philosophy**
     - Task-driven workflows with feature flags and Ansible tags.
     - Orchestration driven by inventory reconciliation.

   * - **Data Model**
     - Decentralized per-host definitions (``clones``, ``swarms``) in ``host_vars``.
     - Centralized multi-host mapping (``project``) declared once in ``group_vars``.

   * - **Idempotency Strategy**
     - Internal state inspection: Queries facts (or delegates
       ``ansible-inventory``) to match count deltas.
     - Cross-inventory difference: Computes
       ``vmm[inventory_hostname] | difference(groups.all)``.

   * - **Naming Scheme**
     - Explicitly named (clones) or auto-generated UUIDs without aliases (swarms).
     - Auto-generated short UUIDs mapped to aliases via ``notes``.

   * - **Template Flexibility**
     - Supports per-clone and per-swarm template definitions (and iocage plugins).
     - Uses a uniform project-wide template default (``project_template``).

   * - **Metadata Assignment**
     - Inlined at creation time using the filter
       ``vbotka.freebsd.combine_properties``.
     - Applied post-creation in a separate loop using
       ``iocage set notes="..." <jail>``.

Architectural Differences
^^^^^^^^^^^^^^^^^^^^^^^^^

Data Structure & Scope
""""""""""""""""""""""

**pb_iocage_ansible_clients** operates at the host boundary. Each jail manager
is configured independently via its respective ``host_vars/<host>/iocage.yml``:

.. code-block:: yaml

   # host_vars/iocage_06/iocage.yml
   clones:
     test-161:
       clone_from: ansible-client
       class: [test]
       properties:
         ip4_addr: 'vnet0|172.16.99.201/24'

   swarms:
     sw_01:
       count: 3
       template: ansible-client
       class: [test]

**pb_iocage_project_create** centralizes the entire topology within a single
dictionary under ``group_vars/all/project.yml``. It decouples the logical tier
from the physical node:

.. code-block:: yaml

   # group_vars/all/project.yml
   project:
     logserv_1:
       vmm: iocage_05
       class: [log-server]
     db_1:
       vmm: iocage_05
       class: [db, log-client]
     db_2:
       vmm: iocage_06
       class: [db, log-client]

Idempotency & Inventory Dependencies
""""""""""""""""""""""""""""""""""""

- **pb_iocage_ansible_clients**:
  Can execute against a minimal inventory containing only the jail manager hosts
  (e.g., ``-i iocage.ini``). When calculating how many swarm members to spawn,
  it runs an internal discovery step (``get_inventory.yml``) that queries
  running jail facts or invokes ``ansible-inventory`` dynamically via
  ``delegate_to: localhost``.

- **pb_iocage_project_create**:
  Depends on a dual-inventory run (e.g., ``-i hosts -i iocage.ini``). The
  inventory plugins (such as :ref:`ug_inventory_iocage2`) parse existing jails
  and populate ``groups.all``. The playbook computes:

  .. code-block:: jinja

     iocage_jails_absent: "{{ vmm[inventory_hostname] | difference(groups.all) }}"

  If ``iocage_jails_absent`` is empty, execution terminates immediately for that
  host via ``ansible.builtin.meta: end_host``.

Naming and Inventory Tagging
""""""""""""""""""""""""""""

- In **pb_iocage_ansible_clients**, cloned jails receive explicit names
  defined by the keys in ``clones`` (e.g., ``test-161``). Swarm instances receive
  auto-generated UUIDs and are identified collectively by their swarm tag.

- In **pb_iocage_project_create**, jails are created in batch using short UUIDs
  (``iocage create --short --count <N>``). The playbook pairs the created UUIDs
  with missing aliases and sets the ``notes`` property:

  .. code-block:: none

     alias=db_1 class=db,log-client vmm=iocage_05

  Dynamic inventory plugins read ``alias`` via ``inventory_hostname_tag: alias``,
  allowing playbooks to target logical hostnames (like ``db_1``) rather than
  ephemeral UUIDs.

Use Case Recommendations
^^^^^^^^^^^^^^^^^^^^^^^^

Use ``pb_iocage_ansible_clients`` when:
"""""""""""""""""""""""""""""""""""""""

- You require persistent, explicitly named jails with static network properties
  alongside dynamic pools.

- Target hosts run disparate releases or require distinct templates per jail.

Use ``pb_iocage_project_create`` when:
""""""""""""""""""""""""""""""""""""""

- Provisioning complete, multi-tiered architectures (e.g., load balancers, web
  workers, databases) spanning multiple jail manager hosts.

- Managing infrastructure declaratively as code in a single file (``project.yml``).

- Working with ephemeral UUID jails where inventory access is mediated
  through dynamic tags and aliases.

.. seealso::

   * :ref:`ug_pb-iocage-ansible-clients`
   * :ref:`ug_pb-iocage-project-create`
   * :ref:`example_203`
   * :ref:`example_207`
