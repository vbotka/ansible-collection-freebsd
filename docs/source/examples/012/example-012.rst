.. _example_012:

012 Display iocage_properties.
------------------------------

Extending example 010.

.. contents:: Table of Contents
   :depth: 2

Synopsis
^^^^^^^^

.. index:: single: variable iocage_properties; Example 012
.. index:: single: iocage_properties; Example 012

Enable and display *iocage_properties*.

Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. index:: single: option get_properties; Example 012
.. index:: single: get_properties; Example 012

Enable *get_properties*. See :ref:`ug_inventory_iocage`

.. literalinclude:: iocage.yml
    :language: yaml
    :emphasize-lines: 6

Playbook *pb-vars-properties.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-properties.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash
