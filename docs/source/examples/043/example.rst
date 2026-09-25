.. _example_043:

043 Filters to_ucl and from_ucl
-------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: filter vbotka.freebsd.to_ucl; Example 043
.. index:: single: vbotka.freebsd.to_ucl; Example 043
.. index:: single: to_ucl; Example 043
.. index:: single: filter vbotka.freebsd.from_ucl; Example 043
.. index:: single: vbotka.freebsd.from_ucl; Example 043
.. index:: single: from_ucl; Example 043

Use case
^^^^^^^^

Test the filters :ref:`filter vbotka.freebsd.to_ucl <ug_filter_to_ucl>` and
:ref:`filter vbotka.freebsd.from_ucl <ug_filter_from_ucl>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── pb-test-from-ucl.yml
  └── pb-test-to-ucl.yml

Synopsis
^^^^^^^^

* In the playbook ``pb-test-to-ucl.yml``, test the :ref:`filter
  vbotka.freebsd.to_ucl <ug_filter_to_ucl>`.

* In the playbook ``pb-test-from-ucl.yml``, test the :ref:`filter
  vbotka.freebsd.from_ucl <ug_filter_from_ucl>`.

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_to_ucl`
* :ref:`ug_filter_from_ucl`

Notes
^^^^^

The filters ``to_ucl`` and ``from_ucl`` require the Python `package ucl`_.

.. seealso::

   * Example :ref:`example_322`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb-test-to-ucl.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-to-ucl.yml
   :language: yaml+jinja
   :emphasize-lines: 7-15,20

Playbook output - Test to_ucl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-to-ucl.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :emphasize-lines: 6-13

Playbook pb-test-from-ucl.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-from-ucl.yml
   :language: yaml+jinja
   :emphasize-lines: 7-16,22

Playbook output - Test from_ucl
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-from-ucl.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :emphasize-lines: 6-12
