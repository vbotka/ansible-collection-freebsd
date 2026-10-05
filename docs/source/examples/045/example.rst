.. _example_045:

045 Filter combine_properties
-----------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: filter vbotka.freebsd.combine_properties; Example 045
   single: vbotka.freebsd.combine_properties; Example 045
   single: combine_properties; Example 045
   single: project; Example 045
   single: swarms; Example 045
   single: property notes; Example 045

Use case
^^^^^^^^

Test the :ref:`filter vbotka.freebsd.combine_properties
<ug_filter_combine_properties>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  ├── pb-project.yml
  └── pb.yml

Synopsis
^^^^^^^^

TBD

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_combine_properties`

Notes
^^^^^

TBD

.. seealso::

   * TBD

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Test swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -l iocage_06 pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Playbook pb-project.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-project.yml
   :language: yaml+jinja

Playbook output - Test project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -l iocage_06 pb-project.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja