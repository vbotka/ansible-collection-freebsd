.. _example_202:

202 Create Ansible client templates and clone DHCP Ansible client jails
-----------------------------------------------------------------------

Extending example :ref:`example_200`.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: template ansible_client; Example 202
.. index:: single: ansible_client; Example 202
.. index:: single: DHCP; Example 202
.. index:: single: dhclient; Example 202
.. index:: single: dhclient-exit-hooks; Example 202
.. index:: single: inventory vbotka.freebsd.iocage; Example 202
.. index:: single: module vbotka.freebsd.iocage; Example 202
.. index:: single: module community.general.pkgng; Example 202
.. index:: single: module ansible.posix.authorized; Example 202
.. index:: single: module ansible.builtin.lineinfile; Example 202
.. index:: single: playbook pb_iocage_template.yml; Example 202
.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 202

.. index:: single: option compose; Example 202
.. index:: single: compose; Example 202
.. index:: single: option hooks_results; Example 202
.. index:: single: hooks_results; Example 202
.. index:: single: property notes; Example 202
.. index:: single: notes; Example 202
.. index:: single: sudoers; Example 202
.. index:: single: variable iocage_hooks; Example 202
.. index:: single: iocage_hooks; Example 202

.. index:: single: act_dhclient; Example 202
.. index:: single: act_pkg; Example 202
.. index:: single: act_user; Example 202
.. index:: single: act_pk; Example 202
.. index:: single: act_sudo; Example 202
.. index:: single: act_rcconf; Example 202

Use case
^^^^^^^^

Get the IP addresses by DHCP. Create the *dhclient-exit-hooks*. For example, the below hook ::

   shell> cat /zroot/iocage/templates/ansible_client/root/etc/dhclient-exit-hooks 

.. code-block:: bash

   case "$reason" in
       "BOUND"|"REBIND"|"REBOOT"|"RENEW")
       echo $new_ip_address > /var/db/dhclient-hook.address.$interface
       ;;
   esac

creates files. For example, ::

  shell> cat /zroot/iocage/jails/test_101/root/var/db/dhclient-hook.address.epair0b
  10.1.0.130
  
Read the files, created by the hooks, and use the IP addresses to compose the variable
*ansible_host* ::

  shell> cat hosts/01_iocage.yml 

.. code-block:: yaml
   :force:

   plugin: vbotka.freebsd.iocage
   ...
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: iocage_hooks.0

The varaible *ansible_host* defaults to *iocage_ip4* if the hook is not available

.. code-block:: yaml

   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pk_admins.txt
  ├── hosts
  │   ├── 01_iocage.yml
  │   ├── 02_iocage.yml
  │   └── 03_constructed.yml
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   └── iocage_02
  │       └── iocage.yml
  ├── iocage-hosts.ini
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook `vbotka.freebsd.pb_iocage_template`_, use the modules:

  * vbotka.freebsd.iocage to create, start, stop, and convert jails to templates.
  * vbotka.freebsd.iocage exec to create a user and set .ssh ownership.
  * community.general.pkgng to install packages.
  * ansible.posix.authorized_key to configure public keys.
  * ansible.builtin.lineinfile to configure /etc/rc.conf and /usr/local/etc/sudoers
  * **configure dhclient hooks**.

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients`_, use the `module vbotka.freebsd.iocage`_ to:

  * create jails from the Ansible client templates
  * start all jails
  * optionally display the lists of jails.
  
* On all created jails:

  In the playbook *pb-test-01.yml*:

  * connect created jails
  * display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* playbook `vbotka.freebsd.pb_iocage_template`_
* playbook `vbotka.freebsd.pb_iocage_ansible_clients`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated *iocage*
* fetched releases.

Notes
^^^^^

* The option *hooks_results* expects the *poolname* of a jail to be mounted to */poolname*. For
  example, if you activate the pool *zroot* this plugin expects to find the *hooks_results* items
  in the path */zroot/iocage/jails/<name>/root*. If you mount the *poolname* to a different path
  the easiest remedy is to create a symlink.

.. seealso::

   * `man dhclient-script <https://man.freebsd.org/cgi/man.cgi?dhclient-script>`_
   * `Using Templates <https://iocage.readthedocs.io/en/latest/templates.html>`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 24-35

.. hint::

   The option ``hooks_results`` expects the ``pool`` to be mounted to
   ``/pool``. In the above *host_vars* the pool ``pool2`` is mounted to
   ``/mnt/pool2``. For ``hooks_results`` to work properly, create symlink in the
   root directory ::

     pool2 -> /mnt/pool2

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 23-34

.. hint::

   The minimal required hook is ::

     act_dhclient:
       dhclient-exit-hooks: |
         case "$reason" in
             "BOUND"|"REBIND"|"REBOOT"|"RENEW")
             echo $new_ip_address > /var/db/dhclient-hook.address.$interface
             ;;
         esac

.. note::

   The variables *act_\** are used to configure *ansible_client* template

   * The dhclient hooks *act_dhclient* will be created in */etc*.
   * The user *act_user* will be created in the template.
   * The user *act_user* will serve as Ansible *remote_user*.
   * The file *act_pk* provides the public keys allowed to ssh to *act_user*.
	       
.. warning::

   * The user *act_user* must exist on the *iocage* host. Otherwise,
     the module *ansible.posix.authorized_key* will crash. See
     *pb_iocage_template/pk.yml*

   * The file *files/pk_admins.txt* was sanitized. Fit the public keys to your needs ::

       shell> cat files/pk_admins.txt 
       ssh-rsa <sanitized> admin@controller
	       
Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

Playbook output - create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage-hosts.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

List templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook output - clone and start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                           -i iocage-hosts.ini \
                           -t clone \
                           -e clone=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash
	       
Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml
   :caption:

.. hint::

   The option ``hooks_results`` expects the ``pool`` to be mounted to
   ``/pool``. In this example, the pool ``pool2`` is mounted to
   ``/mnt/pool2``. For ``hooks_results`` to work properly, create symlink in the
   root directory ::

     /pool2 -> /mnt/pool2

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/03_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

::

  (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-07.txt
   :language: bash

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - display list *iocage_hooks*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i hosts

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

.. hint::

   The below command stops and destroys the cloned jails ::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                      -i iocage-hosts.ini \
                      -t clone_destroy \
                      -e clone_destroy=true

.. _vbotka.freebsd.pb_iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_template.yml/
.. _vbotka.freebsd.pb_iocage_ansible_clients: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
