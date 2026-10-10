.. _ug_pb-iocage-ansible-clients:

pb_iocage_ansible_clients
-------------------------

.. contents::
   :local:
   :depth: 3

.. index::
   single: pb_iocage_ansible_clients.yml; pb_iocage_ansible_clients
   single: clones; pb_iocage_ansible_clients
   single: clones destroy; pb_iocage_ansible_clients
   single: swarms; pb_iocage_ansible_clients
   single: swarms destroy; pb_iocage_ansible_clients
   single: clone_host_hostname; pb_iocage_ansible_clients
   single: list; pb_iocage_ansible_clients
   single: iocage_jails_source; pb_iocage_ansible_clients
   single: filter combine_properties; pb_iocage_ansible_clients

Synopsis
^^^^^^^^

The playbook ``vbotka.freebsd.pb_iocage_ansible_clients.yml`` provisions,
starts, lists, and destroys FreeBSD jails created from iocage templates or
plugins across one or more jail manager hosts.

It supports two primary provisioning workflows:

- **Clones**: Explicitly named jails provisioned with individual properties and
  network configurations.
- **Swarms**: Batched jail instances with automatically generated UUID names,
  scaled using ``iocage create --count`` and structured metadata tags.

.. hint::

   Search ``pb_iocage_ansible_clients.yml`` in :ref:`genindex` for available examples.

Requirements
^^^^^^^^^^^^

- Collection ``community.general`` installed on the Ansible controller (for ``json_query``).
- Activated ``iocage`` pool with target templates or plugins available on managed nodes.
- Root or ``sudo``/``doas`` privilege escalation configured on the managed hosts.

Parameters
^^^^^^^^^^

.. list-table:: Playbook Control Variables
   :widths: 25 15 15 45
   :header-rows: 1

   * - Variable
     - Type
     - Default
     - Description
   * - ``clone``
     - boolean
     - ``false``
     - Enable creation and startup of named jails defined in ``clones``.
   * - ``clone_destroy``
     - boolean
     - ``false``
     - Enable stopping and destruction of jails defined in ``clones``.
   * - ``swarm``
     - boolean
     - ``false``
     - Enable creation and startup of batched swarm instances defined in ``swarms``.
   * - ``swarm_destroy``
     - boolean
     - ``false``
     - Enable stopping and destruction of swarms defined in ``swarms``.
   * - ``clone_host_hostname``
     - boolean
     - ``false``
     - *(WIP)* Enable creation of clones with explicit hostname and fstab mount mappings.
   * - ``dry_run``
     - boolean
     - ``false``
     - When set to ``true``, creation, startup, and destruction commands are bypassed.
   * - ``debug``
     - boolean
     - ``false``
     - Displays command strings, basic variables, and jail identifier lists.
   * - ``debug2``
     - boolean
     - ``false``
     - Displays full structured dictionaries and registered module output.
   * - ``iocage_jails_source``
     - string
     - ``module``
     - Source used by ``get_inventory.yml`` to query jails: ``module`` (queries ``vbotka.freebsd.iocage`` on the node) or ``inventory`` (invokes ``ansible-inventory`` on the controller).
   * - ``iocage_jails_inventory_conf``
     - string
     - ``"{{ lookup('env', 'PWD') }}/hosts"``
     - Path to the inventory directory or file when ``iocage_jails_source`` is set to ``inventory``.
   * - ``properties``
     - dictionary
     - ``{}``
     - Global default jail properties applied to both clones and swarms.

Workflow
^^^^^^^^

Clones Workflow
"""""""""""""""

The clones lifecycle manages explicitly named jails declared in the ``clones`` dictionary.

1. **Property Merging**:
   For each clone definition, global properties in ``properties`` are merged with
   per-jail settings using the filter ``vbotka.freebsd.combine_properties``. The
   filter embeds structured tags into the jail's ``notes`` property:

   .. code-block:: none

      notes="alias=<key> vmm=<inventory_hostname> class=<classes> swarm=<swarm>"

2. **Creation**:
   The module ``vbotka.freebsd.iocage`` provisions the jail using ``state: cloned``
   from the specified template:

   .. code-block:: yaml

      vbotka.freebsd.iocage:
        state: cloned
        clone_from: "{{ item.value.clone_from }}"
        name: "{{ item.key }}"
        properties: "{{ _properties }}"

3. **Startup**:
   Evaluates which jails are already in state ``up``. Unstarted jails are
   started in batch using ``iocage start``.

4. **Destruction**:
   When ``clone_destroy: true`` (or tag ``clone_destroy``) is run,
   ``vbotka.freebsd.iocage`` sets ``state: stopped`` followed by
   ``state: absent``.

Swarms Workflow
"""""""""""""""

The swarms workflow manages groups of homogeneous, automatically named UUID jails.

1. **Inventory Discovery**:
   Imports ``get_inventory.yml`` to collect running state and parse existing
   tags from ``notes``:

   - Under ``iocage_jails_source: module``, facts returned by ``vbotka.freebsd.iocage``
     are parsed, discarding jails without notes.
   - Under ``iocage_jails_source: inventory``, ``ansible-inventory`` is delegated to
     localhost to read ``iocage_tags``.

2. **Delta Calculation & Idempotency**:
   The number of missing jails is calculated by querying existing tags matching
   the swarm name:

   .. code-block:: jinja

      _query: "[?value.swarm==`{{ item.key }}`].key"
      _count: "{{ item.value.count - iocage_jails_tags | dict2items | community.general.json_query(_query) | length }}"

   If ``_count`` is greater than ``0``, ``iocage create --short --template <template> --count <_count>``
   (or ``iocage clone`` for plugins) executes via ``ansible.builtin.command``.

3. **Startup**:
   Refreshes inventory and executes ``iocage start`` for any swarm members not in
   ``iocage_jails_started``.

4. **Destruction**:
   When ``swarm_destroy: true`` (or tag ``swarm_destroy``) is run, members of the
   targeted swarm are discovered via ``_swarm_exist``, stopped with ``iocage stop``,
   and removed with ``iocage destroy --force``.

Tasks
^^^^^

The playbook orchestrates task files via ``ansible.builtin.import_tasks`` based on operational tags and variables:

.. list-table:: Task Files Overview
   :widths: 35 20 45
   :header-rows: 1

   * - Task File
     - Guard / Tag
     - Description
   * - ``pb_iocage_ansible_clients/clone.yml``
     - ``clone``
     - Creates and starts named clones from templates.
   * - ``pb_iocage_ansible_clients/clone_destroy.yml``
     - ``clone_destroy``
     - Stops and destroys named clone instances.
   * - ``pb_iocage_ansible_clients/swarm.yml``
     - ``swarm``
     - Batches creation and startup of auto-UUID swarm jails.
   * - ``pb_iocage_ansible_clients/swarm_destroy.yml``
     - ``swarm_destroy``
     - Stops and destroys all jails belonging to specified swarms.
   * - ``pb_iocage_ansible_clients/get_inventory.yml``
     - *(Internal)*
     - Discovers active jails, parses ``notes`` tags, and populates ``iocage_jails_tags``.
   * - ``pb_iocage_ansible_clients/list.yml``
     - ``list``
     - Collects facts and displays jail keys and dictionaries.

Examples
^^^^^^^^

clones
""""""

Use the dictionary ``clones`` to define named jails with explicit host configuration:

.. code-block:: yaml

   clones:
     test-111:
       clone_from: ansible-client
       properties:
         ip4_addr: 'em0|10.1.0.111/24'
     test-112:
       clone_from: ansible-client
       properties:
         ip4_addr: 'em0|10.1.0.112/24'
     test-113:
       clone_from: ansible-client
       properties:
         ip4_addr: 'em0|10.1.0.113/24'

   vmm_clones: "{{ (project_clones | vbotka.freebsd.project).vmm }}"
   project_clones: "{{ dict(clones.keys()
                            | zip(clones.values()
                                  | map('combine', {'vmm': inventory_hostname}))) }}"

Create and start the cloned jails:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone -e clone=true \
                            pb_iocage_ansible_clients.yml

Stop and destroy the cloned jails:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone_destroy -e clone_destroy=true \
                            pb_iocage_ansible_clients.yml

swarms
""""""

Use the dictionary ``swarms`` to define clusters of interchangeable jails with
automatically generated UUIDs:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible-client
       class: [test]

   properties:
     bpf: 1
     dhcp: 1
     vnet: 1

   vmm_swarms: "{{ (project_swarms | vbotka.freebsd.project).vmm }}"
   project_swarms: "{{ dict(swarms.keys()
                            | zip(swarms.values()
                                  | map('combine', {'vmm': inventory_hostname}))) }}"

Create and start the swarm:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            pb_iocage_ansible_clients.yml

Stop and destroy the swarm:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm_destroy -e swarm_destroy=true \
                            pb_iocage_ansible_clients.yml

Listing Jails
"""""""""""""

Inspect existing jails and their evaluated keys on the jail manager nodes:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t list -e debug=true \
                            pb_iocage_ansible_clients.yml

.. seealso::

   * :ref:`example_200`
   * :ref:`example_202`
   * :ref:`example_203`
   * :ref:`example_206`
   * :ref:`ug_inventory_iocage2`
   * :ref:`ug_module_iocage`
