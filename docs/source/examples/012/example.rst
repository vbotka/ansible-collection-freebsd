.. _example_012:

012 Display iocage_properties
-----------------------------

This example extends :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index:: single: variable iocage_properties; Example 012
.. index:: single: iocage_properties; Example 012
.. index:: single: option get_properties; Example 012
.. index:: single: get_properties; Example 012
.. index:: single: option compose; Example 012
.. index:: single: compose; Example 012
.. index:: single: option keyed_groups; Example 012
.. index:: single: keyed_groups; Example 012

Use case
^^^^^^^^

Retrieve and display `iocage properties`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.yml
  └── pb-vars-properties.yml

Synopsis
^^^^^^^^

Display ``iocage_properties`` in a selected jail by enabling ``get_properties``
in the inventory plugin.

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

Enable ``get_properties``. See :ref:`inventory vbotka.freebsd.iocage
<ug_inventory_iocage>`.

.. literalinclude:: iocage.yml
   :language: yaml+jinja
   :emphasize-lines: 4

Playbook pb-vars-properties.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-properties.yml
   :language: yaml+jinja

Playbook output - Display iocage_properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.yml -l test_163 pb-vars-properties.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:
