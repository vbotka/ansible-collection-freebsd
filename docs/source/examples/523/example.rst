.. _example_523:

523 iocage template ansible_repos
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_repos; Example 523
.. index:: single: role vbotka.freebsd.iocage_template; Example 523
.. index:: single: connection vbotka.freebsd.jailexec; Example 523
.. index:: single: inventory vbotka.freebsd.iocage; Example 523

Use case
^^^^^^^^

Create a jail that provides git repos for `ansible-pull`_. Create `iocage`_ template
``ansible_repos`` and configure `git-daemon`_. Create jails from the template and clone repos to the
`base-path`_.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pkgs.json
  ├── group_vars
  │   └── pull_repos
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

  * Use the role `vbotka.freebsd.iocage_template`_ to create template ``ansible_repos``

  * In the playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails from
    the template.

* In the inventory group ``pull_repos`` clone the repos that will be used by `ansible-pull`_.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_


.. note::

   * See the example :ref:`example_311`

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

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/pull_repos/repos.yml
   :language: yaml+jinja
   :caption:

.. note::

   The repos are cloned from the local mirror at ``git_server``. To reproduce this example, create
   your mirror and fit the IP to your needs. See :ref:`example_311`. Optionally, for testing, clone
   the repos from GitHub.

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

files
^^^^^

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

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

Playbook pb-repos.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-repos.yml
   :language: yaml+jinja

Playbook output - Clone repos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-repos.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

List repos
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage exec repos ls -la /usr/local/git

.. literalinclude:: out/out-06.txt
   :language: console
   :force:


.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/

.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _git-daemon: https://man.freebsd.org/cgi/man.cgi?query=git-daemon
.. _base-path: https://git-scm.com/docs/git-daemon#Documentation/git-daemon.txt---base-pathpath
.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-syslogng-server: https://github.com/vbotka/ansible-conf-syslogng-server
.. _ansible-conf-syslogng-client: https://github.com/vbotka/ansible-conf-syslogng-client
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test
