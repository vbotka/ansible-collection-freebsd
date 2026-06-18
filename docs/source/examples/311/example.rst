.. _example_311:

311 Configure and start git_daemon
----------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: postinstall; Example 311
.. index:: single: vbotka.freebsd.postinstall; Example 311
.. index:: single: role vbotka.freebsd.postinstall; Example 311
.. index:: single: git_daemon; Example 311
.. index:: single: git server; Example 311

.. index:: single: module community.general.pkgng; Example 311
.. index:: single: community.general.pkgng; Example 311

Use case
^^^^^^^^

Install ``git``. Use the role `vbotka.freebsd.postinstall`_ to configure and start `git_daemon`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_05
  │       └── gitserver.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

* At the remote host install ``git``.
* Use the role `vbotka.freebsd.postinstall`_ to configure  and start `git_daemon`_

Requirements
^^^^^^^^^^^^

TBD

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * documentation `Ansible role FreeBSD postinstall`_

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
   :language: yaml
   :caption:

.. seealso::

   The `default variables`_ of the role `vbotka.freebsd.postinstall`_

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Configure and start git_daemon
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Display service status
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 service git_daemon status

.. literalinclude:: out/out-02.txt
   :language: console
   :force:


.. _git_daemon: https://git-scm.com/book/en/v2/Git-on-the-Server-Git-Daemon
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd

.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _default variables: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/guide-variables.html
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
