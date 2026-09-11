.. _example_500:

500 syslog-ng server and syslog-ng clients
------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: project; Example 500

.. index:: single: syslog-ng; Example 500
.. index:: single: syslogd; Example 500
.. index:: single: loggen; Example 500
.. index:: single: log server; Example 500
.. index:: single: log client; Example 500

.. index:: single: postinstall; Example 500
.. index:: single: vbotka.freebsd.postinstall; Example 500
.. index:: single: role vbotka.freebsd.postinstall; Example 500

.. index:: single: module vbotka.freebsd.service; Example 500
.. index:: single: vbotka.freebsd.service; Example 500
.. index:: single: module community.general.pkgng; Example 500
.. index:: single: community.general.pkgng; Example 500

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test
them. Use `syslog-ng`_. Use the jails created in example
:ref:`example_207`. The ``project`` keys are jail aliases.

.. code-block:: yaml

   project:
     logserv_1:
       class: [logserv]
       vmm: iocage_01
     http_1:
       class: [http, logclient]
       vmm: iocage_02
     db_1:
       class: [db, logclient]
       vmm: iocage_02
     http_2:
       class: [http, logclient]
       vmm: iocage_04
     db_2:
       class: [db, logclient]
       vmm: iocage_04

* Destroy all jails:

  .. code-block:: console

     (env) > ansible-playbook -i iocage.ini \
                              --flush-cache \
                              vbotka.freebsd.pb_iocage_destroy_all_jails.yml

* Create ``ansible-client`` templates. Run the play in :ref:`example_202`:

  .. code-block:: console

     (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

* Create the project. Run the play in :ref:`example_207`:

  .. code-block:: console

     (env) > ansible-playbook -i iocage.ini -i hosts pb-iocage-project-create.yml

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   └── common.yml
  │   ├── logclient
  │   │   └── syslog-ng.yml
  │   └── logserv
  │       └── syslog-ng.yml
  ├── hosts
  │   ├── 01_iocage.yml
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-all-groups.yml
  ├── pb-logclient.yml
  ├── pb-logserv.yml
  └── pb-test-logclient.yml

Synopsis
^^^^^^^^

* In the inventory group ``logserv``:

  * Install `sysutils/syslog-ng`_.
  * Configure `syslog-ng Server`_.

* In the inventory group ``logclient``:

  * Install `sysutils/syslog-ng`_.
  * Configure `syslog-ng Client`_.

Requirements
^^^^^^^^^^^^

* `Inventory plugin vbotka.freebsd.iocage`_.
* `Module vbotka.freebsd.service`_.
* Role `vbotka.freebsd.postinstall`_.
* Jails created in the project :ref:`example_207`.

Notes
^^^^^

* Quoting `syslog-ng - FreeBSD Wiki`_:

     One of the most typical use of syslog-ng is central log
     aggregation. ... It collects log messages on TCP port 514 and
     saves them to directories and files based on sender host name and
     current date.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection ``vbotka.freebsd``.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.

.. seealso::

   * `syslog-ng - FreeBSD Wiki`_
   * `syslog-ng - documentation`_
   * `Configuring System Logging - FreeBSD Handbook`_
   * Documentation `Ansible role FreeBSD postinstall`_

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

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Playbook pb-all-groups.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-all-groups.yml
   :language: yaml+jinja

Playbook output - Display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Flush the cache if you created the ``project`` and have not refreshed it yet.

.. code-block:: console

   (env) > ansible-playbook -i hosts --flush-cache pb-all-groups.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/logserv/syslog-ng.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/logclient/syslog-ng.yml
   :language: yaml+jinja
   :caption:

Playbook pb-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml+jinja

Playbook output - Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the package if you are running this play for the first time.

.. code-block:: console

   (env) > ansible-playbook -i hosts -e install=true pb-logserv.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Test the Log Server
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ssh admin@4b07a142 sudo service syslog-ng status
   syslog_ng is running as pid 63344.

.. code-block:: console

   (env) > ssh admin@4b07a142 loggen -i -S -n 1 localhost 514
   count=1, rate = 100000.00 msg/sec
   average rate = 1.95 msg/sec, count=1, time=0.512063, (average) msg size=256, bandwidth=0.49 kB/sec

.. code-block:: console

   (env) > ssh admin@4b07a142 sudo cat /var/log/remote/localhost/2025_08_12.log
    Aug 12 01:41:22 localhost prg00000[1234]: seq: 0000000000, thread: 0000, runid: 1754955682, stamp: 2025-08-12T01:41:22 PADDPADD...
    Aug 12 01:42:42 localhost prg00000[1234]: seq: 0000000000, thread: 0000, runid: 1754955762, stamp: 2025-08-12T01:42:42 PADDPADD...

.. note::

   This test is not created dynamically. The Log Server jail name in this test differs from the
   dynamically created name in the example. (TBD)

Playbook pb-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient.yml
   :language: yaml+jinja

Playbook output - Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the package if you are running this play for the first time.

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini -e install=true -e debug=true pb-logclient.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logclient.yml
   :language: yaml+jinja

Playbook output - Test Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-logclient.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Example directory listing on the log server:

.. code-block:: console

   (env) > ssh admin@4b07a142 sudo ls -lat /var/log/remote/ | sort
   drwx------  2 root  wheel   3 Aug 12 01:30 0f8e3961
   drwx------  2 root  wheel   3 Aug 12 01:30 33a222bb
   drwx------  2 root  wheel   3 Aug 12 01:30 35167ffa
   drwx------  2 root  wheel   3 Aug 12 01:30 ef5d35da
   drwx------  2 root  wheel   3 Aug 12 01:41 localhost
   drwx------  7 root  wheel   7 Aug 12 01:41 .
   drwxr-xr-x  3 root  wheel  17 Aug 12 01:30 ..

.. note:: This example of the directory at the Log Server is not created dynamically. (TBD)
