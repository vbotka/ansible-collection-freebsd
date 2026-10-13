.. _ug_pb-iocage-project-create:

pb_iocage_project_create
------------------------

.. contents::
   :local:
   :depth: 3

.. index::
   single: pb_iocage_project_create.yml; pb_iocage_project_create
   single: project create; pb_iocage_project_create
   single: playbook; pb_iocage_project_create.yml
   single: iocage create; pb_iocage_project_create
   single: iocage notes; pb_iocage_project_create
   single: properties.yml; pb_iocage_project_create
   single: sanity.yml; pb_iocage_project_create
   single: start.yml; pb_iocage_project_create

Synopsis
^^^^^^^^

The playbook ``vbotka.freebsd.pb_iocage_project_create.yml`` automates the bulk
creation, property configuration, metadata tagging, and startup of FreeBSD jails
across one or more jail manager hosts declared in an inventory.

The playbook calculates the delta between declared project jail aliases and
currently existing inventory hosts to ensure idempotency. It supports optional
pre-flight sanity checks, batches jail creation using ``iocage create --count``,
configures custom jail properties and iocage tags (alias, class memberships,
and host assignment) via ``properties.yml``, and starts newly provisioned jails
configured to boot.

.. hint::

   Search ``pb_iocage_project_create.yml`` in :ref:`genindex` for available examples.

Requirements
^^^^^^^^^^^^

- Python 3 on the controller with Jinja2 and PyYAML.
- Root or ``sudo``/``doas`` privilege escalation on the jail manager hosts.
- A functional ``iocage`` installation on jail manager hosts with the specified
  template present (e.g., ``ansible-init`` or ``ansible-client``).
- Dual-inventory configuration passed at runtime:

  - An inventory describing the jail manager hosts (e.g., ``iocage.ini``).

  - An inventory discovering existing jails (e.g., ``hosts/`` using
    ``vbotka.freebsd.iocage2``) so that ``groups.all`` contains currently
    deployed jail aliases.

Parameters
^^^^^^^^^^

.. list-table:: Playbook Variables
   :widths: 22 15 15 48
   :header-rows: 1

   * - Variable
     - Type
     - Default
     - Description
   * - ``project``
     - dictionary
     - *(Required)*
     - Dictionary of jail definitions where keys are jail aliases and values
       specify target host (``vmm``) and class lists (``class``).
   * - ``project_template``
     - string
     - ``ansible-init``
     - Name of the existing iocage template used to create the new jails.
   * - ``properties``
     - dictionary
     - ``{}``
     - Key-value mapping of iocage jail properties applied during jail
       configuration (e.g., ``bpf: 1``, ``dhcp: 1``, ``vnet: 1``, ``boot: 'on'``).
   * - ``sanity``
     - boolean
     - ``true``
     - Executes validation tasks before creating jails.
   * - ``start``
     - boolean
     - ``true``
     - Controls importing startup tasks. Jails start when both ``start`` and
       ``properties.boot`` evaluate to true.
   * - ``debug``
     - boolean
     - ``false``
     - Displays debug output tasks.
   * - ``vmm``
     - dictionary
     - *(Computed)*
     - Mapping of jail manager hosts to their assigned jail dictionaries,
       typically derived using ``(project | vbotka.freebsd.project).vmm``.
   * - ``class``
     - dictionary
     - *(Computed)*
     - Mapping of class groups to jail aliases, typically derived using
       ``(project | vbotka.freebsd.project).class``.

Workflow
^^^^^^^^

1. **Debug & Setup**:
   Optionally displays project variables via ``debug.yml``, then executes
   initialization steps in ``setup.yml`` across the jail manager hosts.

2. **Sanity Checks**:
   When ``sanity: true`` (the default), invokes ``sanity.yml`` to validate
   prerequisites, configuration structures, and host definitions before
   proceeding.

