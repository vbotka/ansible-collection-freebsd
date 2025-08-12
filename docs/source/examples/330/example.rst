.. _example_330:

330 Clone jails and create inventory
------------------------------------

.. contents::
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
  ├── iocage.ini
  ├── pb-iocage-fetch-base-clone.yml
  ├── pb-iocage-list.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* At two managed nodes:

  * iocage_01
  * iocage_02

  In the playbook ``pb-iocage-fetch-base-clone.yml``, use the `role vbotka.freebsd.iocage`_ to:

  * fetch the release
  * create basejail
  * clone 3 jails from the basejail.

  In the playbook ``pb-iocage-list.yml``, use the `role vbotka.freebsd.iocage`_ to:

  * create the lists of bases and jails
  * optionally, display the lists.

  In the playbook ``pb-test-01.yml``:

  * create the inventory group ``test`` and compose variables
  * display the hosts and composed variables in the group ``test``
  * display all groups.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* activated ``iocage``

Notes
^^^^^

* This example demonstrates a functionality similar to :ref:`example_010`.

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

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Playbook pb-iocage-fetch-base-clone.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-fetch-base-clone.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage.ini \
                                                           -t debug \
                                                           -e debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - Runner
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-fetch-base-clone.yml -i iocage.ini \
                                                           -t runner

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

.. note:: The commands ``iocage set ...`` are not idempotent.

.. hint::

   See the log on the remote host ::

     shell> tail -f /var/log/iocage.log

Jails at iocage_01
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_01]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Playbook pb-iocage-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-list.yml
   :language: yaml

Playbook output - Display iocage_jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-list.yml -i iocage.ini -e debug=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml
   :emphasize-lines: 1,4,31

Playbook output - Create and use group
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.ini

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _Fetch a Release: https://iocage.readthedocs.io/en/latest/basic-use.html#fetch-a-release
.. _Create a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#create-a-jail
.. _Start, Stop, or Restart a Jail: https://iocage.readthedocs.io/en/latest/basic-use.html#start-stop-or-restart-a-jail
.. _Listing Jails: https://iocage.readthedocs.io/en/latest/basic-use.html#listing-jails
