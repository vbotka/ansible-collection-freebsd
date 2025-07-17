.. _example_012:

012 Display iocage_properties
-----------------------------

Extending example :ref:`example_010`.

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

Enable and display ``iocage_properties``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.yml
  └── pb-vars-properties.yml

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

Enable ``get_properties``. See :ref:`ug_inventory_iocage`

.. literalinclude:: iocage.yml
    :language: yaml
    :emphasize-lines: 6

Playbook pb-vars-properties.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-properties.yml
    :language: yaml

Playbook output - display iocage_properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-vars-properties.yml -i iocage.yml -l test_113

.. literalinclude:: out/out-01.txt
    :language: yaml
    :force:


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
