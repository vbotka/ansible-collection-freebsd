.. _example_330:

330 Clone jails and create inventory (runner)
---------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: clones; Example 330
   single: runner; Example 330
   single: tasks runner.yml; Example 330
   single: role vbotka.freebsd.iocage; Example 330
   single: variable freebsd_iocage_runner_cmd; Example 330
   single: variable freebsd_iocage_runner_exec; Example 330
   single: pb-iocage-fetch-base-clone.yml; Example 330
   single: pb-iocage-list.yml; Example 330
   single: module ansible.builtin.add_host; Example 330
   single: ansible.builtin.add_host; Example 330

Use case
^^^^^^^^

Fetch releases, create basejails, clone jails from the basejails, and start the
jails. Create and display the inventory.

* To manage jails, use the tasks ``runner`` from the `role vbotka.freebsd.iocage`_.
* To parse `iocage datasets`_, use Jinja2.
* To create inventory, use the module ``ansible.builtin.add_host``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-iocage-fetch-base-clone.yml
  ├── pb-iocage-list.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-iocage-fetch-base-clone.yml``, use the `role
    vbotka.freebsd.iocage`_ to:

    * Fetch releases.
    * Create basejails.
    * Clone three jails from the basejails.

  * In the playbook ``pb-iocage-list.yml``, use the `role vbotka.freebsd.iocage`_
    to:

    * Get `iocage datasets`_.
    * Optionally, display the `iocage datasets`_.

  * In the playbook ``pb-test.yml``:

    * Create the inventory group ``test`` and `compose`_ variables.
    * Display the hosts and composed variables in the group ``test``.
    * Display inventory groups.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.iocage`_
* Activated `iocage`_.
* Root privileges on the managed nodes.

Notes
^^^^^

* This example demonstrates functionality similar to :ref:`example_010`.

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

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/iocage.yml
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

Playbook output - Clone jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t runner \
                            pb-iocage-fetch-base-clone.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. note::

   * The commands ``iocage set ...`` are not idempotent.

.. hint::

   See the log on the remote host::

     [iocage_05]# tail -f /var/log/iocage.log

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-iocage-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-list.yml
   :language: yaml+jinja

Playbook output - Display iocage datasets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -e debug=true pb-iocage-list.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja
   :emphasize-lines: 1,4,39

Playbook output - Create and use inventory group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:
