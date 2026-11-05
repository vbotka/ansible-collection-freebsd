.. _example_526:

526 Log server and clients (ansible_init)
-----------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: ansible_init; Example 526
   single: ansible_init troubleshooting; Example 526
   single: service ansible_init; Example 526
   single: template ansible-init; Example 526
   single: firstboot; Example 526
   single: ansible-conf-init; Example 526
   single: ansible-conf-syslogng-client; Example 526
   single: ansible-conf-syslogng-server; Example 526
   single: repo ansible-conf-init; Example 526
   single: repo ansible-conf-syslogng-client; Example 526
   single: repo ansible-conf-syslogng-server; Example 526
   single: ansible-pull; Example 526
   single: pb_iocage_project_create_from_templates.yml; Example 526
   single: filter vbotka.freebsd.project; Example 526
   single: vbotka.freebsd.project; Example 526
   single: project; Example 526
   single: connection vbotka.freebsd.jailexec; Example 526
   single: vbotka.freebsd.jailexec; Example 526
   single: jailexec; Example 526
   single: inventory vbotka.freebsd.iocage2; Example 526
   single: syslog-ng; Example 526
   single: loggen; Example 526
   single: log server; Example 526
   single: log client; Example 526
   single: ansible_init.sh; Example 526
   single: ansible_init_enable; Example 526
   single: ansible_init_host; Example 526
   single: ansible_init_repo; Example 526
   single: ansible_init_playbook; Example 526

Use case
^^^^^^^^

Use the `iocage template`_ ``ansible-init`` created in :ref:`example_524` or
:ref:`example_529`. Configure the repository `ansible-conf-init`_ to pull the
jails' configuration from the repositories `ansible-conf-syslogng-server`_ and
`ansible-conf-syslogng-client`_. Create jails from the template using the playbook
:ref:`ug_pb-iocage-project-create-from-templates`. In the project host definitions,
select the configuration via ``class=log-server`` and ``class=log-client``. Run
`ansible-pull`_ asynchronously via the `firstboot`_ service `ansible_init`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── iocage
  │       ├── project-hosts.yml
  │       └── project.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-logclient-test.yml
  ├── pb-logserver-test.yml
  └── templates
      └── project-hosts.yml.j2

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-project-create-from-templates`, create
    jails from the template ``ansible-init``.

  * Wait for `ansible-pull`_ to configure the jails and display the logs.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_filter_project`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Jail ``repos`` created in the example :ref:`example_523`.
* Template ``ansible-init`` created in:

  * Example :ref:`example_529`, or
  * Example :ref:`example_524`.

.. note::

   * See `Practical rc.d scripting in BSD`_.
   * See the option ``firstboot_sentinel`` in `man rc.conf`_.