3. **Delta Calculation & Batch Creation**:
   The tasks in ``create.yml`` determine missing jails by comparing declared
   project aliases against ``groups.all``. If missing jails are detected,
   ``iocage create --short --template <template> --count <count>`` creates
   the required batch of jails with short UUIDs.

4. **Setting Properties and Metadata**:
   The task file ``properties.yml`` pairs the created UUIDs with the missing
   project aliases (populating ``project_jails_created``) and applies custom
   iocage properties along with structured tags in ``notes``:

   .. code-block:: none

      alias=<alias> class=<class1,class2,...> vmm=<host>

   This metadata is subsequently parsed by plugins such as
   ``ansible.builtin.constructed`` and ``vbotka.freebsd.iocage2`` to dynamically
   build inventory groups and host variables.

5. **Jail Startup**:
   When ``start: true`` (the default) and ``properties.boot`` evaluates to
   true, ``start.yml`` invokes ``iocage start`` for the newly created jails.

Example
^^^^^^^

1. Define jail manager hosts in ``iocage.ini``:

   .. code-block:: ini
      :caption: iocage.ini

      [iocage]
      iocage_05
      iocage_06

      [iocage:vars]
      ansible_user=admin
      ansible_become=true

2. Configure dynamic jail inventory sources in ``hosts/``:

   .. code-block:: yaml
      :caption: hosts/05_iocage2.yml

      plugin: vbotka.freebsd.iocage2
      host: iocage_05
      user: admin
      get_properties: true
      inventory_hostname_tag: alias
      hooks_results:
        - /var/db/dhclient-hook.address.epair0b

   .. code-block:: yaml
      :caption: hosts/06_iocage2.yml

      plugin: vbotka.freebsd.iocage2
      host: iocage_06
      user: admin
      get_properties: true
      inventory_hostname_tag: alias
      hooks_results:
        - /var/db/dhclient-hook.address.epair0b

   .. code-block:: yaml
      :caption: hosts/99_constructed.yml

      plugin: ansible.builtin.constructed

      compose:
        iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
        iocage_classes: iocage_properties.notes | regex_findall('(?<=class=)[\w\-]+|(?<=,)[\w\-]+')
        ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)
        ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
        ansible_jail_name: iocage_jid
        ansible_python_interpreter: "'auto_silent'"

      groups:
        db: iocage_classes is contains('db')
        http: iocage_classes is contains('http')
        log_servers: iocage_classes is contains('log-server')
        log_clients: iocage_classes is contains('log-client')

      keyed_groups:
        - prefix: state
          key: iocage_state
        - prefix: vmm
          key: iocage_tags.vmm

3. Declare project in ``group_vars/all/project.yml``:

   .. code-block:: yaml
      :caption: group_vars/all/project.yml

      project_template: ansible-client

      project:
        logserv_1:
          vmm: iocage_05
          class: [log-server]
        http_1:
          vmm: iocage_05
          class: [http, log-client]
        db_1:
          vmm: iocage_05
          class: [db, log-client]
        logserv_2:
          vmm: iocage_06
          class: [log-server]
        http_2:
          vmm: iocage_06
          class: [http, log-client]
        db_2:
          vmm: iocage_06
          class: [db, log-client]

      vmm: "{{ (project | vbotka.freebsd.project).vmm }}"
      class: "{{ (project | vbotka.freebsd.project).class }}"

      properties:
        bpf: 1
        boot: 'on'
        dhcp: 1
        vnet: 1

4. Execute the playbook:

   .. code-block:: console

      (env) > ansible-playbook -i hosts -i iocage.ini \
                               vbotka.freebsd.pb_iocage_project_create.yml

   To skip the startup tasks even when ``properties.boot`` is enabled:

   .. code-block:: console

      (env) > ansible-playbook -i hosts -i iocage.ini -e start=false \
                               vbotka.freebsd.pb_iocage_project_create.yml

.. seealso::

   * :ref:`ug_pb_comparison_clients_vs_project`
   * :ref:`ug_pb-iocage-project-destroy`
   * :ref:`ug_inventory_iocage2`
   * :ref:`example_207`
