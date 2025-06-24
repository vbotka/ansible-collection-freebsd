.. _example_205:

205 Create Ansible client templates v2
--------------------------------------

Extending example :ref:`example_202`.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: ansible_client; Example 205
.. index:: single: template ansible_client; Example 205
.. index:: single: DHCP; Example 205
.. index:: single: act_dhclient; Example 205
.. index:: single: act_pk; Example 205
.. index:: single: act_pkg; Example 205
.. index:: single: act_rcconf; Example 205
.. index:: single: act_sudo; Example 205
.. index:: single: act_user; Example 205
.. index:: single: ansible_client; Example 205
.. index:: single: dhclient-exit-hooks; Example 205
.. index:: single: dhclient; Example 205
.. index:: single: module vbotka.freebsd.iocage; Example 205
.. index:: single: module ansible.builtin.lineinfile; Example 205
.. index:: single: ansible.builtin.lineinfile; Example 205
.. index:: single: module ansible.posix.authorized; Example 205
.. index:: single: ansible.posix.authorized; Example 205
.. index:: single: module community.general.pkgng; Example 205
.. index:: single: community.general.pkgng; Example 205
.. index:: single: notes; Example 205
.. index:: single: playbook pb_iocage_template.yml; Example 205
.. index:: single: property notes; Example 205

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
  └── iocage-hosts.ini

Synopsis
^^^^^^^^

* The only difference between the examples 202. and 205. is the third host iocage_03. This example
  creates the templates only.

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_03/iocage.yml
   :language: yaml
   :caption:

.. warning::

   * The user *act_user* must exist on the *iocage* host. Otherwise, the module
     *ansible.posix.authorized_key* will crash. See *pb_iocage_template/pk.yml*

   * The file *files/pk_admins.txt* was sanitized. Fit the public keys to your needs ::

       shell> cat files/pk_admins.txt 
       ssh-rsa <sanitized> admin@controller

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

Playbook output - create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-template.yml -i iocage-hosts.ini -l iocage_03

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

List templates at iocage_03
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_03]# iocage list -lt

.. literalinclude:: out/out-04.txt
   :language: bash


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
