.. _example_311:

311 Configure and start git_daemon
----------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: postinstall; Example 311
   single: vbotka.freebsd.postinstall; Example 311
   single: role vbotka.freebsd.postinstall; Example 311
   single: git daemon; Example 311
   single: git_daemon_flags; Example 311
   single: git server; Example 311
   single: module community.general.pkgng; Example 311
   single: community.general.pkgng; Example 311

Use case
^^^^^^^^

Install ``git``. Use the role `vbotka.freebsd.postinstall`_ to
configure and start `git_daemon`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_05
  │   │   └── gitserver.yml
  │   └── iocage_06
  │       └── gitserver.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Install ``git``.

  * Use the role `vbotka.freebsd.postinstall`_ to configure and start
    `git_daemon`_.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.postinstall`_

Notes
^^^^^

* TBD.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.

.. seealso::

   * `Ansible role FreeBSD postinstall`_

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

.. literalinclude:: host_vars/iocage_05/gitserver.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/gitserver.yml
   :language: yaml+jinja
   :caption:

.. seealso::

   * Role `postinstall default variables`_

.. warning::

   The ``git://`` protocol does not provide encryption or authentication. While
   suitable for fast local prototyping or isolated provisioning networks, use
   ``https://`` (or SSH) in production environments.

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Configure git_daemon
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Display service status
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :language: console
   :force:
   :caption: [iocage_05]# service git_daemon status

.. literalinclude:: out/out-03.txt
   :language: console
   :force:
   :caption: [iocage_06]# service git_daemon status
