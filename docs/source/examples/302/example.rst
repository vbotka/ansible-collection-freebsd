.. _example_302:

302 Module vbotka.freebsd.cgetent
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: module vbotka.freebsd.cgetent; Example 302
   single: vbotka.freebsd.cgetent; Example 302
   single: cgetent; Example 302

Use case
^^^^^^^^

Test the :ref:`module vbotka.freebsd.cgetent <ug_module_cgetent>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-test-01.yml``, execute the examples.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_cgetent`

Notes
^^^^^

* TBD

.. seealso::

   * `getcap(3)`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml+jinja

Playbook output - Test
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test-01.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:
