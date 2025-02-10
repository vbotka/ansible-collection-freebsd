.. _example_200:

200 Create Ansible client templates and clone Ansible client jails.
-------------------------------------------------------------------

.. contents:: Table of Contents
   :depth: 2

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
   ├── pb-iocage-ansible-clients -> ../../../../playbooks/pb-iocage-ansible-clients
   ├── pb-iocage-ansible-clients.yml -> ../../../../playbooks/pb-iocage-ansible-clients.yml
   ├── pb-iocage-template -> ../../../../playbooks/pb-iocage-template
   ├── pb-iocage-template.yml -> ../../../../playbooks/pb-iocage-template.yml
   └── pb-test-01.yml


Use case
^^^^^^^^

Create templates for Ansible clients. 

Synopsis
^^^^^^^^

.. index:: single: template ansible_client; Example 200
.. index:: single: ansible_client; Example 200
.. index:: single: playbook pb-iocage-template.yml; Example 200
.. index:: single: playbook pb-iocage-ansible-clients.yml; Example 200
.. index:: single: inventory vbotka.freebsd.iocage; Example 200
.. index:: single: module vbotka.freebsd.iocage; Example 200
.. index:: single: module community.general.pkgng; Example 200
.. index:: single: module ansible.posix.authorized; Example 200
.. index:: single: module ansible.builtin.lineinfile; Example 200
.. index:: single: sudoers; Example 200

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-template.yml*, use the modules:

  * vbotka.freebsd.iocage to create, start, stop, and convert jails to templates.
  * vbotka.freebsd.iocage exec to create a user and set .ssh ownership.
  * community.general.pkgng to install packages.
  * ansible.posix.authorized_key to configure public keys.
  * ansible.builtin.lineinfile to configure /etc/rc.conf and /usr/local/etc/sudoers

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

.. seealso::

   * `Using Templates <https://iocage.readthedocs.io/en/latest/templates.html>`_
   * `Connection methods and details <https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html>`_
   * `Understanding privilege escalation: become <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become>`_

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

.. note::

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

Clone jails
^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

List jails
^^^^^^^^^^

.. literalinclude:: out/out-09.txt
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
