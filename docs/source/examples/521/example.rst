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

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test
them. Use `syslog-ng`_. Clone the `iocage plugins`_
``ansible-pull-syslogng-server`` and ``ansible-pull-syslogng-client``.

Quoting `syslog-ng - FreeBSD Wiki`_:

    "One of the most typical use of syslog-ng is central log
    aggregation. ... It collects log messages on TCP port 514 and
    saves them to directories and files based on sender host name and
    current date."

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       └── project-hosts.yml
  ├── hosts
  │   └── 05_iocage.yml
  ├── host_vars
  │   └── iocage_05
  │       └── syslog-ng.yml
  ├── iocage.ini
  ├── pb-create-jails.yml
  ├── pb-logclient-test.yml
  └── pb-logserver-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_plugins.yml`_, fetch the
  `iocage plugins`_:

  * ``ansible-pull-syslogng-server``
  * ``ansible-pull-syslogng-client``

  In the playbook ``pb-create-jails.yml``:

  * Clone jails from the fetched iocage plugins.

* In the inventory group ``log_servers``, test `syslog-ng server`_.

* In the inventory group ``log_clients``, test `syslog-ng client`_.

Requirements
^^^^^^^^^^^^

* `iocage plugins`_:

  * ``ansible-pull-syslogng-server``
  * ``ansible-pull-syslogng-client``

* Configuration repositories for ``ansible-pull``:

  * `ansible-conf-syslogng-server`_
  * `ansible-conf-syslogng-client`_

* Playbook `vbotka.freebsd.pb_iocage_plugins.yml`_.
* `Inventory plugin vbotka.freebsd.iocage`_.
* :ref:`ug_connection_jailexec`.

.. important::

   For security reasons, you might want to create private repositories
   with the iocage plugins and configurations. See :ref:`example_523`.

.. note::

   * This example provides the same functionality as
     :ref:`example_522`. Here, ``iocage plugins`` are used instead of
     ``iocage templates``.

   * The same functionality is also created in :ref:`example_526`.

   * In this example, DHCP was provided by the iocage host. See
     :ref:`example_440`.

.. seealso::

   * `syslog-ng - FreeBSD Wiki`_
   * `syslog-ng - documentation`_
   * `Configuring System Logging - FreeBSD Handbook`_

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
   :language: yaml+jinja
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

.. literalinclude:: host_vars/iocage_05/syslog-ng.yml
   :language: yaml+jinja
   :caption:

Playbook output - Fetch iocage plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t enabled_plugins \
                            -e debug=true \
                            vbotka.freebsd.pb_iocage_plugins.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

List iocage plugins
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_05 sudo iocage list -P

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook pb-create-jails.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-create-jails.yml
   :language: yaml+jinja

Playbook output - Clone jails from iocage plugins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts pb-create-jails.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Inventory graph
^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_05 sudo iocage list -l

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

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

.. hint::

   Use the ``lnav`` utility on the log server to display all log files in the
   ``/var/log/remote`` directory. For example::

     shell> iocage console c8a9d789-fa02-4ce3-af66-41c848f87b0f
     root@c8a9d789-fa02-4ce3-af66-41c848f87b0f:~ # lnav -r /var/log/remote/

   To find the UUID, run ``iocage list -l`` and look for the jail
   cloned from the plugin ``ansible-pull-syslogng-server``.
