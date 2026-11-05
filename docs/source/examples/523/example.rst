.. _example_523:

523 iocage template ansible-repos
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: local repos; Example 523
   single: template ansible-repos; Example 523
   single: role vbotka.freebsd.iocage_template; Example 523
   single: pb_iocage_project_create_from_templates.yml; Example 523
   single: filter vbotka.freebsd.project; Example 523
   single: vbotka.freebsd.project; Example 523
   single: project; Example 523
   single: connection vbotka.freebsd.jailexec; Example 523
   single: vbotka.freebsd.jailexec; Example 523
   single: jailexec; Example 523
   single: inventory vbotka.freebsd.iocage2; Example 523

Use case
^^^^^^^^

Create jails that serve Git repositories for `ansible-pull`_. Create the
`iocage template`_ ``ansible-repos`` and configure `git-daemon`_. Create jails
from the template and clone repositories to the `base-path`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   └── project-hosts.yml
  │   ├── iocage
  │   │   ├── local-pkg-conf.yml
  │   │   ├── templates.yml
  │   │   └── template.yml
  │   └── pull_repos
  │       └── repos.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   ├── project.yml
  │   │   └── release.yml
  │   └── iocage_06
  │       ├── project.yml
  │       └── release.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── pb-repos.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* On the managed nodes:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the templates
    ``ansible-repos``.

  * In the playbook :ref:`ug_pb-iocage-project-create-from-templates`, create
    jails from the templates.

* In the inventory group ``pull_repos``, clone the repositories that will be
  used by `ansible-pull`_.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.iocage_template`_
* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_filter_to_ucl`
* :ref:`ug_filter_project`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Package repository created in the example :ref:`example_322`.

Notes
^^^^^

* See :ref:`example_311`.

.. note::

   | `vbotka.freebsd.iocage_template`_ is the role **iocage_template** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_iocage_template`_ is the role **freebsd_iocage_template** in the namespace `vbotka`_.

.. seealso::

   GitHub repositories:

   * `ansible-conf-init`_
   * `ansible-conf-roles`_
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

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/templates.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/template.yml
   :language: yaml+jinja
   :caption:

.. warning::

   Running `git-daemon`_ with these specific flags sets up a public,
   unauthenticated Git server. This configuration is highly efficient for local
   mirroring, but it completely bypasses authentication and
   authorization. Ensure the daemon is strictly read-only (which is the
   default).

.. literalinclude:: group_vars/pull_repos/repos.yml
   :language: yaml+jinja
   :caption:

.. note::

   The repositories are cloned from the local mirror at ``git_server``. To
   reproduce this example, create your mirror and adjust the IP address to your
   environment. See :ref:`example_311`. Optionally, for testing, clone the
   repositories directly from GitHub.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/project.yml
   :language: yaml+jinja
   :caption:

.. important::

   The names of the jails ``repos`` and ``repos-devel`` are identical in all
   jail managers. Therefore, the ``project`` dictionaries must be jail-manager-specific.

.. literalinclude:: host_vars/iocage_05/release.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/release.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Templates
^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -lt

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-05.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

.. important::

   The names of the jails ``repos`` and ``repos-devel`` are identical in all
   jail managers. The Ansible inventory is flat.

   See: :ref:`ug_qa_inventory_flat`

Jails
^^^^^

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-07.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-repos.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-repos.yml
   :language: yaml+jinja

Playbook output - Clone repos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:
   :caption: (env) > ansible-playbook -i hosts/05_iocage2.yml -i hosts/99_constructed.yml pb-repos.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:
   :caption: (env) > ansible-playbook -i hosts/06_iocage2.yml -i hosts/99_constructed.yml pb-repos.yml

.. important::

   The names of the jails ``repos`` and ``repos-devel`` are identical in all
   jail managers. Therefore, it is not possible to include them all in a single
   inventory group. As a result, the play must be run for each jail manager
   separately.

   See: :ref:`ug_qa_inventory_flat`

List repos
^^^^^^^^^^

.. literalinclude:: out/out-11.txt
   :language: console
   :force:
   :caption: [iocage_05]# iocage exec repos ls -la /usr/local/git

.. literalinclude:: out/out-12.txt
   :language: console
   :force:
   :caption: [iocage_06]# iocage exec repos ls -la /usr/local/git
