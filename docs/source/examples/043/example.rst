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

Test filters `vbotka.freebsd.to_ucl`_ and `vbotka.freebsd.from_ucl`_

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

* In the playbook ``pb-test-to-ucl.yml`` test the filter `vbotka.freebsd.to_ucl`_

* In the playbook ``pb-test-from-ucl.yml`` test the filter `vbotka.freebsd.from_ucl`_

Requirements
^^^^^^^^^^^^

* filter `vbotka.freebsd.to_ucl`_
* filter `vbotka.freebsd.from_ucl`_

Notes
^^^^^

The filters ``to_ucl`` and ``from_ucl`` require `package ucl`_.

.. seealso::

   Example :ref:`example_322`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Playbook pb-test-to-ucl.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-to-ucl.yml
   :language: yaml
   :emphasize-lines: 7-15,20

Playbook output - Test to_ucl filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-to-ucl.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :emphasize-lines: 6-13

Playbook pb-test-from-ucl.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-from-ucl.yml
   :language: yaml
   :emphasize-lines: 7-16,22

Playbook output - Test from_ucl filter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i localhost, pb-test-from-ucl.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :emphasize-lines: 6-12


.. _vbotka.freebsd.to_ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/to_ucl/
.. _vbotka.freebsd.from_ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/from_ucl/
.. _package ucl: https://pypi.org/project/ucl/
