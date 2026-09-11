.. _example_010:

010 Clone basejails and create inventory
----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.iocage; Example 010
.. index:: single: inventory vbotka.freebsd.iocage; Example 010
.. index:: single: option compose; Example 010
.. index:: single: compose; Example 010
.. index:: single: option keyed_groups; Example 010
.. index:: single: keyed_groups; Example 010

.. index:: single: iocage_jails; Example 010
.. index:: single: iocage_plugins; Example 010
.. index:: single: iocage_releases; Example 010
.. index:: single: iocage_templates; Example 010

Use case
^^^^^^^^

Fetch releases, create basejails, clone jails from the basejails, and
start the jails. Use the :ref:`ug_inventory_iocage` to
create the inventory. Display the created inventory.

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
  ├── iocage.yml
  ├── pb-iocage-fetch-base-clone-list.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage-fetch-base-clone-list.yml``, use the
  :ref:`ug_module_iocage` to:

  * Fetch the release
  * Create a basejail
  * Clone 3 jails from the basejail
  * Start 1 jail
  * Display lists of bases, plugins, templates, and jails

* On the managed node ``iocage_04``:

  In the playbook ``pb-test.yml``, use the `inventory plugin
  vbotka.freebsd.iocage`_ to:

  * Create inventory groups and compose variables
  * Display the hosts and composed variables in the group ``test``
  * Display all created groups

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Root privileges on the managed nodes
* An activated `binary iocage`_

Notes
^^^^^

Fetching a release is quite time-consuming. Optionally, fetch the
releases manually before running the playbook. For example:

.. code-block:: console

   [iocage_02]# iocage fetch
   [0] 13.4-RELEASE
   [1] 13.5-RELEASE
   [2] 14.1-RELEASE (EOL)
   [3] 14.2-RELEASE

   Type the number of the desired RELEASE
   Press [Enter] to fetch the default selection: (14.2-RELEASE)
   Type EXIT to quit: 3
   Fetching: 14.2-RELEASE

   Extracting: base.txz...
   Extracting: lib32.txz...
   Extracting: src.txz...

   * Updating 14.2-RELEASE to the latest patch level...
   Looking up update.FreeBSD.org mirrors... 3 mirrors found.
   Fetching metadata signature for 14.2-RELEASE from update2.freebsd.org... done.
   Fetching metadata index... done.
   Inspecting system... done.
   Preparing to download files... done.
   The following files will be removed as part of updating to
   14.2-RELEASE-p3:
   /etc/ssl/certs/08063a00.0
   /etc/ssl/certs/18856ac4.0
   /etc/ssl/certs/57bcb2da.0
   ...

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

Playbook pb-iocage-fetch-base-clone-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone-list.yml
   :language: yaml+jinja

Playbook output - Fetch, create, clone, and start
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-fetch-base-clone-list.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

The jails at ``iocage_04``:

.. literalinclude:: iocage.yml
   :language: yaml+jinja
   :emphasize-lines: 2

.. seealso::

   * `Inventory plugin ansible.builtin.constructed`_
   * `Enabling inventory cache plugins`_

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:
   :emphasize-lines: 30-35
