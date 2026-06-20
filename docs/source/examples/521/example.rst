.. _example_521:

521 iocage plugins ansible-pull-syslogng-*
------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: tag enabled_plugins; Example 521
.. index:: single: enabled_plugins; Example 521

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

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test them. Use `syslog-ng`_. Clone the
`iocage plugins`_ ``ansible-pull-syslogng-server`` and ``ansible-pull-syslogng-client``.

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
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       ├── hosts.yml
  │       └── syslog-ng.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── iocage.ini
  ├── pb-create-jails.yml
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

* In the inventory group ``log_server`` test `syslog-ng server`_.

* In the inventory group ``log_client`` test `syslog-ng client`_.

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

.. important::

   For security reasons, you might want to create private repositories with the iocage plugins and
   configurations. See the example :ref:`example_523`

.. note::

   * This example creates the same functionality as the example :ref:`example_522`. The ``iocage
     plugins`` are used here instead of ``iocage templates``.
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

.. literalinclude:: group_vars/all/hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/syslog-ng.yml
   :language: yaml+jinja
   :caption:

Playbook output - Fetch iocage plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

.. hint::

   Use ``lnav`` utility on the log server to display all logfiles in the the directory
   ``/var/log/remote``. For example, ::

     shell > iocage console c8a9d789-fa02-4ce3-af66-41c848f87b0f
     root@c8a9d789-fa02-4ce3-af66-41c848f87b0f:~ # lnav -r /var/log/remote/


.. _iocage plugins: https://github.com/vbotka/iocage-plugins
.. _ansible-conf-syslogng-server: https://github.com/vbotka/ansible-conf-syslogng-server
.. _ansible-conf-syslogng-client: https://github.com/vbotka/ansible-conf-syslogng-client

.. _syslog-ng client: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html
.. _syslog-ng server: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

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
