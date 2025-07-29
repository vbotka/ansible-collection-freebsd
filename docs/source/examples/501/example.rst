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

Configure iocage host.

Tree
^^^^

::

  shell > tree .
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

At the iocage host ``iocage_04``:

* configure ``/home/admin/.login_conf``
* install packages
* configure ``/boot/loader.conf``
* configure network
* configure ``pf``
* create ZFS pool ``iocage``
* activate iocage pool ``iocage``
* fetch release
* test ``iocage`` sanity.

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
  * install packages
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
   :language: yaml
   :caption:

host_vars
^^^^^^^^^
  
.. literalinclude:: host_vars/iocage_04/loader.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/login.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/network.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/packages.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/pf.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/zfs.yml
   :language: yaml
   :caption:

.. note::

   Destroy the GPT tables on the disks you want to create the pool from ::

     [iocage_04]# gpart destroy -F ada2
     [iocage_04]# gpart destroy -F ada3

   Otherwise, you'll see the bellow complains in the dmesg ::

     GEOM: ada2: the primary GPT table is corrupt or invalid.
     GEOM: ada2: using the secondary instead -- recovery strongly advised.
     GEOM: ada3: the primary GPT table is corrupt or invalid.
     GEOM: ada3: using the secondary instead -- recovery strongly advised.

   There is no reason for any GPT tables if the whole disks are used by a pool ::

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
   :language: yaml
   :caption:

Playbooks
^^^^^^^^^

.. literalinclude:: pb-login.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-packages.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-loader.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-network.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-pf.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-zfs.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-iocage.yml
   :language: yaml
   :caption:

Playbooks' outputs
^^^^^^^^^^^^^^^^^^

Configure /home/admin/.login_conf
"""""""""""""""""""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-login.yml -i iocage.ini

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Install packages
""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-packages.yml -i iocage.ini

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

.. _example_501_loader:
      
Configure /boot/loader.conf
"""""""""""""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-loader.yml -i iocage.ini

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

.. note::

   Reboot if you see the message ::

     [MESSAGE] Reboot to activate configuration in /boot/loader.conf

Configure network
"""""""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-network.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Configure pf
""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-pf.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Configure ZFS
"""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage.ini

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

.. seealso::

   Module community.general.zpool :ref:`example_400_known_issues`.

Activate iocage
"""""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini \
                                          -t freebsd_iocage_activate -e freebsd_iocage_activate=true \
					  -e freebsd_iocage_debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Fetch release
"""""""""""""

.. literalinclude:: out/out-08.txt
   :language: console

Sanity iocage
"""""""""""""

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini \
                                          -t freebsd_iocage_sanity

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:

All playbooks
^^^^^^^^^^^^^

.. literalinclude:: pb-all.yml
   :language: yaml
   :caption:

All playbooks output
^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb-all.yml -i iocage.ini

.. literalinclude:: out/out-10.txt
   :language: yaml
   :force:

      
.. _vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/
.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs/
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/

.. _community.general.zpool: https://docs.ansible.com/ansible/devel/collections/community/general/zpool_module.html

.. _pf and bridge: https://forums.freebsd.org/threads/pf-and-bridge-4.77952/
.. _man if_bridge: https://man.freebsd.org/cgi/man.cgi?query=if_bridge
.. _Changing how I use IP address with FreeBSD's vnet: https://dan.langille.org/2023/08/14/changing-how-i-use-ip-address-with-freebsds-vnet-so-ipv6-works/
