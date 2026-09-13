.. _example_011:

011 Display variables iocage_*
------------------------------

This example extends :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index:: single: inventory vbotka.freebsd.iocage; Example 011
.. index:: single: compose; Example 011
.. index:: single: iocage_ip4_dict; Example 011
.. index:: single: keyed_groups; Example 011
.. index:: single: option compose; Example 011
.. index:: single: option keyed_groups; Example 011
.. index:: single: variable iocage_ip4_dict; Example 011
.. index:: single: variables iocage_*; Example 011

Use case
^^^^^^^^

Display all variables ``iocage_*`` created by the :ref:`inventory
vbotka.freebsd.iocage <ug_inventory_iocage>`.

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

In a selected jail, display all variables ``iocage_*`` created by the inventory
plugin.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Jails created in :ref:`example_010`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.yml
   :language: yaml+jinja

Playbook pb-vars-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-all.yml
   :language: yaml+jinja

Playbook output - Display iocage_* variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.yml -l test_163 pb-vars-all.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:
