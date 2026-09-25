.. _example_210:

210 Test empty iocage notes
---------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: iocage notes; Example 210
.. index:: single: inventory vbotka.freebsd.iocage; Example 210
.. index:: single: pb-iocage.yml; Example 210
.. index:: single: pb-test.yml; Example 210

Use case
^^^^^^^^

Test empty iocage notes. Create ``iocage_tags``. The result should be an empty
dictionary.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   └── 06_iocage.yml
  ├── iocage.ini
  ├── pb-iocage.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  * In the playbook ``pb-iocage.yml``, run the command ``iocage get notes
    test-210`` and display the result.

  * In the playbook ``pb-test.yml``, use the :ref:`inventory
    vbotka.freebsd.iocage <ug_inventory_iocage>` to create and display
    ``iocage_tags``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`

Notes
^^^^^

* TBD

.. seealso::

   * `Set Jail Property`_
   * `Binary iocage`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:

Jails
^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: console

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Empty notes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Empty iocage_tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:
   :emphasize-lines: 6-7,11
