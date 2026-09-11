.. _example_523:

523 iocage template ansible-repos
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible-repos; Example 523
.. index:: single: role vbotka.freebsd.iocage_template; Example 523
.. index:: single: pb_iocage_project_create_from_templates; Example 523

.. index:: single: filter vbotka.freebsd.project; Example 523
.. index:: single: vbotka.freebsd.project; Example 523
.. index:: single: project; Example 523

.. index:: single: connection vbotka.freebsd.jailexec; Example 523
.. index:: single: vbotka.freebsd.jailexec; Example 523
.. index:: single: jailexec; Example 523

.. index:: single: inventory vbotka.freebsd.iocage2; Example 523

Use case
^^^^^^^^

Create a jail that serves Git repositories for `ansible-pull`_. Create
the `iocage`_ template ``ansible-repos`` and configure
`git-daemon`_. Create jails from the template and clone repositories
to the `base-path`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── project-hosts.yml
  │   │   ├── project.yml
  │   │   └── template.yml
  │   └── pull_repos
  │       └── repos.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── pb-repos.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* On a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the
    template ``ansible-repos``.

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_,
    create jails from the template.

* In the inventory group ``pull_repos``, clone the repositories that
  will be used by `ansible-pull`_.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.iocage_template`_.
* Playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_.
* `Filter vbotka.freebsd.project`_.
* `Inventory vbotka.freebsd.iocage2`_.
* :ref:`ug_connection_jailexec`.
* Package repository created in :ref:`example_322`.

.. note::

   * See :ref:`example_311`.

.. seealso::

   GitHub repositories:

   * `ansible-conf-init`_
   * `ansible-conf-syslogng-server`_
   * `ansible-conf-syslogng-client`_
   * `ansible-conf-test`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/pull_repos/repos.yml
   :language: yaml+jinja
   :caption:

.. note::

   The repositories are cloned from the local mirror at
   ``git_server``. To reproduce this example, create your mirror and
   adjust the IP address to your environment. See
   :ref:`example_311`. Optionally, for testing, clone the repositories
   directly from GitHub.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/template.yml
   :language: yaml+jinja
   :caption:

.. important::

   Running `git-daemon`_ with these specific flags sets up a public,
   unauthenticated Git server. This configuration is highly efficient
   for local mirroring, but it completely bypasses authentication and
   authorization. Ensure the daemon is strictly read-only (which is
   the default).

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-05.txt
   :language: sh

Playbook pb-repos.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-repos.yml
   :language: yaml+jinja

Playbook output - Clone repos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-repos.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

List repos
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage exec repos ls -la /usr/local/git

.. literalinclude:: out/out-07.txt
   :language: console
   :force:
