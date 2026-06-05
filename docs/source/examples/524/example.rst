.. _example_524:

524 iocage template ansible_init
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_init; Example 524
.. index:: single: role vbotka.freebsd.iocage_template; Example 524
.. index:: single: connection vbotka.freebsd.jailexec; Example 524
.. index:: single: inventory vbotka.freebsd.iocage; Example 524

Use case
^^^^^^^^

Create `iocage`_ template ``ansible_init``. Configure ``firstboot`` service ``ansible-init`` that
runs ``ansible_pull`` and uses the repo ``ansible-conf-init``. Create jails from the template and
configure the repo ``ansible-conf-init`` to pull configuration for there jails from the repo
``ansible-conf-test``.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pkgs.json
  ├── group_vars
  │   └── ansible_repos
  │       └── repos.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── host_vars
  │   └── iocage_05
  │       ├── project.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  └── pb-repos.yml

Synopsis
^^^^^^^^

* At a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create template ``ansible_pull_repos``

  * In the playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails from
    the template.

* In the inventory group ``ansible_repos`` clone the repos that will be used by `ansible-pull`_.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_



.. note::

   TBD

.. seealso::

   TBD

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

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/project.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_05/template.yml
   :language: yaml
   :caption:

.. important::

   Running git daemon with these specific flags sets up a public, unauthenticated Git server. This
   configuration is highly efficient for local mirroring, but it completely bypasses authentication
   and authorization. Ensure the daemon is strictly read-only (which is the default).

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-template.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:
      
List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-04.txt
   :language: sh


.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/

.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _git-daemon: https://man.freebsd.org/cgi/man.cgi?query=git-daemon
.. _base-path: https://git-scm.com/docs/git-daemon#Documentation/git-daemon.txt---base-pathpath
.. _iocage: https://iocage.readthedocs.io/en/latest/
