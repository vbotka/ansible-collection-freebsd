.. _example_030:

030 Create Ansible client template and clone Ansible client jails.
------------------------------------------------------------------

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   ├── 03_iocage.yml
   │   └── 04_constructed.yml
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   ├── iocage_02
   │   │   └── iocage.yml
   │   └── iocage_03
   │       └── iocage.yml
   ├── iocage-hosts.ini
   ├── pb-iocage-ansible-clients.yml
   ├── pb-iocage-template.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

(WIP)

* On three iocage hosts:

  * iocage_01
  * iocage_02
  * iocage_03

  In the playbook *pb-iocage-template.yml*, use the module *vbotka.freebsd.iocage* to:

  * create Ansible client template.

  In the playbook *pb-iocage-ansible-clients.yml*, use the module *vbotka.freebsd.iocage* to:

  * clone jails from the Ansible client template 
  * start all jails
  * optionally display the lists of jails.
  
* In the playbook *pb-test-01.yml*:

  * connect created jails
  * audit basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* module *vbotka.freebsd.iocage*
* inventory plugin *vbotka.freebsd.iocage*
* root privilege on the iocage hosts
* activated *iocage*
* fetched releases

  
Notes
^^^^^

.. seealso::

   * `Using Templates <https://iocage.readthedocs.io/en/latest/templates.html>`_

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

Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml

Inventory *hosts/03_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/03_iocage.yml
    :language: yaml

Inventory *hosts/04_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_constructed.yml
    :language: yaml

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-06.txt
    :language: bash
