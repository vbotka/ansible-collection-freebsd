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

Use the `lookup vbotka.freebsd.galaxy_info`_ plugin to get the metadata from ``galaxy.yml``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  └── pb.yml

Synopsis
^^^^^^^^

On a managed node, in the playbook ``pb.yml``, use the `lookup
vbotka.freebsd.galaxy_info`_ plugin to:

* Display the complete metadata dictionary from ``galaxy.yml``
* Display the attributes ``authors`` and ``version``

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
   :language: yaml+jinja

Playbook output - Display the metadata from galaxy.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

.. _lookup vbotka.freebsd.galaxy_info: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/lookup/galaxy_info/