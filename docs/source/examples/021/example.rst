.. _example_021:

021 Inventory plugin iocage2
----------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: inventory vbotka.freebsd.iocage2; Example 021
.. index:: single: inventory ansible.builtin.constructed; Example 021
.. index:: single: connection vbotka.freebsd.jailexec; Example 021
.. index:: single: vbotka.freebsd.jailexec; Example 021
.. index:: single: jailexec; Example 021
.. index:: single: option inventory_hostname_tag; Example 021
.. index:: single: inventory_hostname_tag; Example 021
.. index:: single: iocage tag alias; Example 021
.. index:: single: inventory alias; Example 021
.. index:: single: alias; Example 021

Use case
^^^^^^^^

In the `inventory plugin vbotka.freebsd.iocage2`_, use the option
``inventory_hostname_tag`` to specify which tag to create `Inventory aliases`_
from.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── swarms.yml
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-test-all.yml
  ├── pb-test-connection.yml
  └── pb-test-db.yml

Synopsis
^^^^^^^^

* In the `inventory plugin vbotka.freebsd.iocage2`_, retrieve the inventory aliases from the tag ``alias``.
* In the inventory plugin `ansible.builtin.constructed`_, create the inventory groups.
* Display the jails and groups.
* Test the connection.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage2`_
* :ref:`ug_connection_jailexec`
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
   :emphasize-lines: 5

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/swarms.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

Jails at iocage_06
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

Jails graph at iocage_06
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts -i iocage.ini --graph

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - Display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts --flush-cache pb-test-all.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-db.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-db.yml
   :language: yaml+jinja

Playbook output - Group swarm_db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-db.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-connection.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-connection.yml
   :language: yaml+jinja

Playbook output - Test connection and get hostname
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-connection.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:


.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _Inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _Set Jail Property: https://freebsd.github.io/iocage/basic-use.html?highlight=properties#set-jail-property
