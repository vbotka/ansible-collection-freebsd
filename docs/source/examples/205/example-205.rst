.. _example_205:

205 Create Ansible client templates v2
--------------------------------------

Extending example :ref:`example_202`.

.. contents:: Table of Contents
   :depth: 2

.. index:: single: template ansible_client; Example 205
.. index:: single: ansible_client; Example 205
.. index:: single: DHCP; Example 205
.. index:: single: dhclient; Example 205
.. index:: single: dhclient-exit-hooks; Example 205
.. index:: single: module vbotka.freebsd.iocage; Example 205
.. index:: single: module community.general.pkgng; Example 205
.. index:: single: module ansible.posix.authorized; Example 205
.. index:: single: module ansible.builtin.lineinfile; Example 205
.. index:: single: playbook pb-iocage-template.yml; Example 205
.. index:: single: property notes; Example 205
.. index:: single: notes; Example 205

.. index:: single: act_dhclient; Example 205
.. index:: single: act_pkg; Example 205
.. index:: single: act_user; Example 205
.. index:: single: act_pk; Example 205
.. index:: single: act_sudo; Example 205
.. index:: single: act_rcconf; Example 205

Use case
^^^^^^^^

Create template *ansible_client* at 3 iocage hosts.
	   
Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── files
   │   └── pk_admins.txt
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   ├── iocage_02
   │   │   └── iocage.yml
   │   └── iocage_03
   │       └── iocage.yml
   ├── iocage-hosts.ini
   ├── pb-iocage-template -> ../../../../playbooks/pb-iocage-template
   └── pb-iocage-template.yml -> ../../../../playbooks/pb-iocage-template.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02
  * iocage_03

  In the playbook *pb-iocage-template.yml*, use the modules:

  * vbotka.freebsd.iocage to create, start, stop, and convert jails to templates.
  * vbotka.freebsd.iocage exec to create a user and set .ssh ownership.
  * community.general.pkgng to install packages.
  * ansible.posix.authorized_key to configure public keys.
  * ansible.builtin.lineinfile to configure /etc/rc.conf and /usr/local/etc/sudoers
  * configure dhclient hooks.


Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated *iocage*
* fetched releases

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

host_vars/iocage_03/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_03/iocage.yml
    :language: yaml
	       
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

List templates at iocage_03
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
