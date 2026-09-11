.. _example_390:

390 Build packages
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: Poudriere; Example 390
.. index:: single: role vbotka.freebsd.poudriere; Example 390
.. index:: single: vbotka.freebsd.poudriere; Example 390
.. index:: single: QEMU; Example 390
.. index:: single: ARM; Example 390
.. index:: single: armv6; Example 390
.. index:: single: armv7; Example 390
.. index:: single: aarch64; Example 390
.. index:: single: amd64; Example 390

Use case
^^^^^^^^

Use the role `vbotka.freebsd.poudriere`_ to install `poudriere`_ and
build packages.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  ├── host_vars
  │   └── build.example.com
  │       ├── fp_qemu.yml
  │       └── poudriere.yml
  ├── pb-postinstall.yml
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed node ``build.example.com``:

  * In the playbook ``pb.yml``, use the role
    `vbotka.freebsd.poudriere`_ to install and configure `poudriere`_.

  * In the playbook ``pb-postinstall.yml``, use the role
    `vbotka.freebsd.postinstall`_ to install and configure `QEMU`_.

  * Build packages.

Requirements
^^^^^^^^^^^^

* Root privileges on the managed node ``build.example.com``.

Notes
^^^^^

* Building ARM (armv6, armv7, and aarch64) packages on amd64 requires `QEMU`_.

.. seealso::

   * FreeBSD Handbook `Building Packages with Poudriere`_
   * FreeBSD Wiki `FreeBSD ARM`_
   * FreeBSD Wiki `Building Packages Through Emulation`_
   * FreeBSD Forums `Building ARM Packages with Poudriere`_
   * Documentation `Ansible role FreeBSD Poudriere`_
   * `man poudriere`_

.. note::

   | `vbotka.freebsd.poudriere`_ is the role **poudriere** in the collection ``vbotka.freebsd``.
   | `vbotka.freebsd_poudriere`_ is the role **freebsd_poudriere** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/build.example.com/poudriere.yml
   :language: yaml+jinja
   :caption:

.. seealso::

   The variables ``pkdict_*.yml`` in the directory `defaults/main`_ of
   the role `vbotka.freebsd_postinstall`_.

.. literalinclude:: host_vars/build.example.com/fp_qemu.yml
   :language: yaml+jinja
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

Limit ``pkg_dict_*`` for testing.

.. literalinclude:: pb.yml
   :language: yaml+jinja

.. toctree::
   :caption: Playbook output
   :maxdepth: 1

   Display variables <pb_out_debug>
   Install packages <pb_out_install>
   Create SSL directories <pb_out_dirs>
   Generate signing key <pb_out_key>
   Generate SSL certificate <pb_out_cert>
   Configure Poudriere <pb_out_conf>
   Create package lists <pb_out_lists>
   Customize make <pb_out_make>
   All tasks <pb_out_all>

.. toctree::
   :caption: Results
   :maxdepth: 1

   SSL certificate and signing key <result_tree_ssl>
   poudriere.conf <result_conf>
   Package lists <result_pkglist>
   make.conf <result_make>

Playbook pb-postinstall.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-postinstall.yml
   :language: yaml+jinja

.. toctree::
   :caption: Playbook output
   :maxdepth: 1

   Install QEMU <qemu_install>
   Run QEMU <qemu_run>

Build packages
^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   create_jails
   create_ports
   build-142amd64-minimal
   build-142amd64-All
   qemu_list
   build-142aarch64-minimal

.. seealso::

   * `Export data`_ on how to configure apache24.
   * :ref:`example_423`
