.. _example_010:

010 Clone basejails and create inventory (plugins)
--------------------------------------------------

.. contents:: Table of Contents
   :depth: 2

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

.. index:: single: module vbotka.freebsd.iocage; Example 010
.. index:: single: inventory vbotka.freebsd.iocage; Example 010

* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated `binary iocage`_

Notes
^^^^^

.. seealso::

   * `Fetch a Release <https://iocage.readthedocs.io/en/latest/basic-use.html#fetch-a-release>`_
   * `Create a Jail <https://iocage.readthedocs.io/en/latest/basic-use.html#create-a-jail>`_
   * `Start, Stop, or Restart a Jail <https://iocage.readthedocs.io/en/latest/basic-use.html#start-stop-or-restart-a-jail>`_
   * `Listing Jails <https://iocage.readthedocs.io/en/latest/basic-use.html#listing-jails>`_

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

Playbook *pb-iocage-fetch-base-clone-list.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone-list.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash
	       
Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.yml
    :language: yaml

.. seealso::

   * `Inventory plugin ansible.builtin.constructed <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#ansible-collections-ansible-builtin-constructed-inventory>`_

   * `Enabling inventory cache plugins <https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins>`_

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-02.txt
    :language: bash

.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
