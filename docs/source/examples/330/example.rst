.. _example_330:

330 Clone jails and create inventory
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pb-iocage-fetch-base-clone.yml; Example 330
.. index:: single: pb-iocage-list.yml; Example 330

.. index:: single: module ansible.builtin.add_host; Example 330
.. index:: single: role vbotka.freebsd.iocage; Example 330
.. index:: single: tasks runner.yml; Example 330

.. index:: single: variable freebsd_iocage_runner_cmd; Example 330
.. index:: single: variable freebsd_iocage_runner_exec; Example 330

Use case
^^^^^^^^

Fetch releases, create basejails, clone from the basejails, and start the
jails. Create and display the inventory. Use the `role vbotka.freebsd.iocage`_
instead of the :ref:`ug_plugins`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-iocage-fetch-base-clone.yml
  ├── pb-iocage-list.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two managed nodes:

  In the playbook ``pb-iocage-fetch-base-clone.yml``, use the `role
  vbotka.freebsd.iocage`_ to:

  * Fetch the release
  * Create a basejail
  * Clone three jails from the basejail

  In the playbook ``pb-iocage-list.yml``, use the `role vbotka.freebsd.iocage`_
  to:

  * Create lists of bases and jails
  * Optionally, display the lists

  In the playbook ``pb-test.yml``:

  * Create the inventory group ``test`` and compose variables
  * Display the hosts and composed variables in the group ``test``
  * Display all groups

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* Root privileges on the managed nodes
* Activated ``iocage``

Notes
^^^^^

* This example demonstrates functionality similar to :ref:`example_010`.

* The `role vbotka.freebsd.iocage`_ is preinstalled in this collection.

.. seealso::

   * `Fetch a Release`_
   * `Create a Jail`_
   * `Start, Stop, or Restart a Jail`_
   * `Listing Jails`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-iocage-fetch-base-clone.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t debug -e debug=true \
                            pb-iocage-fetch-base-clone.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook output - Runner
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t runner \
                            pb-iocage-fetch-base-clone.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. note:: The commands ``iocage set ...`` are not idempotent.

.. hint::

   See the log on the remote host::

     shell> tail -f /var/log/iocage.log

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Playbook pb-iocage-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-list.yml
   :language: yaml+jinja

Playbook output - Display iocage_jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -e debug=true \
                            pb-iocage-list.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja
   :emphasize-lines: 1,4,31

Playbook output - Create and use group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:
