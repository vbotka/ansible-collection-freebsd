.. _example_203:

203 Create DHCP jails with auto UUID and iocage_tags
----------------------------------------------------

This example extends :ref:`example_202`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: swarms; Example 203
   single: template ansible-client; Example 203
   single: ansible-client; Example 203
   single: DHCP; Example 203
   single: property notes; Example 203
   single: notes; Example 203
   single: inventory vbotka.freebsd.iocage; Example 203
   single: module vbotka.freebsd.iocage; Example 203
   single: module ansible.builtin.command; Example 203
   single: pb_iocage_ansible_clients.yml; Example 203
   single: option compose; Example 203
   single: compose; Example 203
   single: option get_properties; Example 203
   single: get_properties; Example 203
   single: option hooks_results; Example 203
   single: hooks_results; Example 203
   single: variable iocage_hooks; Example 203
   single: iocage_hooks; Example 203
   single: variable iocage_properties; Example 203
   single: iocage_properties; Example 203
   single: variable iocage_tags; Example 203
   single: iocage_tags; Example 203
   single: option iocage --count; Example 203
   single: option iocage --short; Example 203
   single: option iocage --template; Example 203

Use case
^^^^^^^^

**Automatically generated UUID**

Automatically generate ``UUID`` names for jails. On each iocage host, create
three jails from the template ``ansible-client``:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible-client

The :ref:`module vbotka.freebsd.iocage <ug_module_iocage>` does not work
with multiple names. Use the module ``ansible.builtin.command`` instead. If the
``UUID`` is generated automatically, such a task is not idempotent anyway. For example:

.. code-block:: bash

   shell> iocage create --short --template ansible-client --count 3 bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_01 swarm=sw_01"
   iocage start cd31c2a2 d254f889 158ef36d

**The variable iocage_tags**

In the inventory plugin, compose the variable ``iocage_tags``:

.. code-block:: yaml

   iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))

For example:

.. code-block:: yaml

   iocage_tags:
     vmm: iocage_01
     swarm: sw_01

Create groups from ``iocage_tags``:

.. code-block:: yaml

   keyed_groups:
     - prefix: swarm
       key: iocage_tags.swarm
     - prefix: vmm
       key: iocage_tags.vmm

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── iocage.yml
  ├── hosts
  │   ├── 05_iocage.yml
  │   ├── 06_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook :ref:`ug_pb-iocage-ansible-clients`, use:

  * The :ref:`module vbotka.freebsd.iocage <ug_module_iocage>` to:

    * Create facts only.

  * The module ``ansible.builtin.command`` to:

    * Create jails.
    * Start jails.
    * Optionally, stop and destroy the jails.

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Display selected variables.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-ansible-clients`
* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Templates created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* TBD

.. seealso::

   * `binary iocage`_

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
   :emphasize-lines: 4-5

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4-5

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 3-4

.. note::

   * The option ``get_properties: True`` is needed to get the dictionary
     ``iocage_properties``.
   * The option ``hooks_results`` is needed to get the list ``iocage_hooks``.

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: console

Jails
^^^^^

.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the jails in ``swarms``::

     ansible-playbook -i iocage.ini \
                      -t swarm_destroy -e swarm_destroy=true \
                      vbotka.freebsd.pb_iocage_ansible_clients.yml
