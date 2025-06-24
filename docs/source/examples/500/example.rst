.. _example_500:

500 syslog-ng Server and syslog-ng Clients
------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: syslog-ng; Example 500
.. index:: single: syslogd; Example 500
.. index:: single: loggen; Example 500
.. index:: single: log server; Example 500
.. index:: single: log client; Example 500
.. index:: single: role vbotka.freebsd.postinstall; Example 500
.. index:: single: vbotka.freebsd.postinstall; Example 500
.. index:: single: module vbotka.freebsd.service; Example 500
.. index:: single: vbotka.freebsd.service; Example 500
.. index:: single: module community.general.pkgng; Example 500
.. index:: single: community.general.pkgng; Example 500

Use case
^^^^^^^^

Configure and run a log server. Configure log clients and test them. Use `syslog-ng`_. Use the jails
created in the example :ref:`example_207`. The *project* keys are jails aliases.

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
       vmm: iocage_03
     db_2:
       class: [db, logclient]
       vmm: iocage_03

* Optionally, destroy all jails and templates. Run the play in :ref:`example_202`

  .. code-block:: console

     (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_destroy_all_jails.yml

* Create *ansible_client* templates. Run the play in :ref:`example_202`

  .. code-block:: console

     (env) > ansible-playbook -i iocage-hosts.ini vbotka.freebsd.pb_iocage_template.yml

* Create the project. Run the play in :ref:`example_207`

  .. code-block:: console

     (env) > ansible-playbook -i hosts -i iocage-hosts.ini pb-iocage-project-create.yml

Tree
^^^^

::

  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   └── common.yml
  │   ├── logclient
  │   │   └── syslog-ng.yml
  │   └── logserv
  │       └── syslog-ng.yml
  ├── hosts
  │   ├── 01_iocage.yml
  │   ├── 02_iocage.yml
  │   ├── 03_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage-hosts.ini
  ├── pb-logclient.yml
  ├── pb-logserv.yml
  ├── pb-test-all.yml
  └── pb-test-logclient.yml

Synopsis
^^^^^^^^

* In the inventory group *logserv*:

  * install `sysutils/syslog-ng`_
  * configure `syslog-ng Server`_.

* In the inventory group *logclient*:

  * install `sysutils/syslog-ng`_
  * configure `syslog-ng Client`_.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* `module vbotka.freebsd.service`_
* role `vbotka.freebsd.postinstall`_
* jails created in the project :ref:`example_207`

Notes
^^^^^

* Quoting `syslog-ng - FreeBSD Wiki`_:

     One of the most typical use of syslog-ng is central log aggregation. ... It collects log messages
     on TCP port 514 and saves them to directories and files based on sender host name and current
     date.

* ``logserv_1`` is an inventory alias of the host *17606f3f* with the IP 10.1.0.225

* See other hosts' aliases, ansible_host, and UUID in the playbook *pb-test-all.yml* output below.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `syslog-ng - FreeBSD Wiki`_
   * `syslog-ng - documentation`_
   * `Configuring System Logging - FreeBSD Handbook`_
   * documentation `Ansible role FreeBSD postinstall`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^
   
.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/03_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Flush the cache if you created the *project* and haven't refreshed it yet.

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-01.txt
   :language: yaml
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
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml+jinja

Playbook output - Configure and start Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the package if you're running this play for the first time.

.. code-block:: console

   (env) > ansible-playbook pb-logserv.yml -i hosts -e install=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Test the Log Server
^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ssh admin@17606f3f sudo service syslog-ng status
   syslog_ng is running as pid 63344.

.. code-block:: console

   (env) > ssh admin@17606f3f loggen -i -S -n 1 localhost 514
   count=1, rate = 500000.00 msg/sec
   average rate = 1.88 msg/sec, count=1, time=0.530987, (average) msg size=256, bandwidth=0.47 kB/sec

.. code-block:: console

   (env) > ssh admin@17606f3f sudo cat /var/log/remote/localhost/2025_06_22.log
   Jun 22 00:37:49 localhost prg00000[1234]: seq: 0000000000, thread: 0000, runid: 1750545469, stamp: 2025-06-22T00:37:49 PADDPADD...

Update repos
^^^^^^^^^^^^

In the following play *pb-logclient.yml* we delegate the package installation to the iocage
hosts. Let's update the repos to speedup the installation.

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_update_vmm_repos.yml \
                            -i iocage-hosts.ini -l iocage_02,iocage_03

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook pb-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logclient.yml
   :language: yaml+jinja

Playbook output - Configure and start Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the package if you’re running this play for the first time. The repos were updated in the
previous play. Set the `community.general.pkgng`_ option ``cached: true`` to speedup the
installation.

.. code-block:: console

   (env) > ansible-playbook pb-logclient.yml \
                            -i hosts -i iocage-hosts.ini \
                            -e install=true -e debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:


Playbook pb-test-logclient.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-logclient.yml
   :language: yaml+jinja

Playbook output - Test Log Client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-logclient.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

.. code-block:: console

   (env) > ssh admin@17606f3f sudo ls -lat /var/log/remote/ | sort
   drwx------  2 root  wheel   3 Jun 22 00:37 localhost
   drwx------  2 root  wheel   3 Jun 22 23:39 2b1a02cf
   drwx------  2 root  wheel   3 Jun 22 23:39 3eb2c8af
   drwx------  2 root  wheel   3 Jun 22 23:39 a2ec418c
   drwx------  2 root  wheel   3 Jun 22 23:39 b1442a0a
   drwx------  7 root  wheel   7 Jun 22 23:39 .
   drwxr-xr-x  5 root  wheel  27 Jun 22 00:37 ..


.. _syslog-ng Client: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html
.. _syslog-ng Server: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

.. _syslog-ng - documentation: https://syslog-ng.github.io/
.. _syslog-ng client hosts: https://syslog-ng.github.io/admin-guide/040_Quick-start_guide/000_Configuring_syslog-ng_on_client_hosts.html

.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _syslog-ng - FreeBSD Wiki: https://wiki.freebsd.org/Ports/sysutils/syslog-ng
.. _sysutils/syslog-ng: https://www.freshports.org/sysutils/syslog-ng

.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/
.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service
.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name

.. _Configuring System Logging - FreeBSD Handbook: https://docs.freebsd.org/en/books/handbook/config/#configtuning-syslog
