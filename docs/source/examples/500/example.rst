.. _example_500:

500 Syslog server and clients
-----------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: syslog-ng; Example 500
.. index:: single: syslogd; Example 500
.. index:: single: loggen; Example 500
.. index:: single: syslog server; Example 500
.. index:: single: syslog client; Example 500
.. index:: single: role vbotka.freebsd.postinstall; Example 500
.. index:: single: vbotka.freebsd.postinstall; Example 500
.. index:: single: module community.general.pkgng; Example 500
.. index:: single: community.general.pkgng; Example 500

Use case
^^^^^^^^

Create and run a syslog server. Create syslog clients and test them. Use the jails created in the
example :ref:`example_207`. The *project* keys are jails aliases. See the chapter *Playbook output -
display all groups* below.

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

* Destroy all jails and templates. Run the play in :ref:`example_202`

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

TBD

Synopsis
^^^^^^^^

* At three iocage hosts:

  * iocage_01
  * iocage_02
  * iocage_03

TBD

Requirements
^^^^^^^^^^^^

* jails created in the project :ref:`example_207`
* `inventory plugin vbotka.freebsd.iocage`_
* role `vbotka.freebsd.postinstall`_

Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module
  `community.general.pkgng`_ if the jail was created by *iocage*. Use JID
  instead.

* A play installing packages in the jails needs the inventory *iocage-hosts.ini* to delegate the
  task `community.general.pkgng`_ to an iocage host.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `Log Server Configuration`_
   * `Log Client Configuration`_
   * `syslog-ng`_
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
   :language: yaml
   :caption:

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml

Playbook output - display all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Refresh cache.

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml --flush-cache

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/logserv/syslog-ng.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/logclient/syslog-ng.yml
   :language: yaml
   :caption:

Playbook pb-logserv.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-logserv.yml
   :language: yaml

Playbook output - Configure and start Log Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the package if you're running this play for the first time.

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-logserv.yml -e install=true

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


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _Log Server Configuration: https://docs.freebsd.org/en/books/handbook/config/#_log_server_configuration
.. _Log Client Configuration: https://docs.freebsd.org/en/books/handbook/config/#_log_client_configuration
.. _syslog-ng: https://wiki.freebsd.org/Ports/sysutils/syslog-ng

.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/
.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