.. note::

   | `vbotka.freebsd.iocage_template`_ is the role **iocage_template** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_iocage_template`_ is the role **freebsd_iocage_template** in the namespace `vbotka`_.
   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.

.. seealso::

   * GitHub repositories:

     * `ansible-conf-init`_
     * `ansible-conf-syslogng-server`_
     * `ansible-conf-syslogng-client`_

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

.. literalinclude:: group_vars/iocage/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/iocage/project.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/project-hosts.yml.j2
   :language: jinja
   :caption:

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-logserver-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserver-test.yml
   :language: yaml+jinja

Playbook output - Test Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-logserver-test.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-logclient-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient-test.yml
   :language: yaml+jinja

Playbook output - Test Log Clients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-logclient-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

.. hint::

   Use the ``lnav`` utility on the log server to display all log files in the
   ``/var/log/remote`` directory. Run the following commands on the iocage host::

     shell> iocage console log-server-01
     root@log-server-01:~ # lnav -r /var/log/remote/

Troubleshooting
^^^^^^^^^^^^^^^

* Inspect the Ansible log ``/var/log/ansible.log`` in the jails:

  .. code-block:: console

     shell> iocage console log-server-01
     root@log-server-01:~ # cat /var/log/ansible.log

* Update and pull the repositories. For example:

  .. code-block:: console

     root@log-server-01:~ # cd /root/ansible-conf-init/
     root@log-server-01:~/ansible-conf-init # git pull
     Already up to date.
     root@log-server-01:~ # cd /root/ansible-conf-syslogng-server/
     root@log-server-01:~/ansible-conf-syslogng-server # git pull
     Already up to date.

* Start the service `ansible_init`_:

  .. code-block:: console

     root@log-server-01:~ # service ansible_init start
     Service ansible_init started.
     Starting Ansible Pull at 2026-06-26 04:43:37
     /usr/local/bin/ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-init -d /root/ansible-conf-init -e ai_vars=/root/ansible-vars -e ai_pull_mode=true pb-init.yml
     [WARNING]: Could not match supplied host pattern, ignoring: localhost.my.domain
     [WARNING]: Could not match supplied host pattern, ignoring: log-server-01

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

     The command ``service ansible_init start`` removes the sentinel file ``/firstboot``.

* Review the Ansible log ``/var/log/ansible.log``. The warnings are harmless:

  .. code-block:: console

     root@log-server:~ # cat /var/log/ansible.log
     ...
     2026-08-31 08:10:36,572 p=39114 u=root n=ansible WARNING| [WARNING]: Could not match supplied host pattern, ignoring: log-server-01

     2026-08-31 08:10:36,688 p=39114 u=root n=ansible INFO| PLAY [ansible-init] ************************************************************
     2026-08-31 08:10:37,731 p=39114 u=root n=ansible INFO| TASK [Get hostname.] ***********************************************************
     2026-08-31 08:10:37,731 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:10:40,361 p=39114 u=root n=ansible INFO| TASK [Get custom facts.] *******************************************************
     2026-08-31 08:10:40,362 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:10:40,439 p=39114 u=root n=ansible INFO| TASK [Include variables from ai_vars directory.] *******************************
     2026-08-31 08:10:40,441 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/project-hosts.yml)
     2026-08-31 08:10:40,516 p=39114 u=root n=ansible INFO| TASK [Display vars.] ***********************************************************
     2026-08-31 08:10:40,517 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain] => 
         msg: |-
             ai_pull_mode: true
             ai_vars: /root/ansible-vars
             ai_hostname: log-server-01
             ai_class: ['log-server']
             project_hosts: {'defaultrouter': '172.16.99.1', 'log_server': '172.16.99.10', 'repos': '172.16.99.21', 'repos_devel': '172.16.99.22', 'ansible_pull_syslogng_server': '172.16.99.31'}

     2026-08-31 08:10:40,705 p=39114 u=root n=ansible INFO| TASK [Set ai_cmd] **************************************************************
     2026-08-31 08:10:40,706 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:10:40,732 p=39114 u=root n=ansible INFO| TASK [Execute ai_cmd] **********************************************************
     2026-08-31 08:10:40,745 p=39114 u=root n=ansible INFO| included: /root/ansible-conf-init/tasks/execute-cmd.yml for localhost.my.domain
     2026-08-31 08:10:40,778 p=39114 u=root n=ansible INFO| TASK [Display vars.] ***********************************************************
     2026-08-31 08:10:40,779 p=39114 u=root n=ansible INFO| ok: [localhost.my.domain] => 
         msg: |-
             ai_at:
             ai_async: True
             ai_cmd:      ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-syslogng-server -d /root/ansible-conf-syslogng-server -e "ai_vars=/root/ansible-vars" -e "ai_pull_mode=true" pb-logserv.yml &&  echo '[INFO] ansible-pull finished.'

     2026-08-31 08:10:41,390 p=39114 u=root n=ansible INFO| TASK [Execute command async=3600 poll=0] ***************************************
     2026-08-31 08:10:41,390 p=39114 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:10:41,405 p=39114 u=root n=ansible INFO| PLAY RECAP *********************************************************************
     2026-08-31 08:10:41,405 p=39114 u=root n=ansible INFO| localhost.my.domain        : ok=8    changed=1    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
     2026-08-31 08:10:42,470 p=39178 u=root n=ansible INFO| Starting Ansible Pull at 2026-08-31 08:10:42
     2026-08-31 08:10:42,470 p=39178 u=root n=ansible INFO| /usr/local/bin/ansible-pull -i hosts -U git://172.16.99.21/ansible-conf-syslogng-server -d /root/ansible-conf-syslogng-server -e ai_vars=/root/ansible-vars -e ai_pull_mode=true pb-logserv.yml
     2026-08-31 08:10:43,308 p=39180 u=root n=ansible WARNING| [WARNING]: Could not match supplied host pattern, ignoring: log-server-01

     2026-08-31 08:10:44,587 p=39180 u=root n=ansible INFO| localhost.my.domain | CHANGED => {
         "after": "95c7328f7be5a7af78b9525480924c072dc60642",
         "ansible_facts": {
             "discovered_interpreter_python": "/usr/local/bin/python3.12"
         },
         "before": null,
         "changed": true
     }
     2026-08-31 08:10:46,540 p=40141 u=root n=ansible WARNING| [WARNING]: Could not match supplied host pattern, ignoring: log-server-01

     2026-08-31 08:10:47,558 p=40141 u=root n=ansible INFO| PLAY [Configure and start Log Server.] *****************************************
     2026-08-31 08:10:47,620 p=40141 u=root n=ansible INFO| TASK [Include variables from ai_vars directory.] *******************************
     2026-08-31 08:10:47,620 p=40141 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/project-hosts.yml)
     2026-08-31 08:10:47,694 p=40141 u=root n=ansible INFO| TASK [Display vars.] ***********************************************************
     2026-08-31 08:10:47,695 p=40141 u=root n=ansible INFO| ok: [localhost.my.domain] => 
         msg: |-
             ai_pull_mode: true
             ai_vars: /root/ansible-vars

     2026-08-31 08:11:14,348 p=40141 u=root n=ansible INFO| TASK [Install packages.] *******************************************************
     2026-08-31 08:11:14,349 p=40141 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:11:15,801 p=40141 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Rcconf: Configure syslogd_enable in /etc/rc.conf] ***
     2026-08-31 08:11:15,802 p=40141 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:11:16,011 p=40141 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Syslog-ng: Sanity fp_syslogng_conf is empty.] ***
     2026-08-31 08:11:16,011 p=40141 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:11:18,529 p=40141 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Syslog-ng: Configure /usr/local/etc/syslog-ng.conf] ***
     2026-08-31 08:11:18,529 p=40141 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:11:19,315 p=40141 u=root n=ansible INFO| TASK [vbotka.freebsd.postinstall : Rcconf: Configure syslog_ng_enable in /etc/rc.conf] ***
     2026-08-31 08:11:19,315 p=40141 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:11:20,713 p=40141 u=root n=ansible INFO| RUNNING HANDLER [vbotka.freebsd.postinstall : Start syslog-ng] *****************
     2026-08-31 08:11:20,714 p=40141 u=root n=ansible INFO| changed: [localhost.my.domain]
     2026-08-31 08:11:21,719 p=40141 u=root n=ansible INFO| RUNNING HANDLER [vbotka.freebsd.postinstall : Reload syslog-ng] ****************
     2026-08-31 08:11:21,720 p=40141 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:11:22,788 p=40141 u=root n=ansible INFO| RUNNING HANDLER [vbotka.freebsd.postinstall : Stop syslogd] ********************
     2026-08-31 08:11:22,789 p=40141 u=root n=ansible INFO| ok: [localhost.my.domain]
     2026-08-31 08:11:22,792 p=40141 u=root n=ansible INFO| PLAY RECAP *********************************************************************
     2026-08-31 08:11:22,792 p=40141 u=root n=ansible INFO| localhost.my.domain        : ok=10   changed=5    unreachable=0    failed=0    skipped=19   rescued=0    ignored=0
