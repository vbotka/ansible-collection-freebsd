.. _example_021:

021 Connection variables for jailexec
-------------------------------------

This example extends :ref:`example_020`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: inventory vbotka.freebsd.iocage2; Example 021
   single: inventory ansible.builtin.constructed; Example 021
   single: connection vbotka.freebsd.jailexec; Example 021
   single: vbotka.freebsd.jailexec; Example 021
   single: jailexec; Example 021
   single: option inventory_hostname_tag; Example 021
   single: inventory_hostname_tag; Example 021
   single: iocage tag alias; Example 021
   single: inventory alias; Example 021
   single: alias; Example 021
   single: option hooks_results; Example 021
   single: hooks_results; Example 021
   single: option ansible_connection; Example 021
   single: ansible_connection; Example 021
   single: option ansible_jail_host; Example 021
   single: ansible_jail_host; Example 021
   single: option ansible_jail_name; Example 021
   single: ansible_jail_name; Example 021
   single: option ansible_jail_privilege_escalation; Example 021
   single: ansible_jail_privilege_escalation; Example 021

Use case
^^^^^^^^

Use the inventory plugin :ref:`vbotka.freebsd.iocage2 <ug_inventory_iocage2>` to
retrieve the inventory. Use the connection plugin :ref:`vbotka.freebsd.jailexec
<ug_connection_jailexec>` to connect to the jails created in the example
:ref:`example_020`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test-connection-vars.yml
  ├── pb-test-connection.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the inventory plugin :ref:`vbotka.freebsd.iocage2
    <ug_inventory_iocage2>`, retrieve the inventory.

  * In the inventory plugin `ansible.builtin.constructed`_:

    * Compose:

      * The dictionary ``iocage_tags``.

      * The connection variables for the connection plugin
        :ref:`vbotka.freebsd.jailexec <ug_connection_jailexec>`.

    * Create inventory groups.

* On the jails in the group ``project_example_020``:

  * In the playbook ``pb-test.yml``:

    * Display the jails, groups, :ref:`ug_concepts_iocage_tags` , and selected
      variables.

  * In the playbook ``pb-test-connection-vars.yml``:

    * Display the connection variables.

  * In the playbook ``pb-test-connection.yml``:

    * Test the :ref:`connection plugin vbotka.freebsd.jailexec
      <ug_connection_jailexec>`.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Jails created in :ref:`example_020`.
* Root privileges on the managed nodes.

Notes
^^^^^

* TBD.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * :ref:`example_050`

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
   :emphasize-lines: 3,5-9,13-18

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in
     alphabetical order.

.. seealso::

   * Connection plugin :ref:`vbotka.freebsd.jailexec <ug_connection_jailexec>`

   * Best practice connection plugin :ref:`vbotka.freebsd.jailexec
     <ug_bp_connection_jailexec>`

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display variables and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-connection-vars.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-connection-vars.yml
   :language: yaml+jinja

Playbook output - Display connection variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-connection-vars.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-connection.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-connection.yml
   :language: yaml+jinja

Playbook output - Test connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-connection.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:
