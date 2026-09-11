.. _example_041:

041 Filter project
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: filter vbotka.freebsd.project; Example 041
.. index:: single: vbotka.freebsd.project; Example 041
.. index:: single: project; Example 041

Use case
^^^^^^^^

Use the :ref:`ug_filter_project` to restructure a project
dictionary.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  └── pb.yml

Synopsis
^^^^^^^^

Restructure a dictionary of jails and their hosts defined with ``vmm``
and ``class`` attributes:

* Group full service specifications under their respective host
  (``vmm``).

* Invert the ``class`` attribute into a reverse-lookup dictionary
  mapping class names to lists of ``jails``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_project`

Notes
^^^^^

* See :ref:`ug_concepts_project`.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja
   :emphasize-lines: 8-23,25-26

Playbook output - Test filter project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :emphasize-lines: 6-25,29-33
