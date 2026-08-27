.. _example_400:

400 Configure ZFS
-----------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ZFS; Example 400
.. index:: single: role vbotka.freebsd.zfs; Example 400
.. index:: single: vbotka.freebsd.zfs; Example 400

.. index:: single: community.general.zfs; Example 400
.. index:: single: community.general.zfs_facts; Example 400
.. index:: single: community.general.zpool; Example 400
.. index:: single: community.general.zpool_facts; Example 400
.. index:: single: module community.general.zfs; Example 400
.. index:: single: module community.general.zfs_facts; Example 400
.. index:: single: module community.general.zpool; Example 400
.. index:: single: module community.general.zpool_facts; Example 400

.. index:: single: /boot/loader.conf; Example 400
.. index:: single: vfs.zfs.prefetch.disable; Example 400

Use case
^^^^^^^^

Use the role `vbotka.freebsd.zfs`_ to configure ZFS pools and datasets.

Tree
^^^^

::

  shell > tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_04
  │       ├── loader.yml
  │       └── zfs.yml
  ├── iocage.ini
  ├── pb-loader.yml
  └── pb-zfs.yml

Synopsis
^^^^^^^^

* At the managed host ``iocage_04``

  * create ZFS pools:

    * ``zroot``
    * ``iocage``

  * create and mount ZFS datasets:

    * ``zroot/export``      mount /export
    * ``iocage/ports``      mount /usr/ports
    * ``iocage/src``        mount /usr/src
    * ``iocage/obj``        mount /usr/obj
    * ``iocage/poudriere``  mount /usr/local/poudriere

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.zfs`_
* role `vbotka.freebsd.postinstall`_

Notes
^^^^^

The role `vbotka.freebsd.postinstall`_ is used to configure ``/boot/loader.conf``

.. note::

   | `vbotka.freebsd.zfs`_ is the role **zfs** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_zfs`_ is the role **freebsd_zfs** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `The Z File System (ZFS)`_
   * `FreeBSD Wiki ZFS`_
   * `FreeBSD Wiki Category ZFS`_

.. _example_400_known_issues:

Known issues
^^^^^^^^^^^^

* `zpool state=present is not idempotent #10771`_

The module `community.general.zpool`_ can't create correct diff. For example,

.. code-block:: yaml
   :force:

   (Pdb) p vdev_layout_diff
   {'before': {'vdevs': [{'type': 'stripe', 'disks': ['/dev/ada2']}, {'type': 'stripe', 'disks': ['/dev/ada3']}]},
    'after': {'vdevs': [{'type': 'stripe', 'disks': ['/dev/ada2', '/dev/ada3']}]}}


This makes the module not idempotent. It crashes when running repeatedly. For example,

.. code-block:: yaml
   :force:
      
   failed: [srv.example.org] (item=iocage) =>
       ansible_loop_var: item
       changed: false
       cmd: /sbin/zpool add iocage /dev/ada2 /dev/ada3
       item:
           key: iocage
           value:
               vdevs:
               -   disks:
                   - /dev/ada2
                   - /dev/ada3
       msg: |-
           invalid vdev specification
           use '-f' to override the following errors:
           /dev/ada2 is part of active pool 'iocage'
           /dev/ada3 is part of active pool 'iocage'
       rc: 1
       ...

Setting ``force: true`` doesn't help. At the moment, the only workaround is to skip the module if
the pool already exists. You'll see a warning. For example,

.. code-block:: yaml
   :force:
      
   TASK [vbotka.freebsd_zfs : Pools: WARNING | community.general.zpool skipped.] ****
   ok: [srv.example.org] =>
       msg: |-
           # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           # WARNING:
           #
           # The module community.general.zpool is not idempotent. It crashes
           # when running repeatedly. Because of the poor quality, the module
           # community.general.zpool will be skipped for pools:
           # ['iocage']
           #
           # Configure the skipped pools manually, if necessary.
           # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
  
.. literalinclude:: host_vars/iocage_04/loader.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/zfs.yml
   :language: yaml
   :caption:

Playbook pb-loader.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-loader.yml
   :language: yaml

Playbook output - loader.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-loader.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

.. note::

   Reboot if you see the message ::

     [MESSAGE] Reboot to activate configuration in /boot/loader.conf
      
Playbook pb-zfs.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-zfs.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage.ini -t fzfs_debug -e fzfs_debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Configure ZFS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage.ini

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - List pools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -t fzfs_facts_pools -e fzfs_debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - List datasets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -t fzfs_facts_ds -e fzfs_facts_ds=true -e fzfs_debug=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs/
.. _vbotka.freebsd_zfs: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_zfs/
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _The Z File System (ZFS): https://docs.freebsd.org/en/books/handbook/zfs/
.. _FreeBSD Wiki ZFS: https://wiki.freebsd.org/ZFS
.. _FreeBSD Wiki Category ZFS: https://wiki.freebsd.org/CategoryZfs

.. _community.general.zpool: https://docs.ansible.com/ansible/devel/collections/community/general/zpool_module.html

.. _zpool state=present is not idempotent #10771: https://github.com/ansible-collections/community.general/issues/10771
