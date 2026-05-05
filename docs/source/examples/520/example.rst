.. _example_520:

520 Iocage plugin ansible-syslogng
----------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: project; Example 520
.. index:: single: project create from plugins; Example 520

.. index:: single: playbook pb_iocage_plugins.yml; Example 520
.. index:: single: playbook pb_iocage_project_create_from_plugins.yml; Example 520
.. index:: single: connection vbotka.freebsd.jailexec; Example 520
.. index:: single: inventory vbotka.freebsd.iocage; Example 520

.. index:: single: syslog-ng; Example 520
.. index:: single: syslogd; Example 520
.. index:: single: loggen; Example 520
.. index:: single: log server; Example 520
.. index:: single: log client; Example 520

.. index:: single: module vbotka.freebsd.service; Example 520
.. index:: single: vbotka.freebsd.service; Example 520

.. index:: single: iocage plugins; Example 520
.. index:: single: iocage plugin ansible-syslogng; Example 520

.. index:: single: ansible_jail_host; Example 520
.. index:: single: ansible_jail_name; Example 520
.. index:: single: ansible_jail_privilege_escalation; Example 520

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test them. Use `syslog-ng`_. Clone the
iocage plugin ``ansible-syslogng``. The ``project`` keys are jail's aliases.

.. code-block:: yaml

   project:
     logserv:
       class: [logserv]
       plugin: ansible-syslogng
       vmm: iocage_05
     foo:
       class: [logclient]
       plugin: ansible-syslogng
       vmm: iocage_05
     bar:
       class: [logclient]
       plugin: ansible-syslogng
       vmm: iocage_05

* Destroy all jails

  .. code-block:: console

     (env) > ansible-playbook vbotka.freebsd.pb_iocage_destroy_all_jails.yml \
                              -i iocage.ini \
			      --flush-cache

* Fetch the required iocage plugins

  .. code-block:: console

     (env) > ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml \
                              -i iocage.ini \
			      -t project_plugins \
			      --flush-cache

* Create the project

  .. code-block:: console

     (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_plugins.yml \
                              -i iocage.ini \
			      -i hosts \
			      --flush-cache

* Create log server

  .. code-block:: console

     (env) > ansible-playbook pb-logserv.yml -i hosts

* Create log clients			      

  .. code-block:: console

     (env) > ansible-playbook pb-logclient.yml -i hosts -i iocage.ini

* Test

  .. code-block:: console

     (env) > ansible-playbook pb-test-logclient.yml -i hosts

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── common.yml
  │   │   └── project.yml
  │   ├── logclient_group
  │   │   └── syslog-ng.yml
  │   └── logserv_group
  │       └── syslog-ng.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── host_vars
  │   └── iocage_05
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-all-groups.yml
  ├── pb-logclient.yml
  ├── pb-logserv.yml
  ├── pb-test-logclient.yml
  └── pb-test-logserv.yml

Synopsis
^^^^^^^^

* At a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_plugins.yml`_:

  * Fetch the iocage plugin ``ansible-syslogng``

  In the playbook `vbotka.freebsd.pb_iocage_project_create_from_plugins.yml`_:

  * Clone jails from the iocage plugin ``ansible-syslogng``

* In the inventory group ``logserv_group`` configure `syslog-ng Server`_.

* In the inventory group ``logclient_group`` configure `syslog-ng Client`_.

Requirements
^^^^^^^^^^^^

* iocage plugin ``ansible-syslogng``
* playbook `vbotka.freebsd.pb_iocage_plugins.yml`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_plugins.yml`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_
* `module vbotka.freebsd.service`_
* role `vbotka.freebsd.postinstall`_

Notes
^^^^^

* Quoting `syslog-ng - FreeBSD Wiki`_:

     One of the most typical use of syslog-ng is central log aggregation. ... It collects log messages
     on TCP port 514 and saves them to directories and files based on sender host name and current
     date.

.. note::

   TBD

.. seealso::

   * `syslog-ng - FreeBSD Wiki`_
   * `syslog-ng - documentation`_
   * `Configuring System Logging - FreeBSD Handbook`_
   * documentation `Ansible role FreeBSD postinstall`_

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
   :emphasize-lines: 26-27

.. note::

   The below group declarations ::

     logserv: iocage_classes is contains('logserv')
     logclient: iocage_classes is contains('logclient')

   fail (ansible version 2.20) ::

     Failed to parse inventory with 'auto' plugin.

     <<< caused by >>>

     can't add group to itself

   As a workaround, use these declarations::

     logserv_group: iocage_classes is contains('logserv')
     logclient_group: iocage_classes is contains('logclient')

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/logserv_group/syslog-ng.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/logclient_group/syslog-ng.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

Fetch the iocage plugin
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml \
                            -i iocage.ini \
			    -t project_plugins \
			    -e debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

List plugins
^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -P

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook output - Create project from plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Flush the cache if you created the ``project`` and haven't refreshed the inventory cache yet.

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_project_create_from_plugins.yml \
                              -i iocage.ini \
			      -i hosts \
			      --flush-cache

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook pb-all-groups.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-all-groups.yml
   :language: yaml+jinja

Playbook output - Display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Flush the cache if necessary.

.. code-block:: console

   (env) > ansible-playbook pb-all-groups.yml -i hosts --flush-cache

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook pb-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml+jinja

Playbook output - Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logserv.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-test-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logserv.yml
   :language: yaml+jinja

Playbook output - Test Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-logserv.yml -i hosts -e debug=true

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:

Playbook pb-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient.yml
   :language: yaml+jinja

Playbook output - Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logclient.yml -i hosts -i iocage.ini -e debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-08.txt
   :language: sh

Playbook pb-test-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logclient.yml
   :language: yaml+jinja

Playbook output - Test Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-logclient.yml -i hosts

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:


.. _syslog-ng Client: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html
.. _syslog-ng Server: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

.. _syslog-ng - documentation: https://syslog-ng.github.io
.. _syslog-ng client hosts: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html

.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _syslog-ng - FreeBSD Wiki: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _sysutils/syslog-ng: https://www.freshports.org/sysutils/syslog-ng

.. _vbotka.freebsd.pb_iocage_plugins.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_plugins.yml/
.. _vbotka.freebsd.pb_iocage_project_create_from_plugins.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/

.. _Configuring System Logging - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/config/#configtuning-syslog
