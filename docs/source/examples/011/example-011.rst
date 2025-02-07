.. _example_011:

011 Display variables iocage_*
------------------------------

Extending example 010.

.. contents:: Table of Contents
   :depth: 2

Synopsis
^^^^^^^^

.. index:: single: variables iocage_*; Example 011

Display all variables *iocage_\** created by the inventory plugin.

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
