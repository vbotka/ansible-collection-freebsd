.. _example_523:

523 iocage template ansible_pull_repos
--------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_pull_repos; Example 523
.. index:: single: role vbotka.freebsd.iocage_template; Example 523
.. index:: single: connection vbotka.freebsd.jailexec; Example 523
.. index:: single: inventory vbotka.freebsd.iocage; Example 523

Use case
^^^^^^^^

Create ``iocage`` template ``ansible_pull_repos`` and configure `git-daemon`_. Create jails from the
template and clone repos to the ``base-path``.

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

  * In the playbook ``vbotka.freebsd.pb_iocage_project_create_from_templates.yml`` create jails from
    the template.

* In the inventory group ``ansible_repos`` clone the repos that will be used by ``ansible-pull``.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_
* role `vbotka.freebsd.iocage_template`_

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

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/ansible_repos/repos.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/project.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_05/template.yml
   :language: yaml
   :caption:

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


.. _git-daemon: https://man.freebsd.org/cgi/man.cgi?query=git-daemon
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/
.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
