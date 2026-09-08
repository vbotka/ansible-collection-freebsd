.. _example_020:

020 Get inventory aliases from notes
------------------------------------

Extending :ref:`example_016`.

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 020
.. index:: single: inventory alias; Example 020
.. index:: single: alias; Example 020
.. index:: single: inventory vbotka.freebsd.iocage; Example 020
.. index:: single: inventory ansible.builtin.constructed; Example 020
.. index:: single: option inventory_hostname_tag; Example 020
.. index:: single: inventory_hostname_tag; Example 020
.. index:: single: option inventory_hostname_required; Example 020
.. index:: single: inventory_hostname_required; Example 020
.. index:: single: option compose; Example 020
.. index:: single: compose; Example 020

.. index:: single: option iocage --count; Example 020

Use case
^^^^^^^^

Get the `Inventory aliases`_ from the `Set Jail Property`_ ``notes``. In the `inventory plugin
vbotka.freebsd.iocage2`_, use the option ``inventory_hostname_tag`` to specify which tag to use.

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
  ├── pb-iocage-swarms-create.yml
  ├── pb-iocage-swarms-destroy.yml
  ├── pb-test-all.yml
  └── pb-test-db.yml

Synopsis
^^^^^^^^

* On a managed node:

  * Create jails using a template and the ``--count`` option
  * For each jail, set the property ``notes`` in the format ``tag1=val1 tag2=val2 ...``
  * Put the inventory alias into the tag ``alias=<alias>``

* In the `inventory plugin vbotka.freebsd.iocage2`_, retrieve the inventory aliases from the tag ``alias``

* In the inventory plugin `ansible.builtin.constructed`_, create the inventory groups

* Display the jails and groups

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage2`_
* Root privileges on the managed nodes
* Templates created in :ref:`example_202`

Notes
^^^^^

* The inventory files in the directory ``hosts`` are evaluated in alphabetical order.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * :ref:`example_016`

Templates at iocage_06
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

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

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 10

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

.. note::

   The value of the iocage tag ``alias`` is used as the inventory alias. If `iocage list is
   slow`_, use the cache.

Playbook pb-iocage-swarms-create.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-swarms-create.yml
   :language: yaml+jinja

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-swarms-create.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

.. hint::

   Run the command below to see the complete inventory::

     shell> ansible-inventory -i hosts --list --yaml

Jails at iocage_06
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - All groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook pb-iocage-swarms-destroy.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-swarms-destroy.yml
   :language: yaml+jinja

Playbook output - Destroy swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Destroy the swarms if you do not need them anymore.

.. code-block:: console

   (env) > ansible-playbook pb-iocage-swarms-destroy.yml -i iocage.ini -i hosts

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:


.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _Inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _Set Jail Property: https://freebsd.github.io/iocage/basic-use.html?highlight=properties#set-jail-property
.. _iocage list is slow: https://forums.freebsd.org/threads/freebsd-13-1-extremally-slow.86723