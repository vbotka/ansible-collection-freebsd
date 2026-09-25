.. _example_311:

311 Configure and start git_daemon
----------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: postinstall; Example 311
.. index:: single: vbotka.freebsd.postinstall; Example 311
.. index:: single: role vbotka.freebsd.postinstall; Example 311
.. index:: single: git daemon; Example 311
.. index:: single: git_daemon_flags; Example 311
.. index:: single: git server; Example 311

.. index:: single: module community.general.pkgng; Example 311
.. index:: single: community.general.pkgng; Example 311

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
  │   └── iocage_06
  │       └── gitserver.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

* On the remote host, install ``git``.

* Use the role `vbotka.freebsd.postinstall`_ to configure and start
  `git_daemon`_.

Requirements
^^^^^^^^^^^^

* TBD

Notes
^^^^^

* TBD

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

.. literalinclude:: host_vars/iocage_06/gitserver.yml
   :language: yaml+jinja
   :caption:

.. warning::

   The ``git://`` protocol does not provide encryption or
   authentication. While suitable for fast local prototyping or
   isolated provisioning networks, use ``https://`` (or SSH) for
   :ref:`ug_concepts_ansible_init` in production environments.

.. seealso::

   The `default variables`_ of the role `vbotka.freebsd.postinstall`_

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

.. code-block:: console

   shell> ssh admin@iocage_06 service git_daemon status

.. literalinclude:: out/out-02.txt
   :language: console
   :force:
