.. _example_210:

210 Test empty iocage notes
---------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: iocage notes; Example 210

Use case
^^^^^^^^

Test empty iocage notes. Create ``iocage_tags``. The result should be
an empty dictionary.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   └── 04_iocage.yml
  ├── iocage.ini
  ├── pb-iocage.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed node ``iocage_04``:

  * In the playbook ``pb-iocage.yml``, run the command ``iocage get
    notes test_4`` and display the result.

  * In the playbook ``pb-test.yml``, use the `inventory plugin
    vbotka.freebsd.iocage`_ to create and display ``iocage_tags``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`

Notes
^^^^^

* TBD

.. seealso::

   * `Set Jail Property`_
   * `Binary iocage`_

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: console

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Display empty notes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display empty iocage_tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:
