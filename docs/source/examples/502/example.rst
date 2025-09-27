.. _example_502:

502 branch-server
-----------------

.. contents::
   :local:
   :depth: 1

.. index:: single: branch-server; Example 502

.. index:: single: log server; Example 502
.. index:: single: syslog-ng; Example 502

.. index:: single: git server; Example 502
.. index:: single: git_daemon; Example 502


Use case
^^^^^^^^

Install and configure ``syslog-ng`` and ``git`` servers in the ``branch-server``.

Tree
^^^^

::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── conf-light
  │   ├── files.d
  │   ├── handlers.d
  │   ├── packages.d
  │   │   └── git.yml
  │   ├── services.d
  │   │   └── git.yml
  │   └── states.d
  │       └── git-dir.yml
  ├── hosts
  ├── host_vars
  │   └── branch-server.example.com
  │       ├── cl-common.yml
  │       ├── cl-git-daemon.yml
  │       ├── common.yml
  │       └── syslog-ng.yml
  ├── pb-config-light.yml
  └── pb-logserv.yml

Synopsis
^^^^^^^^

* At the managed node ``branch-server.example.com``:

  * install ``devel/git`` and configure ``git server``
  * install ``sysutils/syslog-ng`` and configure ``log server``.

Requirements
^^^^^^^^^^^^

roles:

* `vbotka.freebsd.config_light`_
* `vbotka.freebsd.postinstall`_

Notes
^^^^^

TBD

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

.. literalinclude:: host_vars/branch-server.example.com/cl-common.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/cl-git-daemon.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/common.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/branch-server.example.com/syslog-ng.yml
   :language: yaml
   :caption:

Update repos
^^^^^^^^^^^^

.. code-block:: console

   ansible-playbook vbotka.freebsd.pb_iocage_update_vmm_repos.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Configuration conf-light
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: conf-light/packages.d/git.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/services.d/git.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/states.d/git-dir.yml
   :language: yaml
   :caption:

Playbook pb-config-light.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-config-light.yml
   :language: yaml+jinja

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

Assemble data and create handlers.

.. code-block:: console

   (env) > ansible-playbook pb-config-light.yml -t cl_setup -e cl_setup=true

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - Branch Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-config-light.yml

.. literalinclude:: out/out-10.txt
   :language: yaml
   :force:

Playbook pb-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml+jinja

Playbook output - Log server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logserv.yml -e install=true

.. literalinclude:: out/out-11.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
