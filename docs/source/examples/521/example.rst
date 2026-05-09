.. _example_521:

521 Iocage plugins ansible-pull-syslogng-*
------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible-pull; Example 521
.. index:: single: ansible-pull repo ansible-conf-syslogng-server; Example 521
.. index:: single: ansible-pull repo ansible-conf-syslogng-client; Example 521
.. index:: single: ansible-conf-syslogng-server; Example 521
.. index:: single: ansible-conf-syslogng-client; Example 521

.. index:: single: iocage plugins; Example 521
.. index:: single: iocage plugin ansible-pull-syslogng-server; Example 521
.. index:: single: iocage plugin ansible-pull-syslogng-client; Example 521
.. index:: single: ansible-pull-syslogng-server; Example 521
.. index:: single: ansible-pull-syslogng-client; Example 521

.. index:: single: pb_iocage_plugins.yml; Example 521
.. index:: single: connection vbotka.freebsd.jailexec; Example 521
.. index:: single: inventory vbotka.freebsd.iocage; Example 521

.. index:: single: syslog-ng; Example 521
.. index:: single: syslogd; Example 521
.. index:: single: loggen; Example 521
.. index:: single: log server; Example 521
.. index:: single: log client; Example 521

.. index:: single: module vbotka.freebsd.service; Example 521
.. index:: single: vbotka.freebsd.service; Example 521

.. index:: single: tag enabled_plugins; Example 521

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test them. Use `syslog-ng`_. Clone the
iocage plugins ``ansible-pull-syslogng-server`` and ``ansible-pull-syslogng-client``.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       └── syslog-ng.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── iocage.ini
  ├── pb-conf-logclient.yml
  ├── pb-create-jails.yml
  ├── pb-start-jails.yml
  ├── pb-test-logclient.yml
  └── pb-test-logserv.yml

Synopsis
^^^^^^^^

* At a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_plugins.yml`_ fetch the `iocage plugins`_:

  * ``ansible-pull-syslogng-server``
  * ``ansible-pull-syslogng-client``

  In the playbook ``pb-create-jails.yml``:

  * Clone jails from the fetched iocage plugins

* In the inventory group ``log_server`` test `syslog-ng Server`_.

* In the inventory group ``log_client`` configure and test `syslog-ng Client`_.

Requirements
^^^^^^^^^^^^

* `iocage plugins`_:

  * ``ansible-pull-syslogng-server``
  * ``ansible-pull-syslogng-client``

* Configuration repositories for ``ansible-pull``:

  * `ansible-conf-syslogng-server`_
  * `ansible-conf-syslogng-client`_

* playbook `vbotka.freebsd.pb_iocage_plugins.yml`_
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

   In this example, DHCP was provided by the iocage host. See :ref:`example_440`

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

.. literalinclude:: group_vars/all/syslog-ng.yml
   :language: yaml+jinja
   :caption:

Fetch iocage plugins
^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_plugins.yml \
                            -i iocage.ini \
                            -t enabled_plugins \
                            -e debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

List iocage plugins
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -P

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook pb-create-jails.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-create-jails.yml
   :language: yaml+jinja

Playbook output - Create jails from iocage plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-create-jails.yml.yml -i iocage.ini

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

Playbook pb-start-jails.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-start-jails.yml
   :language: yaml+jinja

Playbook output - Start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-start-jails.yml -i hosts -i iocage.ini -e debug=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-conf-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-conf-logclient.yml
   :language: yaml+jinja
   :emphasize-lines: 21-23

.. note::

   The configuration file ``/usr/local/etc/syslog-ng.conf``, created by the iocage plugin
   ``ansible-pull-syslogng-client`` from the repo `ansible-conf-syslogng-client`_, keeps the string
   ``LOG_SERVER`` in the place of the log-server IP. The above play replaces this string with the
   log-server IP.

Playbook output - Configure, enable, and start Log Clients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-conf-logclient.yml -i hosts -i iocage.ini -e debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_05 sudo iocage list -l

.. literalinclude:: out/out-07.txt
   :language: sh

Playbook pb-test-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logserv.yml
   :language: yaml+jinja

Playbook output - Test Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-logserv.yml -i hosts -e debug=true

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

Playbook pb-test-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logclient.yml
   :language: yaml+jinja

Playbook output - Test Log Clients
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-logclient.yml -i hosts

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:

.. _iocage plugins: https://github.com/vbotka/iocage-plugins
.. _ansible-conf-syslogng-server: https://github.com/vbotka/ansible-conf-syslogng-server
.. _ansible-conf-syslogng-client: https://github.com/vbotka/ansible-conf-syslogng-client

.. _syslog-ng Client: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html
.. _syslog-ng Server: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

.. _syslog-ng - documentation: https://syslog-ng.github.io
.. _syslog-ng client hosts: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html

.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _syslog-ng - FreeBSD Wiki: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _sysutils/syslog-ng: https://www.freshports.org/sysutils/syslog-ng

.. _vbotka.freebsd.pb_iocage_plugins.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_plugins.yml/

.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/

.. _Configuring System Logging - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/config/#configtuning-syslog
