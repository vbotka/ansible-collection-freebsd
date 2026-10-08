.. _example_527:

527 iocage template ansible-pkg-repo
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: pkg repo; Example 527
   single: template ansible-pkg-repo; Example 527
   single: role vbotka.freebsd.iocage_template; Example 527
   single: pb_iocage_project_create_from_templates.yml; Example 527
   single: filter vbotka.freebsd.project; Example 527
   single: vbotka.freebsd.project; Example 527
   single: project; Example 527
   single: filter vbotka.freebsd.to_ast; Example 527
   single: vbotka.freebsd.to_ast; Example 527
   single: to_ast; Example 527
   single: filter vbotka.freebsd.ast_to_nginx; Example 527
   single: vbotka.freebsd.ast_to_nginx; Example 527
   single: ast_to_nginx; Example 527
   single: connection vbotka.freebsd.jailexec; Example 527
   single: vbotka.freebsd.jailexec; Example 527
   single: jailexec; Example 527
   single: inventory vbotka.freebsd.iocage2; Example 527
   single: Nginx; Example 527

Use case
^^^^^^^^

Create a jail that serves a package repository for other jails. Create the
`iocage`_ template ``ansible-pkg-repo`` and configure a web server to publish
the repository. Create jails from the template and fetch packages into the
repository.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── local-pkg-conf.yml
  │   │   ├── nginx-pkg-repo.yml
  │   │   ├── project-hosts.yml
  │   │   ├── templates.yml
  │   │   └── template.yml
  │   └── fetch_pkg_repo
  │       └── pkg-repo.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   └── 06_iocage2.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   ├── project.yml
  │   │   └── release.yml
  │   └── iocage_06
  │       ├── project.yml
  │       └── release.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── pb-pkg-repo.yml
  └── templates
      ├── local.conf.j2
      └── nginx-pkg-repo.conf.j2

Synopsis
^^^^^^^^

* On a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the
    template ``ansible-pkg-repo``.

  * In the playbook
    :ref:`ug_pb-iocage-project-create-from-templates`,
    create jails from the template.

* In the inventory group ``fetch_pkg_repo``, fetch the selected
  packages into the repository.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.iocage_template`_
* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_filter_to_ast`
* :ref:`ug_filter_ast_to_nginx`
* :ref:`ug_filter_project`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Package repository created in :ref:`example_322`

.. note::

   | `vbotka.freebsd.iocage_template`_ is the role **iocage_template** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_iocage_template`_ is the role **freebsd_iocage_template** in the namespace `vbotka`_.

.. seealso::

   Example :ref:`example_322`

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

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/nginx-pkg-repo.yml
   :language: yaml+jinja
   :caption:

.. warning::

   This configuration is minimal and functional for an isolated lab or
   trusted internal LAN, but it poses several security risks in
   production or shared network environments.

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/templates.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/fetch_pkg_repo/pkg-repo.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/project.yml
   :language: yaml+jinja
   :caption:

.. important::

   The jail name ``pkg-repo`` is identical in all jail managers. Therefore, the
   ``project`` dictionaries must be jail-manager-specific.

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

.. literalinclude:: templates/nginx-pkg-repo.conf.j2
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
   :caption: shell> ssh admin@iocage_05 sudo iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: shell> ssh admin@iocage_06 sudo iocage list -lt

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts \
                           vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-05.txt
   :language: console

.. important::

   The name of the jail ``pkg-repo`` is identical in all jail managers. The
   Ansible inventory is flat.

   See: :ref:`ug_qa_inventory_flat`

Jails
^^^^^

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: shell> ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-07.txt
   :language: bash
   :caption: shell> ssh admin@iocage_06 sudo iocage list -l

Playbook pb-pkg-repo.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkg-repo.yml
   :language: yaml+jinja

Playbook output - Fetch packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:
   :caption: (env) > ansible-playbook -i hosts/05_iocage2.yml pb-pkg-repo.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:
   :caption: (env) > ansible-playbook -i hosts/06_iocage2.yml pb-pkg-repo.yml

.. important::

   The name of the jail ``pkg-repo`` is identical in all jail
   managers. Therefore, it is not possible to include them all in a single
   inventory group. As a result, the play must be run for each jail manager
   separately.

   See: :ref:`ug_qa_inventory_flat`

List repo
^^^^^^^^^

.. literalinclude:: out/out-10.txt
   :language: html
   :force:
   :caption: shell> ssh admin@iocage_05 fetch -qo - http://172.16.95.23/

.. literalinclude:: out/out-11.txt
   :language: html
   :force:
   :caption: shell> ssh admin@iocage_06 fetch -qo - http://172.16.99.23/