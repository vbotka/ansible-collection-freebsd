.. _example_330:

330 Clone jails and create inventory (role)
-------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: playbook pb-iocage-fetch-base-clone.yml; Example 330
.. index:: single: playbook pb-iocage-list.yml; Example 330
.. index:: single: module ansible.builtin.add_host; Example 330
.. index:: single: role vbotka.freebsd.iocage; Example 330
.. index:: single: tasks runner.yml; Example 330
.. index:: single: variable freebsd_iocage_runner_cmd; Example 330
.. index:: single: variable freebsd_iocage_runner_exec; Example 330

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
  * optionally, display the lists.

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

* This example demonstrates a functionality similar to :ref:`example_010`.
* The `role vbotka.freebsd.iocage`_ is preinstalled in this collection.

.. seealso::

   * `Fetch a Release`_
   * `Create a Jail`_
   * `Start, Stop, or Restart a Jail`_
   * `Listing Jails`_

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Playbook *pb-iocage-fetch-base-clone.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone.yml
    :language: yaml

Playbook output - debug
^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage-hosts.ini \
                                                          -t debug \
                                                          -e debug=true

.. literalinclude:: out/out-01.txt
    :language: bash

Playbook output - runner
^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage-hosts.ini \
                                                          -t runner

.. literalinclude:: out/out-02.txt
    :language: bash

.. note:: The commands `"iocage set ..."` are not idempotent.
	       
.. hint::

   See the log on the remote host ::

     $ tail -f /var/log/iocage.log
	       
List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-03.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-04.txt
    :language: bash

Playbook *pb-iocage-list.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-list.yml
    :language: yaml

Playbook output - display iocage_jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-list.yml -i iocage-hosts.ini -e debug=true

.. literalinclude:: out/out-05.txt
    :language: yaml

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml
    :emphasize-lines: 1,4,31

Playbook output - create and use group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i iocage-hosts.ini

.. literalinclude:: out/out-06.txt
    :language: yaml

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _Fetch a Release: https://iocage.readthedocs.io/en/latest/basic-use.html#fetch-a-release
.. _Create a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#create-a-jail
.. _Start, Stop, or Restart a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#start-stop-or-restart-a-jail
.. _Listing Jails: https://iocage.readthedocs.io/en/latest/basic-use.html#listing-jails
