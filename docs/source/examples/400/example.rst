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

Use the role `vbotka.freebsd.zfs`_ to configure ZFS pools and
datasets.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_04
  │       ├── loader.yml
  │       └── zfs.yml
  ├── iocage.ini
  ├── pb-loader.yml
  └── pb-zfs.yml

Synopsis
^^^^^^^^

* On the managed host ``iocage_04``:

  * Create ZFS pools:

    * ``zroot``
    * ``iocage``

  * Create and mount ZFS datasets:

    * ``zroot/export``      mounted on ``/export``
    * ``iocage/ports``      mounted on ``/usr/ports``
    * ``iocage/src``        mounted on ``/usr/src``
    * ``iocage/obj``        mounted on ``/usr/obj``
    * ``iocage/poudriere``  mounted on ``/usr/local/poudriere``

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.zfs`_
* Role `vbotka.freebsd.postinstall`_

Notes
^^^^^

The role `vbotka.freebsd.postinstall`_ is used to configure
``/boot/loader.conf``.

.. note::

   | `vbotka.freebsd.zfs`_ is the role **zfs** in the collection ``vbotka.freebsd``.
   | `vbotka.freebsd_zfs`_ is the role **freebsd_zfs** in the namespace `vbotka`_.

.. seealso::

   * `The Z File System (ZFS)`_
   * `FreeBSD Wiki ZFS`_
   * `FreeBSD Wiki Category ZFS`_

.. _example_400_known_issues:

Known issues
^^^^^^^^^^^^

* `zpool state=present is not idempotent #10771`_

The module `community.general.zpool`_ cannot create a correct
diff. For example:

.. code-block:: yaml
   :force:

   (Pdb) p vdev_layout_diff
   {'before': {'vdevs': [{'type': 'stripe', 'disks': ['/dev/ada2']}, {'type': 'stripe', 'disks': ['/dev/ada3']}]},
    'after': {'vdevs': [{'type': 'stripe', 'disks': ['/dev/ada2', '/dev/ada3']}]}}

This makes the module non-idempotent. It crashes when run
repeatedly. For example:

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

Setting ``force: true`` doesn't help. At the moment, the only
workaround is to skip the module if the pool already exists. You will
see a warning. For example:

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
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/zfs.yml
   :language: yaml+jinja
   :caption:

Playbook pb-loader.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-loader.yml
   :language: yaml+jinja

Playbook output - loader.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-loader.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

.. note::

   Reboot if you see the message::

     [MESSAGE] Reboot to activate configuration in /boot/loader.conf

Playbook pb-zfs.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-zfs.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t fzfs_debug -e fzfs_debug=true pb-zfs.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Playbook output - Configure ZFS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-zfs.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook output - List pools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -t fzfs_facts_pools -e fzfs_debug=treu pb-zfs.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook output - List datasets
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -t fzfs_facts_ds -e fzfs_facts_ds=true -e fzfs_debug=true pb-zfs.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:
