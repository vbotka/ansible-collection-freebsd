.. _example_522:

522 iocage templates ansible-syslogng-*
---------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible-syslogng-server; Example 522
.. index:: single: template ansible-syslogng-client; Example 522
.. index:: single: role vbotka.freebsd.iocage_template; Example 522

.. index:: single: connection vbotka.freebsd.jailexec; Example 522
.. index:: single: inventory vbotka.freebsd.iocage; Example 522

.. index:: single: syslog-ng; Example 522
.. index:: single: syslogd; Example 522
.. index:: single: loggen; Example 522
.. index:: single: log server; Example 522
.. index:: single: log client; Example 522

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test them. Use `syslog-ng`_. Create
templates ``ansible-syslogng-server`` and ``ansible-syslogng-client``. Create the jails from the
templates.

Quoting `syslog-ng - FreeBSD Wiki`_:

    "One of the most typical use of syslog-ng is central log aggregation. ... It collects log
    messages on TCP port 514 and saves them to directories and files based on sender host name and
    current date."

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pkgs-logclient.json
  │   └── pkgs-logserver.json
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       └── project-hosts.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── host_vars
  │   ├── ansible_syslogng_client
  │   │   └── syslog-ng-client.yml
  │   ├── ansible_syslogng_server
  │   │   └── syslog-ng-server.yml
  │   └── iocage_05
  │       └── template.yml
  ├── iocage.ini
  ├── pb-create-jails.yml
  ├── pb-iocage-template-stop-convert.yml
  ├── pb-iocage-template.yml
  ├── pb-logclient-test.yml
  ├── pb-logclient.yml
  ├── pb-logserver-test.yml
  └── pb-logserver.yml

Synopsis
^^^^^^^^

* At a managed node:

  Use the role `vbotka.freebsd.iocage_template`_ to create templates:

  * ``ansible-syslogng-server``
  * ``ansible-syslogng-client``

  In the playbook ``pb-create-jails.yml``:

  * Create jails from the created templates

* In the inventory group ``log_servers`` configure and test `syslog-ng server`_.

* In the inventory group ``log_clients`` configure and test `syslog-ng client`_.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* role `vbotka.freebsd.postinstall`_
* `inventory plugin vbotka.freebsd.iocage`_
* `connection plugin vbotka.freebsd.jailexec`_

.. note::

   * This example creates the same functionality as the example :ref:`example_521`. The ``iocage
     templates`` are used here instead of ``iocage plugins``.
   * The same functionality is created also in the example :ref:`example_526`.
   * In this example, DHCP was provided by the iocage host. See :ref:`example_440`.

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

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/ansible_syslogng_client/syslog-ng-client.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/ansible_syslogng_server/syslog-ng-server.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_05/template.yml
   :language: yaml
   :caption:

files
^^^^^

.. literalinclude:: files/pkgs-logclient.json
   :language: json
   :caption:

.. literalinclude:: files/pkgs-logserver.json
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

Playbook pb-logserver.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserver.yml
   :language: yaml+jinja

Playbook output - Configure and start Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logserver.yml -i hosts

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook pb-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient.yml
   :language: yaml+jinja

Playbook output - Configure and start Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logclient.yml -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook pb-iocage-template-stop-convert.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template-stop-convert.yml
   :language: yaml+jinja

Playbook output - Convert ansible-syslogng-* to templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-template-stop-convert.yml -i iocage.ini

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:
      
List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -lt

.. literalinclude:: out/out-05.txt
   :language: sh

Playbook pb-create-jails.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-create-jails.yml
   :language: yaml+jinja

Playbook output - Create jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-create-jails.yml.yml -i iocage.ini -i hosts

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-07.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-08.txt
   :language: sh

Playbook pb-logserver-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserver-test.yml
   :language: yaml+jinja

Playbook output - Test Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-logserver-test.yml -i hosts -e debug=true

.. literalinclude:: out/out-09.txt
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

.. literalinclude:: out/out-10.txt
   :language: yaml
   :force:

.. hint::

   Use ``lnav`` utility on the log server to display all logfiles in the the directory
   ``/var/log/remote``::

     shell > iocage console log-server
     root@log-server:~ # lnav -r /var/log/remote/


.. _syslog-ng client: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html
.. _syslog-ng server: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

.. _syslog-ng - documentation: https://syslog-ng.github.io
.. _syslog-ng client hosts: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html

.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _syslog-ng - FreeBSD Wiki: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _sysutils/syslog-ng: https://www.freshports.org/sysutils/syslog-ng

.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/

.. _Configuring System Logging - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/config/#configtuning-syslog
