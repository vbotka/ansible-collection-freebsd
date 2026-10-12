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

Synopsis
^^^^^^^^

The playbook ``vbotka.freebsd.pb_iocage_project_create.yml`` automates the bulk
creation, metadata tagging, and startup of FreeBSD jails across one or more
iocage jail manager hosts declared in an inventory.

The playbook calculates the delta between declared project jail aliases and
currently existing inventory hosts to ensure idempotency. It batches jail
creation using ``iocage create --count``, writes structured metadata (alias,
class memberships, and host assignment) into the jail ``notes`` property, and
starts the newly provisioned instances.

.. hint::

   Search ``pb_iocage_project_create.yml`` in :ref:`genindex` for available examples.

Requirements
^^^^^^^^^^^^

- Root or ``sudo``/``doas`` privilege escalation on the managed nodes.
- A functional ``iocage`` installation on the managed nodes with the specified
  template already present (e.g., ``ansible-init`` or ``ansible-client``).
- Dual-inventory configuration:

  - An inventory describing the jail manager nodes (e.g., ``iocage.ini``).

  - An inventory discovering existing jails (e.g., ``hosts/``) so that
    ``groups.all`` contains currently deployed jail aliases.

Parameters
^^^^^^^^^^

.. list-table:: Playbook Variables
   :widths: 22 15 15 48
   :header-rows: 1

   * - Variable
     - Type
     - Default
     - Description
   * - :ref:`project <ug_concepts_project>`
     - dictionary
     - *(Required)*
     - Dictionary of jail definitions where keys are jail aliases and values
       specify target host (``vmm``) and class lists (``class``).
   * - ``project_template``
     - string
     - ``ansible-init``
     - Name of the iocage template used to create the jails.
   * - ``properties``
     - dictionary
     - ``{}``
     - iocage jail properties to pass to
       ``iocage create`` (e.g., ``bpf: 1``, ``dhcp: 1``, ``vnet: 1``).
   * - ``debug``
     - boolean
     - ``false``
     - Enables debug output tasks displaying evaluated variables, missing
       jails, and newly created jail UUIDs.
   * - ``vmm``
     - dictionary
     - *(Computed)*
     - Mapping of iocage hosts to their assigned jail dictionaries, typically
       derived using ``(project | vbotka.freebsd.project).vmm``.
   * - ``class``
     - dictionary
     - *(Computed)*
     - Mapping of class groups to jail aliases, typically derived using
       ``(project | vbotka.freebsd.project).class``.

Workflow
^^^^^^^^

1. **Host Evaluation & Delta Calculation**:
   On each managed iocage host, the variable ``iocage_jails_absent`` computes:

   .. code-block:: yaml

      iocage_jails_absent: "{{ vmm[inventory_hostname] | difference(groups.all) }}"

   If no jails are missing on the target host (``iocage_jails_absent | length == 0``),
   the host execution terminates via ``ansible.builtin.meta: end_host``.

2. **Batch Creation**:
   Invokes ``iocage create --short --template <template> --count <count> <properties>``
   to create the missing jails.

3. **Notes**:
   Loops over the created jails and assigns structured iocage tags to the jail's
   ``notes`` property:

   .. code-block:: none

      alias=<alias> class=<class1,class2,...> vmm=<host>

4. **Jail Startup**:
   Runs ``iocage start`` with the batch of created jail identifiers.

Example
^^^^^^^

1. Define jail managers inventory in ``iocage.ini``:

   .. code-block:: ini
      :caption: iocage.ini

      [iocage]
      iocage_05
      iocage_06

      [iocage:vars]
      ansible_user=admin
      ansible_become=true

2. Define jails inventory in ``hosts/``:

   .. code-block:: ini
      :caption: hosts/05_iocage.yml

      plugin: vbotka.freebsd.iocage
      host: iocage_05
      user: admin
      get_properties: true
      inventory_hostname_tag: alias

   .. code-block:: ini
      :caption: hosts/06_iocage.yml

      plugin: vbotka.freebsd.iocage
      host: iocage_06
      user: admin
      get_properties: true
      inventory_hostname_tag: alias

3. Declare project specifications in ``group_vars/all/project.yml``:

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
        dhcp: 1
        vnet: 1

4. Execute the playbook:

   .. code-block:: console

      (env) > ansible-playbook -i hosts -i iocage.ini \
                               vbotka.freebsd.pb_iocage_project_create.yml

.. seealso::

   * :ref:`ug_concepts_project`
   * :ref:`example_207`
   * :ref:`ug_inventory_iocage2`
   * :ref:`ug_pb-iocage-project-destroy`
