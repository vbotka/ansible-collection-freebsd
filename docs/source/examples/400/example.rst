.. _example_400:

400 Configure ZFS
-----------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: ZFS; Example 400
.. index:: single: role vbotka.freebsd.zfs; Example 400
.. index:: single: vbotka.freebsd.zfs; Example 400

Use case
^^^^^^^^

Configure ZFS pools and datasets in an iocage host.

Tree
^^^^

::

  shell > tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_02
  │       └── zfs.yml
  ├── iocage-hosts.ini
  └── pb-zfs.yml

Synopsis
^^^^^^^^

* At the iocage host ``iocage_02``

  * create ZFS pools:

    * ``zroot``
    * ``export``

  * create ZFS datasets:

    * ``zroot/jails``
    * ``zroot/poudriere``
    * ``export/scratch``
    * ``export/iso``

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.zfs`_
* role `vbotka.freebsd.postinstall`_

Notes
^^^^^

* The role `vbotka.freebsd.postinstall`_ is used to configure ``sysctl``

.. note::

   | `vbotka.freebsd.zfs`_ is the role **zfs** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_zfs`_ is the role **freebsd_zfs** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `The Z File System (ZFS)`_
   * `FreeBSD Wiki ZFS`_
   * `FreeBSD Wiki Category Zfs`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

host_vars
^^^^^^^^^
  
.. literalinclude:: host_vars/iocage_02/zfs.yml
   :language: yaml
   :caption:

Playbook pb-zfs.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-zfs.yml
   :language: yaml

Playbook output - debug display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02 \
                                       -t fzfs_debug -e fzfs_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - configure ZFS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage-hosts.ini -l iocage_02

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs
.. _vbotka.freebsd_zfs: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_zfs
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289

.. _The Z File System (ZFS): https://docs.freebsd.org/en/books/handbook/zfs/
.. _FreeBSD Wiki ZFS: https://wiki.freebsd.org/ZFS
.. _FreeBSD Wiki Category Zfs: https://wiki.freebsd.org/CategoryZfs
