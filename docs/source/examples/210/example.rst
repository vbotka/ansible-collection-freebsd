.. _example_210:

210 Test empty iocage notes
---------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: iocage notes; Example 210

Use case
^^^^^^^^

Test empty iocage notes. Create ``iocage_tags``. The result should be an empty dictionary.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   └── 04_iocage.yml
  ├── iocage.ini
  ├── pb-iocage.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* At the managed node ``iocage_04`` in the playbook:

  * ``pb-iocage.yml``, use the command ``iocage get notes test_4`` and display the result

  * ``pb-test.yml``, use `inventory plugin vbotka.freebsd.iocage`_ to create and display
    ``iocage_tags``


Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_

Notes
^^^^^

TBD

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

Playbook output - display empty notes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Inventory hosts
^^^^^^^^^^^^^^^
.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - display empty iocage_tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _Set Jail Property: https://iocage.readthedocs.io/en/latest/basic-use.html?highlight=properties#set-jail-property
.. _Binary iocage: https://github.com/iocage/iocage/
