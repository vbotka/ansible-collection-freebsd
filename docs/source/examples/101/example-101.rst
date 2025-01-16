.. _example_101:

101 Create custom facts.
------------------------

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
   └── pb-test-01.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage.yml*:

  * create custom facts scripts.

  In the playbook *pb-test-01.yml*:

  * get the custom facts
  * use the filter *vbotka.freebsd.iocage* to parse the custom facts
  * create the inventory group *test* and compose variables
  * display the hosts and composed variables in the group *test*
  * display all groups.


Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* filter vbotka.freebsd.iocage
* root privilege on the iocage hosts


Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

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

Playbook *pb-iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
    :language: yaml

Playbook debug output
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash
	       
List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-06.txt
    :language: bash

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
