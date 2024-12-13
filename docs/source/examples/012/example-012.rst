.. _example_012:

012 Display iocage_properties.
------------------------------

Extending example 010.

.. contents:: Table of Contents
   :depth: 2

Synopsis
^^^^^^^^

Enable and display *iocage_properties*.

Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

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
