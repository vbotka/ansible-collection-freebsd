.. _example_510:

510 project ansible-pull
------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_client_pull; Example 510
.. index:: single: ansible_client_pull; Example 510

.. index:: single: playbook pb_iocage_project_create.yml; Example 510
.. index:: single: playbook pb_iocage_project_destroy.yml; Example 510
.. index:: single: project create; Example 510
.. index:: single: project destroy; Example 510

Use case
^^^^^^^^

Use the template ``ansible_client_pull`` to create project jails.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test-all.yml

Synopsis
^^^^^^^^

* At the managed node ``iocage_04`` in the playbook ``vbotka.freebsd.pb_iocage_project_create.yml``
  create ``project`` jails.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* templates ``ansible_client_pull`` created in :ref:`example_208`

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

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: console

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/project.yml
   :language: yaml
   :caption:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Playbook output - Create and start project jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create.yml \
                            -i hosts -i iocage.ini -e debug=true

.. seealso:: The playbook :ref:`ug_pb-iocage-project-create`
.. note::

   The inventory ``-i hosts`` provides the group of all created jails. The play can use it and
   create only the missing project jails. This makes the play idempotent despite the module
   ``ansible.builtin.command`` and ``iocage`` option ``--count`` being used.

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - Display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-all.yml -i hosts --flush-cache

.. note::

   * The inventory configuration files ``hosts/*.yml`` enable cache.
   * Flush the cache. Otherwise, the jails created in the previous play won't be included.

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Stop and destroy jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_destroy.yml \
                            -i hosts -i iocage.ini -e debug=true

.. seealso:: The playbook :ref:`ug_pb-iocage-project-destroy`

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - Display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
