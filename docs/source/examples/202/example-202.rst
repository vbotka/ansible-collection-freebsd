.. _example_202:

202 Create Ansible client templates and clone DHCP Ansible client jails
-----------------------------------------------------------------------

Extending example :ref:`example_200`.

.. contents:: Table of Contents
   :depth: 2

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
.. index:: single: playbook pb-iocage-template.yml; Example 202
.. index:: single: playbook pb-iocage-ansible-clients.yml; Example 202

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

Get the IP addresses by DHCP. Create the *dhclient-exit-hooks*. For example, the below hook::

  shell> cat /zroot/iocage/templates/ansible_client/root/etc/dhclient-exit-hooks 
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
  plugin: vbotka.freebsd.iocage
  ...
  hooks_results:
    - /var/db/dhclient-hook.address.epair0b
  compose:
    ansible_host: iocage_hooks.0

Default to *iocage_ip4* if the hook is not available ::

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
   ├── pb-iocage-ansible-clients.yml -> ../../../../playbooks/pb-iocage-ansible-clients.yml
   ├── pb-iocage-template -> ../../../../playbooks/pb-iocage-template
   ├── pb-iocage-template.yml -> ../../../../playbooks/pb-iocage-template.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-template.yml*, use the modules:

  * vbotka.freebsd.iocage to create, start, stop, and convert jails to templates.
  * vbotka.freebsd.iocage exec to create a user and set .ssh ownership.
  * community.general.pkgng to install packages.
  * ansible.posix.authorized_key to configure public keys.
  * ansible.builtin.lineinfile to configure /etc/rc.conf and /usr/local/etc/sudoers
  * configure dhclient hooks.

  In the playbook *pb-iocage-ansible-clients.yml*, use the module *vbotka.freebsd.iocage* to:

  * create jails from the Ansible client templates
  * start all jails
  * optionally display the lists of jails.
  
* On all created jails:

  In the playbook *pb-test-01.yml*:

  * connect created jails
  * display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated *iocage*
* fetched releases

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

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

.. hint::

   The option *hooks_results* expects the *pool* to be mounted to */pool*. In the above *host_vars*
   the pool *pool2* is mounted to */mnt/pool2*. For *hooks_results* to work properly, create symlink
   in the root directory ::

     pool2 -> /mnt/pool2

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

.. note::

   The variables *act_\** are used to configure *ansible_client* template

   * The dhclient hooks *act_dhclient* will be created in */etc*.
   * The user *act_user* will be created in the template.
   * The user *act_user* will serve as Ansible *remote_user*.
   * The file *act_pk* provides the public keys allowed to ssh to *act_user*.
	       
.. warning::

   * The user *act_user* must exist on the *iocage* host. Otherwise,
     the module *ansible.posix.authorized_key* will crash. See
     *pb-iocage-template/pk.yml*

   * The file *files/pk_admins.txt* was sanitized. Fit the public keys to your needs ::

       shell> cat files/pk_admins.txt 
       ssh-rsa <sanitized> admin@controller
	       
Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

Playbook *pb-iocage-template.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

List templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Playbook *pb-iocage-ansible-clients.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-ansible-clients.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
    :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-06.txt
    :language: bash
	       
Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml

Inventory *hosts/03_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/03_constructed.yml
    :language: yaml

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-07.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-08.txt
    :language: bash

.. hint::

   The below command stops and destroys the cloned jails ::

     ansible-playbook pb-iocage-ansible-clients.yml -i iocage-hosts.ini \
                                                    -t clone_destroy \
						    -e clone_destroy=true


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
