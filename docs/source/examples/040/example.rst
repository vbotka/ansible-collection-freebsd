.. _example_040:

040 Lookup galaxy_info
----------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: lookup vbotka.freebsd.galaxy_info; Example 040
.. index:: single: vbotka.freebsd.galaxy_info; Example 040
.. index:: single: galaxy.yml; Example 040

Use case
^^^^^^^^

Use the `lookup vbotka.freebsd.galaxy_info`_ to get the meta data from ``galaxy.yml``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host
  └── pb.yml

Synopsis
^^^^^^^^

At the managed node ``iocage_04`` in the playbook ``pb.yml`` use the `lookup
vbotka.freebsd.galaxy_info`_ to:

  * display the complete meta data dictionary from galaxy.yml
  * display the attributes authors and version.
  * fail with unknown attribute.

Requirements
^^^^^^^^^^^^

Notes
^^^^^

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts
   :language: ini

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Display the meta data from galaxy.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i hosts

.. literalinclude:: out/out-01.txt
   :language: yaml

.. _lookup vbotka.freebsd.galaxy_info: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/lookup/galaxy_info/
