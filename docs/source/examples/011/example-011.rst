.. _example_011:

011 Display variables iocage_*
------------------------------

Extending example 010.

.. contents:: Table of Contents
   :depth: 2

.. index:: single: variables iocage_*; Example 011
.. index:: single: option compose; Example 011
.. index:: single: compose; Example 011
.. index:: single: option keyed_groups; Example 011
.. index:: single: keyed_groups; Example 011

Use case
^^^^^^^^

Display all variables *iocage_\** created by the `inventory plugin vbotka.freebsd.iocage`_ plugin.

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── iocage.yml
   └── pb-vars-all.yml

Synopsis
^^^^^^^^

In a selected jail, display all variables *iocage_\** created by the inventory plugin in
:ref:`example_010`.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini
	       
Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.yml
    :language: yaml

Playbook *pb-vars-all.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-all.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. index:: single: variable iocage_ip4_dict; Example 011
.. index:: single: iocage_ip4_dict; Example 011

.. literalinclude:: out/out-01.txt
    :language: bash


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
