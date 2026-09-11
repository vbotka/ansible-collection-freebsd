.. _example_502:

502 branch-server
-----------------

(WIP)

.. contents::
   :local:
   :depth: 1

.. index:: single: branch-server; Example 502

.. index:: single: role vbotka.freebsd.config_light; Example 502
.. index:: single: vbotka.freebsd.config_light; Example 502
.. index:: single: config_light; Example 502

.. index:: single: log server; Example 502
.. index:: single: syslog-ng; Example 502

.. index:: single: git server; Example 502
.. index:: single: git_daemon; Example 502

Use case
^^^^^^^^

Install and configure ``syslog-ng`` and ``git`` servers on
``branch-server``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── conf-light
  │   ├── files.d
  │   │   └── git.yml
  │   ├── handlers.d
  │   │   └── git.yml
  │   ├── packages.d
  │   │   └── git.yml
  │   ├── services.d
  │   │   └── git.yml
  │   └── states.d
  │       └── git-dir.yml
  ├── hosts
  ├── host_vars
  │   └── branch-server.example.com
  │       ├── cl-common.yml
  │       ├── cl-git-daemon.yml
  │       ├── common.yml
  │       └── syslog-ng.yml
  ├── pb-config-light.yml
  ├── pb-git-repos.yml
  └── pb-log-server.yml

Synopsis
^^^^^^^^

* On the managed node ``branch-server.example.com``:

  * Install ``devel/git`` and configure the Git server.
  * Install ``sysutils/syslog-ng`` and configure the log server.
  * Create Git repositories.

Requirements
^^^^^^^^^^^^

Roles:

* `vbotka.freebsd.config_light`_
* `vbotka.freebsd.postinstall`_

Notes
^^^^^

* This Git server is configured to use the ``git`` protocol. See `Git
  on the Server - The protocols`_.

* In FreeBSD, the service, user, and group names are
  ``git_daemon``. See `Using GIT on FreeBSD`_.

.. seealso::

   * :ref:`example_340`
   * :ref:`example_500`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts
   :language: ini
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/branch-server.example.com/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/cl-common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/cl-git-daemon.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/syslog-ng.yml
   :language: yaml+jinja
   :caption:

Configuration conf-light
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: conf-light/files.d/git.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/handlers.d/git.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/packages.d/git.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/services.d/git.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/states.d/git-dir.yml
   :language: yaml+jinja
   :caption:

Update repos
^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_update_vmm_repos.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook pb-config-light.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-config-light.yml
   :language: yaml+jinja

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

Assemble data and create handlers.

.. code-block:: console

   (env) > ansible-playbook -t cl_setup -e cl_setup=true pb-config-light.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook output - Branch Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-config-light.yml

.. literalinclude:: out/out-10.txt
   :language: yaml+jinja
   :force:

Test service git_daemon
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [branch-server]# service git_daemon status

.. literalinclude:: out/out-11.txt
   :language: console

Playbook pb-log-server.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-log-server.yml
   :language: yaml+jinja

Playbook output - Log server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -e install=true pb-log-server.yml

.. literalinclude:: out/out-12.txt
   :language: yaml+jinja
   :force:

Test service syslog-ng
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [branch-server]# service syslog-ng status

.. literalinclude:: out/out-13.txt
   :language: console

Playbook pb-git-repos.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-git-repos.yml
   :language: yaml+jinja

Playbook output - Git repositories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -e install=true pb-git-repos.yml

.. literalinclude:: out/out-14.txt
   :language: yaml+jinja
   :force:
