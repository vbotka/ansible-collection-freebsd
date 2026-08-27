.. _example_528:

528 Log server and clients (ansible-conf-roles)
-----------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 528
.. index:: single: service ansible_init; Example 528
.. index:: single: template ansible-init; Example 528
.. index:: single: firstboot; Example 528
.. index:: single: ansible-conf-init; Example 528
.. index:: single: ansible-conf-roles; Example 528
.. index:: single: repo ansible-conf-init; Example 528
.. index:: single: repo ansible-conf-roles; Example 528
.. index:: single: ansible-pull; Example 528
.. index:: single: pb_iocage_project_create_from_templates.yml Example 528
.. index:: single: connection vbotka.freebsd.jailexec; Example 528
.. index:: single: inventory vbotka.freebsd.iocage2; Example 528

.. index:: single: ai_db_host; Example 528
.. index:: single: ai_db_class; Example 528
.. index:: single: ai_conf_roles; Example 528

.. index:: single: syslog-ng; Example 528
.. index:: single: loggen; Example 528
.. index:: single: log server; Example 528
.. index:: single: log client; Example 528

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible-init`` created in
:ref:`example_524`. Configure the repository `ansible-conf-init`_ to pull the
jails' configuration from the repository `ansible-conf-roles`_. Create jails
from the template. Put the configuration files for the class ``log-server`` and
``log-client`` into the jails' directories ``/root/ansible-vars``. Run
`ansible-pull`_ asynchronously.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── ai-conf-roles.yml
  │   ├── ai-db-class.yml
  │   ├── log-client
  │   │   ├── syslog-ng-client-pkg.yml
  │   │   └── syslog-ng-client.yml
  │   ├── log-server
  │   │   ├── syslog-ng-server-pkg.yml
  │   │   └── syslog-ng-server.yml
  │   └── pkg-repo.yml
  ├── group_vars
  │   └── all
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── iocage.ini
  ├── pb-logclient-test.yml
  ├── pb-logserver-test.yml
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* At a managed node:

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails
    from the template ``ansible-init``.

  * Configure the jails to use the ``pkg-repo`` created in :ref:`example_527`.

  * Wait for ``ansible-pull`` to configure the jails and display the logs.

Requirements
^^^^^^^^^^^^

* template ``ansible-init`` created in :ref:`example_524`
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage2`_
* :ref:`ug_connection_jailexec`

.. note::

   Neither the inventory nor the connection plugin is required to create the
   project. The inventory plugin is used to list the jails and create groups for
   the test playbooks. The configuration also serves as an example of the
   connection plugin.

.. seealso::


   * `Practical rc.d scripting in BSD`_
   * The option ``firstboot_sentinel`` in `man rc.conf`_
   * The examples:

     - :ref:`example_523`
     - :ref:`example_527`

   * The ``Troubleshooting`` section in :ref:`example_526`
   * GitHub repositories:

     - `ansible-conf-init`_
     - `ansible-conf-roles`_

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
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/project-hosts.yml.j2
   :language: jinja
   :caption:

files
^^^^^

.. literalinclude:: files/ai-db-class.yml
   :language: yaml
   :caption:

.. note::

   The playbook ``pb-init.yml`` (from the `ansible-conf-init`_ repository) reads
   this file from ``/root/ansible-vars`` using the
   `ansible.builtin.include_vars`_ module (precedence 18.). The ``ai_db_class``
   dictionary overrides the values defined in the repository's
   ``host_vars``. See `Understanding variable precedence`_.

.. literalinclude:: files/ai-conf-roles.yml
   :language: yaml
   :caption:

.. note::

   The playbook ``pb-roles.yml`` (from the `ansible-conf-roles`_ repository)
   reads this file from ``/root/ansible-vars``. The repository does not provide
   a default ``ai_conf_roles`` dictionary.


.. literalinclude:: files/pkg-repo.yml
   :language: yaml
   :caption:

.. note::

   To install packages, the jails use the ``pkg-repo`` created in :ref:`example_527`.

.. important::

   This configuration is minimal and functional for an isolated lab or trusted
   internal LAN, but it poses several security risks in production or shared
   network environments.

.. literalinclude:: files/log-client/syslog-ng-client-pkg.yml
   :language: yaml
   :caption:

.. literalinclude:: files/log-client/syslog-ng-client.yml
   :language: yaml
   :caption:

.. literalinclude:: files/log-server/syslog-ng-server-pkg.yml
   :language: yaml
   :caption:

.. literalinclude:: files/log-server/syslog-ng-server.yml
   :language: yaml
   :caption:

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Inventory graph
^^^^^^^^^^^^^^^
.. code-block:: console

   shell > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-05.txt
   :language: sh

Playbook pb-logserver-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: pb-logserver-test.yml
   :language: yaml+jinja

Playbook output - Test Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console
   
   (env) > ansible-playbook -i hosts -e debug=true pb-logserver-test.yml
   
.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook pb-logclient-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient-test.yml
   :language: yaml+jinja

Playbook output - Test Log Clients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-logclient-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

.. hint::

   Use the ``lnav`` utility on the log server to display all logfiles in the the directory
   ``/var/log/remote``. Run the following commands on the iocage host: ::

     shell > iocage console log-server
     root@log-server:~ # lnav -r /var/log/remote/


.. _Practical rc.d scripting in BSD: https://docs.freebsd.org/en/articles/rc-scripting/
.. _man rc.conf: https://man.freebsd.org/cgi/man.cgi?rc.conf

.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/

.. _ansible-pull: https://docs.ansible.com/projects/ansible/latest/cli/ansible-pull.html
.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-roles: https://github.com/vbotka/ansible-conf-roles

.. _Understanding variable precedence: https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence
.. _ansible.builtin.include_vars: https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/include_vars_module.html#ansible-builtin-include-vars-module-load-variables-from-files-dynamically-within-a-task
