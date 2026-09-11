.. _ug_concepts_iocage_class:

iocage classes
--------------

.. index:: single: variable iocage_classes; iocage classes
.. index:: single: iocage_classes; iocage classes
.. index:: single: iocage tag class; iocage classes
.. index:: single: class; iocage classes
.. index:: single: custom facts; iocage classes

.. contents::
   :local:
   :depth: 2

List iocage_classes
^^^^^^^^^^^^^^^^^^^

The variable ``iocage_classes`` is a list of jail classes ``composed``
by an inventory plugin from the iocage ``class`` tag. For example,
given the following project definition:

.. code-block:: yaml+jinja

   project:
     log-server-01:
       notes: alias=log_server_01
       vmm: iocage_06
       class: [log-server]
       ...

a task sets the jail properties and creates the ``notes`` field:

.. code-block:: yaml+jinja

   - name: "Properties: Set properties."
     vars:
       _notes: >-
         "vmm={{ inventory_hostname }}
         class={{ vmm[inventory_hostname][item]['class'] | d([]) | join(',') }}
         {{ vmm[inventory_hostname][item]['notes'] | d('') }}"
       _properties_combined: |
         {{ [vmm[inventory_hostname][item]['properties'] | d({}), properties | d({})]
            | select
            | combine(recursive=true) }}
       _properties: >-
         {% for k, v in _properties_combined.items() %}
         {{ k }}={{ v }}
         {% endfor %}
         notes={{ _notes }}
     ansible.builtin.command: >
       iocage set
       {{ _properties }}
       {{ item }}
     loop: "{{ vmm[inventory_hostname].keys() }}"

The ``class`` property inside ``notes`` is stored as a comma-separated
string:

.. code-block:: console

   # iocage get notes log-server-01
   vmm=iocage_06 class=log-server alias=log_server_01


Inventory groups
^^^^^^^^^^^^^^^^

These ``notes`` can be used to populate ``iocage_classes`` and
construct inventory groups (for example, the ``log_servers`` inventory
group):

.. code-block:: yaml+jinja

   get_properties: true
   inventory_hostname_tag: alias

   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
     iocage_classes: iocage_properties.notes | regex_findall('(?<=class=)[\w\-]+|(?<=,)[\w\-]+')

   groups:
     log_servers: iocage_classes is contains('log-server')

Custom facts
^^^^^^^^^^^^

The list of classes can also be stored in local custom facts:

.. code-block:: console

   # iocage exec log-server-01 cat /usr/local/etc/ansible/facts.d/iocage.fact
   #!/bin/sh
   cat << EOF
   {
       "class": [
           "log-server"
       ]
   }
   EOF

These facts are then consumed by the FreeBSD `ansible_init`_ service
to configure the jail:

.. code-block:: yaml+jinja

   # /root/ansible-conf-init/pb-init.yml
   - name: ansible-init
     hosts: localhost.my.domain

     vars:
       ai_class: "{{ ansible_local.iocage.class | d([]) | intersect(ai_db_class) }}"

     tasks:
       - name: Get custom facts.
         ansible.builtin.setup:
           filter: ansible_local

       ...

.. code-block:: yaml+jinja

   # /root/ansible-vars/ai-db-class.yml
   ai_db_class:
     log-server:
       repo_host: "git://{{ project_hosts.repos }}"
       repo: ansible-conf-roles
       repo_dest: /root
       repo_playbook: pb-roles.yml
     ...

.. code-block:: console

   root@log-server-01:~ # cat /var/log/ansible.log

   2026-08-23 09:21:37,707 p=97508 u=root n=ansible INFO| PLAY [ansible-init] ************************************************************
   2026-08-23 09:21:38,304 p=97508 u=root n=ansible INFO| TASK [Get hostname.] ***********************************************************
   2026-08-23 09:21:38,304 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-08-23 09:21:40,376 p=97508 u=root n=ansible INFO| TASK [Get custom facts.] *******************************************************
   2026-08-23 09:21:40,377 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain]
   2026-08-23 09:21:40,418 p=97508 u=root n=ansible INFO| TASK [Include variables from ai_vars directory.] *******************************
   2026-08-23 09:21:40,418 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/project-hosts.yml)
   2026-08-23 09:21:40,425 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/syslog-ng-server-pkg.yml)
   2026-08-23 09:21:40,434 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/ai-db-class.yml)
   2026-08-23 09:21:40,446 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/syslog-ng-server.yml)
   2026-08-23 09:21:40,454 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/ai-conf-roles.yml)
   2026-08-23 09:21:40,463 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => (item=/root/ansible-vars/pkg-repo.yml)

   2026-08-23 09:21:40,532 p=97508 u=root n=ansible INFO| TASK [Display vars.] ***********************************************************
   2026-08-23 09:21:40,533 p=97508 u=root n=ansible INFO| ok: [localhost.my.domain] => 
       msg: |-
           ai_pull_mode: true
           ai_vars: /root/ansible-vars
           ai_hostname: log-server-01
           ai_class: ['log-server']
           project_hosts: {'defaultrouter': '172.16.99.1', 'log_server': '172.16.99.10', 'repos': '172.16.99.21', 'repos_devel': '172.16.99.22', 'pkg_repo': '172.16.99.23'}

Class variables
^^^^^^^^^^^^^^^

Classes can also be used to organize configuration files. For example,
separating configurations for ``log-client`` and ``log-server``:

.. code-block:: text

   ├── ansible.cfg
   ├── files
   │   ├── ai-conf-roles.yml
   │   ├── ai-db-class.yml
   │   ├── log-client
   │   │   ├── syslog-ng-client-pkg.yml
   │   │   └── syslog-ng-client.yml
   │   ├── log-server
   │   │   ├── syslog-ng-server-pkg.yml
   │   │   └── syslog-ng-server.yml
   │   └── pkg-repo.yml
   ├── group_vars
   │   └── all
   │       ├── project-hosts.yml
   │       └── project.yml
   └── templates
       └── project-hosts.yml.j2

These configuration files are automatically copied to ``ai_vars`` when
a project is created:

.. code-block:: console

   root@log-server-01:~ # ls -la /root/ansible-vars/
   total 9
   drwxr-x---  2 root wheel    8 Aug 23 05:55 .
   drwxr-x---  6 root wheel   12 Aug 23 11:20 ..
   -rw-r-----  1 root wheel  113 Aug 23 09:20 ai-conf-roles.yml
   -rw-r-----  1 root wheel  303 Aug 23 09:20 ai-db-class.yml
   -rw-r-----  1 root wheel  229 Aug 23 09:20 pkg-repo.yml
   -rw-r-----  1 root wheel  164 Aug 23 09:21 project-hosts.yml
   -rw-r-----  1 root wheel   72 Aug 19 11:03 syslog-ng-server-pkg.yml
   -rw-r-----  1 root wheel 1088 Aug 18 14:33 syslog-ng-server.yml
