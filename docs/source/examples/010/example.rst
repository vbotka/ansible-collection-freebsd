.. _example_010:

010 Clone basejails and create inventory (plugins)
--------------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.iocage; Example 010
.. index:: single: inventory vbotka.freebsd.iocage; Example 010
.. index:: single: option compose; Example 010
.. index:: single: compose; Example 010
.. index:: single: option keyed_groups; Example 010
.. index:: single: keyed_groups; Example 010

Use case
^^^^^^^^

Fetch releases, create basejails, clone from the basejails, and start the jails. Use the `inventory
plugin vbotka.freebsd.iocage`_ to create inventory. Display the created inventory.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   └── iocage_02
  │       └── iocage.yml
  ├── iocage-hosts.ini
  ├── iocage.yml
  ├── pb-iocage-fetch-base-clone-list.yml
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-fetch-base-clone-list.yml*, use the `module vbotka.freebsd.iocage`_ to:

  * fetch the release
  * create basejail
  * clone 3 jails from the basejail
  * start 1 jail
  * display lists of bases, plugins, templates, and jails.

* On the iocage host *iocage_02*
  
  In the playbook *pb-test-01.yml*, use the `inventory plugin vbotka.freebsd.iocage`_ to:

  * create the inventory groups and compose variables
  * display the hosts and composed variables in the group *test*
  * display all created groups.

Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated `binary iocage`_

Notes
^^^^^

The fetching of a release is a quite time-consuming procedure. Optionally, fetch the releases
manually before you run the play. For example,

.. code-block:: bash

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

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Playbook pb-iocage-fetch-base-clone-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone-list.yml
   :language: yaml

Playbook output - fetch, create, clone, and start
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-fetch-base-clone-list.yml -i iocage-hosts.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash
	       
Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

The jails at *iocage_02*

.. literalinclude:: iocage.yml
   :language: yaml
   :emphasize-lines: 2

.. seealso::

   * `Inventory plugin ansible.builtin.constructed`_
   * `Enabling inventory cache plugins`_

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:
   :emphasize-lines: 30-35


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
.. _Inventory plugin ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#ansible-collections-ansible-builtin-constructed-inventory
.. _Enabling inventory cache plugins: https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins
.. _Fetch a Release: https://iocage.readthedocs.io/en/latest/basic-use.html#fetch-a-release
.. _Create a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#create-a-jail
.. _Start, Stop, or Restart a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#start-stop-or-restart-a-jail
.. _Listing Jails: https://iocage.readthedocs.io/en/latest/basic-use.html#listing-jails
