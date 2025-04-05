.. _example_016:

016 Multiple inventory constructed
----------------------------------

Extending example 015.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: inventory ansible.builtin.constructed; Example 016
.. index:: single: option compose; Example 016
.. index:: single: compose; Example 016
.. index:: single: option groups; Example 016
.. index:: single: groups; Example 016

Use case
^^^^^^^^

Use the inventory plugin `ansible.builtin.constructed`_ after the two `inventory plugin
vbotka.freebsd.iocage`_ configuration files.

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   └── 99_constructed.yml
   └── pb-test.yml

Synopsis
^^^^^^^^

* The *iocage* plugin gets the jails(hosts):

  * *test_101:103* from the host *iocage_01* 
  * *test_111:113* from the host *iocage_02* 

  and creates inventory groups *test_01* and *test_02*

* The *constructed* plugin creates inventory groups:

  * *test* including all hosts starting *'test'*
  * *test_up* including running hosts starting *'test'*

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

Notes
^^^^^

* The inventory files in the directory *hosts* are evaluated in the alphabetical order.
* See :ref:`example_015`
* The `inventory plugin vbotka.freebsd.iocage`_ doesn't provide the option `use_vars_plugins`_.
* See :ref:`example_019`.

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash
  
Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml

Inventory *hosts/99_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/99_constructed.yml
    :language: yaml
	       
Playbook *pb-test.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash


.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _use_vars_plugins: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#parameter-use_vars_plugins
