.. _example_526:

526 Log server and clients (ansible_init)
-----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_init; Example 526
.. index:: single: service ansible_init; Example 526
.. index:: single: template ansible-init; Example 526
.. index:: single: firstboot; Example 526
.. index:: single: ansible-conf-init; Example 526
.. index:: single: ansible-conf-syslogng-client; Example 526
.. index:: single: ansible-conf-syslogng-server; Example 526
.. index:: single: repo ansible-conf-init; Example 526
.. index:: single: repo ansible-conf-syslogng-client; Example 526
.. index:: single: repo ansible-conf-syslogng-server; Example 526
.. index:: single: ansible-pull; Example 526
.. index:: single: pb_iocage_project_create_from_templates.yml Example 526
.. index:: single: connection vbotka.freebsd.jailexec; Example 526
.. index:: single: inventory vbotka.freebsd.iocage; Example 526

.. index:: single: syslog-ng; Example 526
.. index:: single: loggen; Example 526
.. index:: single: log server; Example 526
.. index:: single: log client; Example 526

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible-init`` created in :ref:`example_524`. Configure the repository
`ansible-conf-init`_ to pull the jails' configuration from the repositories
`ansible-conf-syslogng-server`_ and `ansible-conf-syslogng-client`_. Create jails from the
template. Use ``class=log-server`` and ``class=log-client`` to select the configuration. Run
`ansible-pull`_ asynchronously.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   └── 06_iocage.yml
  ├── iocage.ini
  ├── pb-logclient-test.yml
  └── pb-logserver-test.yml

Synopsis
^^^^^^^^

* At a managed node:

  * In the playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails from
    the template. ``ansible-init``.

  * Wait for ``ansible-pull`` to configure the jails and display the logs.

Requirements
^^^^^^^^^^^^

* template ``ansible-init`` created in :ref:`example_524`
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_

.. note::

   * See `Practical rc.d scripting in BSD`_
   * See the option ``firstboot_sentinel`` in `man rc.conf`_
   * See the example :ref:`example_523`

.. seealso::

   GitHub repositories:

   * `ansible-conf-init`_
   * `ansible-conf-syslogng-server`_
   * `ansible-conf-syslogng-client`_

.. hint::

   Update the configuration repositories to your needs. Synchronize the dictionary ``project_hosts``
   in the files ``group_vars/all/project-hosts.yml`` in this example and in the repositories.

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

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml
   :caption:

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_templates.yml -i iocage.ini -i hosts

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
   
   (env) > ansible-playbook pb-logserver-test.yml -i hosts -e debug=true
   
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

   (env) > ansible-playbook pb-logclient-test.yml -i hosts

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

.. hint::

   Use the ``lnav`` utility on the log server to display all logfiles in the the directory
   ``/var/log/remote``. Run the following commands on the iocage host: ::

     shell > iocage console log-server
     root@log-server:~ # lnav -r /var/log/remote/

Troubleshooting
^^^^^^^^^^^^^^^

* See the Ansible logs ``/var/log/ansible.log``  in the jails.

.. code-block:: console

   shell > iocage console log-server
   root@log-server:~ # cat /var/log/ansible.log

* Update and pull the repositories. For example,

.. code-block:: console

   root@log-server:~ # cd /root/ansible-conf-init/
   root@log-server:~/ansible-conf-init # git pull
   Already up to date.
   root@log-server: # cd /root/ansible-conf-syslogng-server/
   root@log-server:~/ansible-conf-syslogng-server # git pull
   Already up to date.

* Start the service ``ansible_init``

.. code-block:: console

   root@log-server:~ # service ansible_init start
   Service ansible_init started.
   Starting Ansible Pull at 2026-06-26 04:43:37
   /usr/local/bin/ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-init -d /root/ansible-conf-init -e ai_vars=/root/ansible-vars -e ai_pull_mode=true pb-init.yml
   [WARNING]: Could not match supplied host pattern, ignoring: localhost.my.domain
   [WARNING]: Could not match supplied host pattern, ignoring: log-server

   ...
   TASK [Display vars.] ***********************************************************
   ok: [localhost.my.domain] => 
       msg: |-
           ai_at:
           ai_async: True
           ai_cmd:      ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-syslogng-server -d /root/ansible-conf-syslogng-server -e "ai_vars=/root/ansible-vars" -e "ai_pull_mode=true" pb-logserv.yml &&  echo '[INFO] ansible-pull finished.'

   TASK [Execute command async=3600 poll=0] ***************************************
   changed: [localhost.my.domain]

   PLAY RECAP *********************************************************************
   localhost.my.domain        : ok=8    changed=1    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

.. note::

   The command ``service ansible_init start`` removes the the sentinel file ``/firstboot``.

* See the Ansible log ``/var/log/ansible.log``. The warnings are harmless.

.. code-block:: console

   root@log-server:~ # cat /var/log/ansible.log
   ...
   2026-06-26 04:31:12,561 p=21489 u=root n=ansible INFO| Starting Ansible Pull at 2026-06-26 04:31:12
   2026-06-26 04:31:12,561 p=21489 u=root n=ansible INFO| /usr/local/bin/ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-syslogng-server -d /root/ansible-conf-syslogng-server -e ai_vars=/root/ansible-vars -e ai_pull_mode=true pb-logserv.yml
   2026-06-26 04:31:13,041 p=21491 u=root n=ansible WARNING| [WARNING]: Could not match supplied host pattern, ignoring: log-server
   ...
   2026-06-26 04:43:45,845 p=28341 u=root n=ansible INFO| PLAY [Configure and start Log Server.] *****************************************
   2026-06-26 04:43:45,880 p=28341 u=root n=ansible INFO| TASK [Include variables from ai_vars directory.] *******************************
   2026-06-26 04:43:45,880 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/project-hosts.yml)
   2026-06-26 04:43:45,922 p=28341 u=root n=ansible INFO| TASK [Display vars.] ***********************************************************
   2026-06-26 04:43:45,922 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain] => 
       msg: |-
           ai_pull_mode: true
           ai_vars: /root/ansible-vars

   2026-06-26 04:43:50,042 p=28341 u=root n=ansible INFO| TASK [Install packages.] *******************************************************
   2026-06-26 04:43:50,043 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-06-26 04:43:50,820 p=28341 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Rcconf: Configure syslogd_enable in /etc/rc.conf] ***
   2026-06-26 04:43:50,821 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-06-26 04:43:50,919 p=28341 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Syslog-ng: Sanity fp_syslogng_conf is empty.] ***
   2026-06-26 04:43:50,920 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-06-26 04:43:51,585 p=28341 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Syslog-ng: Configure /usr/local/etc/syslog-ng.conf] ***
   2026-06-26 04:43:51,586 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-06-26 04:43:51,955 p=28341 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Rcconf: Configure syslog_ng_enable in /etc/rc.conf] ***
   2026-06-26 04:43:51,955 p=28341 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-06-26 04:43:52,004 p=28341 u=root n=ansible INFO| PLAY RECAP *********************************************************************
   2026-06-26 04:43:52,004 p=28341 u=root n=ansible INFO| localhost.my.domain        : ok=7    changed=0    unreachable=0    failed=0    skipped=19   rescued=0    ignored=0


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
.. _ansible-conf-syslogng-server: https://github.com/vbotka/ansible-conf-syslogng-server
.. _ansible-conf-syslogng-client: https://github.com/vbotka/ansible-conf-syslogng-client
