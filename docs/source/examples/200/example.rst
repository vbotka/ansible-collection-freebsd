.. _example_200:

200 Create Ansible client templates and clone jails
---------------------------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: ansible_client; Example 200
.. index:: single: template ansible_client; Example 200
.. index:: single: playbook pb_iocage_template.yml; Example 200
.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 200
.. index:: single: inventory vbotka.freebsd.iocage; Example 200
.. index:: single: module vbotka.freebsd.iocage; Example 200
.. index:: single: module community.general.pkgng; Example 200
.. index:: single: community.general.pkgng; Example 200
.. index:: single: module ansible.posix.authorized; Example 200
.. index:: single: ansible.posix.authorized; Example 200
.. index:: single: module ansible.builtin.lineinfile; Example 200
.. index:: single: ansible.builtin.lineinfile; Example 200
.. index:: single: sudoers; Example 200

.. index:: single: option compose; Example 200
.. index:: single: compose; Example 200
.. index:: single: option groups; Example 200

.. index:: single: act_pkg; Example 200
.. index:: single: act_user; Example 200
.. index:: single: act_pk; Example 200
.. index:: single: act_sudo; Example 200
.. index:: single: act_rcconf; Example 200

Use case
^^^^^^^^

Create templates for Ansible clients and clone jails.

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
  * vbotka.freebsd.iocage exec tasks to create a user and set .ssh ownership.
  * community.general.pkgng to install packages.
  * ansible.posix.authorized_key to configure public keys.
  * ansible.builtin.lineinfile to configure /etc/rc.conf and /usr/local/etc/sudoers

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

.. seealso::

   * `Using Templates`_
   * `Connection methods and details`_
   * `Understanding privilege escalation`_

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

.. note::

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

Playbook output - list jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                           -i iocage-hosts.ini \
                           -t list \
                           -e debug=true

.. literalinclude:: out/out-09.txt
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

Playbook output - display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
.. _Using Templates: https://iocage.readthedocs.io/en/latest/templates.html
.. _Connection methods and details: https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html
.. _Understanding privilege escalation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#become
