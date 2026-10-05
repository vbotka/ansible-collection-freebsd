.. _example_021:

021 Inventory plugin iocage2
----------------------------

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

Use case
^^^^^^^^

Use the :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>` to
connect to the jails created in :ref:`example_020`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test-connection-vars.yml
  ├── pb-test-connection.yml
  └── pb-test-project.yml

Synopsis
^^^^^^^^

* In the :ref:`inventory vbotka.freebsd.iocage2 <ug_inventory_iocage2>`,
  retrieve the inventory aliases from the tag ``alias``.

* In the inventory plugin `ansible.builtin.constructed`_, create the inventory
  groups.

* Display the connection variables.

* Test the connection.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage2`
* :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>`
* Root privileges on the managed nodes
* Jails created in :ref:`example_020`

Notes
^^^^^

* The inventory files in the directory ``hosts`` are evaluated in alphabetical
  order.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * :ref:`example_016`

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

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 13-17

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Jails
^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-02.txt
   :language: console

Playbook pb-test-project.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-project.yml
   :language: yaml+jinja

Playbook output - Test project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-project.yml

.. literalinclude:: out/out-03.txt
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

.. literalinclude:: out/out-04.txt
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

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force: