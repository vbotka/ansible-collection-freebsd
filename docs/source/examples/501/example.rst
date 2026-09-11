.. _example_501:

501 iocage host
---------------

.. contents::
   :local:
   :depth: 2

.. index:: single: postinstall; Example 501
.. index:: single: role vbotka.freebsd.postinstall; Example 501
.. index:: single: vbotka.freebsd.postinstall; Example 501

.. index:: single: network; Example 501
.. index:: single: role vbotka.freebsd.network; Example 501
.. index:: single: vbotka.freebsd.network; Example 501

.. index:: single: pf; Example 501
.. index:: single: role vbotka.freebsd.pf; Example 501
.. index:: single: vbotka.freebsd.pf; Example 501

.. index:: single: ZFS; Example 501
.. index:: single: role vbotka.freebsd.zfs; Example 501
.. index:: single: vbotka.freebsd.zfs; Example 501

.. index:: single: community.general.zfs; Example 501
.. index:: single: community.general.zfs_facts; Example 501
.. index:: single: community.general.zpool; Example 501
.. index:: single: community.general.zpool_facts; Example 501
.. index:: single: module community.general.zfs; Example 501
.. index:: single: module community.general.zfs_facts; Example 501
.. index:: single: module community.general.zpool; Example 501
.. index:: single: module community.general.zpool_facts; Example 501

.. index:: single: iocage activate; Example 501
.. index:: single: activate iocage; Example 501
.. index:: single: .login_conf; Example 501
.. index:: single: /boot/loader.conf; Example 501

Use case
^^^^^^^^

Configure an ``iocage`` host.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── iocage.yml
  ├── host_vars
  │   └── iocage_04
  │       ├── iocage.yml
  │       ├── loader.yml
  │       ├── login.yml
  │       ├── network.yml
  │       ├── packages.yml
  │       ├── pf.yml
  │       └── zfs.yml
  ├── iocage.ini
  ├── pb-all.yml
  ├── pb-iocage.yml
  ├── pb-loader.yml
  ├── pb-login.yml
  ├── pb-network.yml
  ├── pb-packages.yml
  ├── pb-pf.yml
  └── pb-zfs.yml

Synopsis
^^^^^^^^

On the managed node ``iocage_04``:

* Configure ``/home/admin/.login_conf``
* Install packages
* Configure ``/boot/loader.conf``
* Configure network
* Configure ``pf``
* Create ZFS pool ``iocage``
* Activate iocage pool ``iocage``
* Fetch release
* Test ``iocage`` sanity.

Requirements
^^^^^^^^^^^^

Roles:

* `vbotka.freebsd.iocage`_
* `vbotka.freebsd.network`_
* `vbotka.freebsd.pf`_
* `vbotka.freebsd.postinstall`_
* `vbotka.freebsd.zfs`_

Notes
^^^^^

* The role `vbotka.freebsd.postinstall`_ is used to:

  * configure ``/home/admin/.login_conf``
  * install ``packages``
  * configure ``/boot/loader.conf``

.. seealso::

   * Forum `pf and bridge`_
   * `man if_bridge`_
   * `Changing how I use IP address with FreeBSD's vnet`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/loader.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/login.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/network.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/packages.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/pf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/zfs.yml
   :language: yaml+jinja
   :caption:

.. note::

   Destroy the GPT tables on the disks you want to create the pool
   from. For example::

     [iocage_04]# gpart destroy -F ada2
     [iocage_04]# gpart destroy -F ada3

   Otherwise, you will see the warnings below in dmesg::

     GEOM: ada2: the primary GPT table is corrupt or invalid.
     GEOM: ada2: using the secondary instead -- recovery strongly advised.
     GEOM: ada3: the primary GPT table is corrupt or invalid.
     GEOM: ada3: using the secondary instead -- recovery strongly advised.

   There is no reason to have GPT tables if whole disks are dedicated
   to a pool::

     [iocage_04]# zpool status iocage
       pool: iocage
      state: ONLINE
     config:

             NAME        STATE     READ WRITE CKSUM
             iocage      ONLINE       0     0     0
               ada2      ONLINE       0     0     0
               ada3      ONLINE       0     0     0

     errors: No known data errors

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Playbooks
^^^^^^^^^

.. literalinclude:: pb-login.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-packages.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-loader.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-network.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-pf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-zfs.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja
   :caption:

Playbook outputs
^^^^^^^^^^^^^^^^

Configure /home/admin/.login_conf
"""""""""""""""""""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-login.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Install packages
""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-packages.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. _example_501_loader:

Configure /boot/loader.conf
"""""""""""""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-loader.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

.. note::

   Reboot if you see this message::

     [MESSAGE] Reboot to activate configuration in /boot/loader.conf

Configure network
"""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-network.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Configure pf
""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-pf.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Configure ZFS
"""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-zfs.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

.. seealso::

   Module community.general.zpool :ref:`example_400_known_issues`.

Activate iocage
"""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_activate -e freebsd_iocage_activate=true \
                            -e freebsd_iocage_debug=true \
                            pb-iocage.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Fetch release
"""""""""""""

.. note:: This example is not updated to the current release and serves
          demonstration purposes only.

.. literalinclude:: out/out-08.txt
   :language: console

iocage sanity test
""""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t freebsd_iocage_sanity pb-iocage.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

All playbooks
^^^^^^^^^^^^^

.. literalinclude:: pb-all.yml
   :language: yaml+jinja
   :caption:

All playbooks output
^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb-all.yml -i iocage.ini

.. literalinclude:: out/out-10.txt
   :language: yaml+jinja
   :force:
