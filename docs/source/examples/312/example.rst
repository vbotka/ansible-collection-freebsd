.. _example_312:

312 Clone jails and create inventory (role)
-------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: playbook pb-iocage-fetch-base-clone.yml; Example 312
.. index:: single: playbook pb-iocage-list.yml; Example 312
.. index:: single: module ansible.builtin.add_host; Example 312
.. index:: single: role vbotka.freebsd.iocage; Example 312
.. index:: single: tasks runner.yml; Example 312
.. index:: single: variable freebsd_iocage_runner_cmd; Example 312
.. index:: single: variable freebsd_iocage_runner_exec; Example 312

Use case
^^^^^^^^

Fetch releases, create basejails, clone from the basejails, and start the jails. Create and display
the inventory. Use the `role vbotka.freebsd.iocage`_ instead of the :ref:`ug_plugins`.

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
   ├── pb-iocage-fetch-base-clone.yml
   ├── pb-iocage-list.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-fetch-base-clone.yml*, use the `role vbotka.freebsd.iocage`_ to:

  * fetch the release
  * create basejail
  * clone 3 jails from the basejail.

  In the playbook *pb-iocage-list.yml*, use the `role vbotka.freebsd.iocage`_ to:

  * create the lists of bases and jails
  * optionally display the lists.

  In the playbook *pb-test-01.yml*:

  * create the inventory group *test* and compose variables
  * display the hosts and composed variables in the group *test*
  * display all groups.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated *iocage*

Notes
^^^^^

* This example demonstrates a functionality similar to that of :ref:`example_010`.
* The `role vbotka.freebsd.iocage`_ is preinstalled in this collection.

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

Playbook *pb-iocage-fetch-base-clone.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone.yml
    :language: yaml

Playbook debug output
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Playbook runner output
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

.. note:: The commands `"iocage set ..."` are not idempotent.
	       
.. hint::

   See the log on the remote host ::

     $ tail -f /var/log/iocage.log
	       
List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

Playbook *pb-iocage-list.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-list.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-05.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-06.txt
    :language: bash

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
