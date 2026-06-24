.. _example_524:

524 iocage template ansible-init
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 524
.. index:: single: service ansible_init; Example 524
.. index:: single: template ansible-init; Example 524
.. index:: single: firstboot; Example 524
.. index:: single: ansible-conf-init; Example 524
.. index:: single: ansible-conf-test; Example 524
.. index:: single: repo ansible-conf-init; Example 524
.. index:: single: repo ansible-conf-test; Example 524
.. index:: single: ansible-pull; Example 524
.. index:: single: role vbotka.freebsd.iocage_template; Example 524
.. index:: single: connection vbotka.freebsd.jailexec; Example 524
.. index:: single: inventory vbotka.freebsd.iocage; Example 524

Use case
^^^^^^^^

Create `iocage`_ template ``ansible-init``. Configure ``firstboot`` service ``ansible_init`` that
runs `ansible-pull`_ and uses the repo `ansible-conf-init`_. Configure the repo `ansible-conf-init`_
to pull the jails' configuration from the repo `ansible-conf-test`_. Create jails from the
template. Use the ``hostname`` to select the configuration. Run `ansible-pull`_ asynchronously.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── hello-world.txt
  │   ├── pkgs.json
  │   └── project-hosts.yml
  ├── group_vars
  │   └── all
  │       └── project.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── host_vars
  │   └── iocage_05
  │       └── template.yml
  ├── iocage.ini
  └── pb-iocage-template.yml

Synopsis
^^^^^^^^

* At a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the template ``ansible-init``

  * In the playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails from
    the template.

  * Wait for `ansible-pull`_ to configure the jails and display the test files.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_

.. note::

   * See `Practical rc.d scripting in BSD`_
   * See the option ``firstboot_sentinel`` in `man rc.conf`_
   * See the example :ref:`example_523`
   * See the ``Troubleshooting`` section in :ref:`example_526`

.. seealso::

   GitHub repositories:

   * `ansible-conf-init`_
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

.. literalinclude:: group_vars/all/project.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/template.yml
   :language: yaml
   :caption:

files
^^^^^

.. literalinclude:: files/hello-world.txt
   :language: text
   :caption:

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

.. literalinclude:: files/project-hosts.yml
   :language: yaml
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

Display the test files
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage exec foo "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-05.txt
   :language: sh

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage exec bar "cat /tmp/ansible-hello-world.txt"

.. literalinclude:: out/out-06.txt
   :language: sh


.. _Practical rc.d scripting in BSD: https://docs.freebsd.org/en/articles/rc-scripting/
.. _man rc.conf: https://man.freebsd.org/cgi/man.cgi?rc.conf

.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/

.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _git-daemon: https://man.freebsd.org/cgi/man.cgi?query=git-daemon
.. _base-path: https://git-scm.com/docs/git-daemon#Documentation/git-daemon.txt---base-pathpath
.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test
