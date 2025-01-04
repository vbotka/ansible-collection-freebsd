.. _example_018:

018 Clone basejails and use DHCP
--------------------------------

Extending example 010

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   └── iocage_02
   │       └── iocage.yml
   ├── iocage-hosts.ini
   ├── iocage.yml
   ├── pb-iocage-clone-list.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

Use DHCP to configure the interfaces.

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-clone-list.yml*, use the module *vbotka.freebsd.iocage* to:

  * clone 3 jails from the basejail
  * start all jails
  * display lists of jails.

* On the iocage host *iocage_02*
  
  In the playbook *pb-test-01.yml*, use the inventory plugin *vbotka.freebsd.iocage* to:

  * create the inventory groups and compose variables
  * display the hosts and composed variables in the group *test*

Jails at iocage_01
^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash
    
Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

Playbook *pb-iocage-clone-list.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone-list.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
    :language: bash
	       
Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.yml
    :language: yaml
	       
Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-06.txt
    :language: yaml

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-07.txt
    :language: bash
