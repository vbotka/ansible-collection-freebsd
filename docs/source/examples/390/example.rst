.. _example_390:

390 Build packages
------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.poudriere; Example 390
.. index:: single: vbotka.freebsd.poudriere; Example 390
.. index:: single: Poudriere; Example 390
.. index:: single: QEMU; Example 390
.. index:: single: ARM; Example 390
.. index:: single: armv6; Example 390
.. index:: single: armv7; Example 390
.. index:: single: aarch64; Example 390
.. index:: single: amd64; Example 390

Use case
^^^^^^^^

Use the role `vbotka.freebsd.poudriere`_ to install `poudriere`_ and build packages.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── build-hosts.ini
  ├── host_vars
  │   └── build.example.com
  │       ├── fp_qemu.yml
  │       ├── pkg_dict.yml
  │       └── poudriere.yml
  ├── pb-postinstall.yml
  └── pb.yml

Synopsis
^^^^^^^^

* At the remote host *build.example.com*:

  * in the playbook *pb.yml*, use the role `vbotka.freebsd.poudriere`_ to install and configure
    `poudriere`_.

  * in the playbook *pb-postinstall.yml*, use the role `vbotka.freebsd.postinstall`_ to install and
    configure `QEMU`_.

  * build packages.
    
Requirements
^^^^^^^^^^^^

* root privilege on the *build.example.com*.

Notes
^^^^^

* Building ARM (armv6, armv7, and aarch64) packages on amd64 needs `QEMU`_.

.. seealso::

   * FreeBSD Handbook `Building Packages with Poudriere`_
   * FreeBSD Wiki `FreeBSD ARM`_
   * FreeBSD Wiki `Building Packages Through Emulation`_
   * FreeBSD Forums `Building ARM Packages with Poudriere`_
   * Documentation `Ansible role FreeBSD Poudriere`_
   * `man poudriere`_

.. note::

   | `vbotka.freebsd.poudriere`_ is the role **poudriere** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_poudriere`_ is the role **freebsd_poudriere** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory build-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: build-hosts.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/build.example.com/poudriere.yml
   :language: yaml
   :caption: host_vars/build.example.com/poudriere.yml

.. literalinclude:: host_vars/build.example.com/pkg_dict.yml
   :language: yaml
   :caption: host_vars/build.example.com/pkg_dict.yml

.. seealso::

   The variables ``pkdict_*.yml`` in the directory `defaults/main`_ of the role
   `vbotka.freebsd_postinstall`_.

.. literalinclude:: host_vars/build.example.com/fp_qemu.yml
   :language: yaml
   :caption: host_vars/build.example.com/fp_qemu.yml

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

.. toctree::
   :caption: Playbook output
   :maxdepth: 1

   debug <pb_out_debug>
   install packages <pb_out_install>
   create SSL directories <pb_out_dirs>
   generate signing key <pb_out_key>
   generate SSL certificate <pb_out_cert>
   configure Poudriere <pb_out_conf>
   create package lists <pb_out_lists>
   customize make <pb_out_make>
   all tasks <pb_out_all>

.. toctree::
   :caption: Results
   :maxdepth: 1

   SSL certificate and signing key <result_tree_ssl>
   poudriere.conf <result_conf>
   package lists <result_pkglist>
   make.conf <result_make>

Playbook pb-postinstall.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-postinstall.yml
   :language: yaml

.. toctree::
   :caption: Playbook output
   :maxdepth: 1

   install QEMU <qemu_install>
   run QEMU <qemu_run>

Build packages
^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   create_jails
   create_ports
   build-142amd64-minimal
   qemu_list
   build-142aarch64-minimal

.. seealso::

   * `Export data`_ how to configure apache24.
   
.. _vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere
.. _vbotka.freebsd_poudriere: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_poudriere
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289

.. _poudriere: https://github.com/freebsd/poudriere
.. _Building Packages with Poudriere: https://docs.freebsd.org/en/books/handbook/ports/#ports-poudriere
.. _QEMU: https://docs.freebsd.org/en/books/handbook/virtualization/#qemu-virtualization-host-guest
.. _Ansible role FreeBSD Poudriere: https://ansible-freebsd-poudriere.readthedocs.io

.. _man poudriere: https://man.freebsd.org/cgi/man.cgi?poudriere
.. _FreeBSD ARM: https://wiki.freebsd.org/arm
.. _Building Packages Through Emulation: https://wiki.freebsd.org/Ports/BuildingPackagesThroughEmulation
.. _Building ARM Packages with Poudriere: https://forums.freebsd.org/threads/building-arm-packages-with-poudriere-the-simple-way.52994
.. _Export data: https://ansible-freebsd-poudriere.readthedocs.io/en/latest/guide-build-export.html#export-data

.. _defaults/main: https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
