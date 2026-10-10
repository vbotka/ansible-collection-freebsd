.. _example_207:

207 Create DHCP jails with auto UUID, iocage_tags, alias and class
------------------------------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: template ansible-client; Example 207
   single: ansible-client; Example 207
   single: DHCP; Example 207
   single: property notes; Example 207
   single: notes; Example 207
   single: alias; Example 207
   single: inventory alias; Example 207
   single: inventory class; Example 207
   single: filter vbotka.freebsd.project; Example 207
   single: vbotka.freebsd.project; Example 207
   single: project; Example 207
   single: inventory vbotka.freebsd.iocage; Example 207
   single: inventory ansible.builtin.constructed; Example 207
   single: module ansible.builtin.command; Example 207
   single: option inventory_hostname_tag; Example 207
   single: inventory_hostname_tag; Example 207
   single: option get_properties; Example 207
   single: get_properties; Example 207
   single: option hooks_results; Example 207
   single: hooks_results; Example 207
   single: option compose; Example 207
   single: compose; Example 207
   single: option groups; Example 207
   single: option keyed_groups; Example 207
   single: variable iocage_jails; Example 207
   single: iocage_jails; Example 207
   single: variable iocage_hooks; Example 207
   single: iocage_hooks; Example 207
   single: variable iocage_properties; Example 207
   single: iocage_properties; Example 207
   single: variable iocage_tags; Example 207
   single: iocage_tags; Example 207
   single: option iocage --count; Example 207
   single: option iocage --short; Example 207
   single: option iocage --template; Example 207
   single: pb_iocage_project_create.yml; Example 207
   single: pb_iocage_project_destroy.yml; Example 207
   single: project create; Example 207
   single: project destroy; Example 207

Use case
^^^^^^^^

On multiple iocage hosts, create and run VNET jails with a DHCP interface from
the template ``ansible-client``. Use the dictionary ``iocage_tags`` and the
option ``inventory_hostname_tag`` to create `inventory aliases`_. Group the
jails by iocage hosts, states, and classes. Declare the project in a single
dictionary. The dictionary keys are jail aliases.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook :ref:`ug_pb-iocage-project-create`, use:

  * :ref:`ug_inventory_iocage2` to create inventory.

  * Inventory `ansible.builtin.constructed`_ to create groups and compose
    variables:

    * iocage_tags
    * iocage_classes
    * ansible_host
    * ansible_jail_host
    * ansible_jail_name

  * Module ``ansible.builtin.command`` and `iocage`_ utility to:

    * Create jails
    * Set notes
    * Start jails

* On all jails:

  In the playbook ``pb-test.yml``:

  * Display selected variables.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-project-create`
* :ref:`ug_inventory_iocage2`
* Templates created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* TBD

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * `Binary iocage`_

Templates
^^^^^^^^^

.. literalinclude:: out/out-01.txt
   :language: console
   :caption: [iocage_05]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: console
   :caption: [iocage_06]# iocage list -lt

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: console
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: console
   :caption: [iocage_06]# iocage list -l

.. note::

   This example runs with pre-existing jails.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4-9

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

Playbook output - Create project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_create.yml

.. seealso:: The playbook :ref:`ug_pb-iocage-project-create`

.. note::

   The inventory ``-i hosts`` provides the group of all existing
   jails, allowing the play to create only missing project jails. This
   makes the play idempotent despite using the module
   ``ansible.builtin.command`` with the ``iocage`` option ``--count``.

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-06.txt
   :language: console

.. note::

   The jails ``pkg_repo``, ``repos``, and ``repos_devel`` are included only
   once. See :ref:`ug_qa_inventory_flat`.

Jails
^^^^^

.. literalinclude:: out/out-07.txt
   :language: console
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-08.txt
   :language: console
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

Playbook output - Destroy project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_destroy.yml

.. seealso:: The playbook :ref:`ug_pb-iocage-project-destroy`

.. literalinclude:: out/out-10.txt
   :language: yaml+jinja
   :force: