.. _example_016:

016 Multiple inventory constructed.
-----------------------------------

Extending example 015.

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   └── 03_constructed.yml
   └── pb-test.yml

Synopsis
^^^^^^^^

* Use the inventory plugin `ansible.builtin.constructed`_ after the two *iocage* inventory files.

* The *iocage* plugin gets the jails(hosts):

  * *test_01:03* from the host *iocage_01* 
  * *test_11:13* from the host *iocage_02* 

  and creates inventory groups *test_01* and *test_02*

* The *constructed* plugin creates inventory group *test* including all hosts starting *'test'*
    
Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml

Inventory *hosts/03_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/03_constructed.yml
    :language: yaml
	       
Playbook *pb-test.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

.. note::

   * The inventory files in *hosts* are evaluated in alphabetical order.
   * See :ref:`example_015`


.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
