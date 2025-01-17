.. _example_018:

018 Clone basejails and use DHCP
--------------------------------

Extending example 010.

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
   └── pb-test.yml

Synopsis
^^^^^^^^

Use DHCP to configure the interfaces.

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-clone-list.yml*, use the `module vbotka.freebsd.iocage`_ to:

  * clone 3 jails from the basejail
  * start all jails
  * display lists of jails.

* On the iocage host *iocage_02*
  
  In the playbook *pb-test.yml*, use the `inventory plugin vbotka.freebsd.iocage`_ to:

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

Enable *"sudo: true"*. Otherwise, *iocage* will complain *"DHCP (running -- address requires root)"*

.. literalinclude:: iocage.yml
    :language: yaml
    :emphasize-lines: 4

.. hint::

   * Limit admins sudo to the *"iocage list"* command ::

       shell> grep iocage /usr/local/etc/sudoers
       admin ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/iocage list*

   * The tag *SETENV*, to preserve the environment, is needed when *env* is set.

       
Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-06.txt
    :language: yaml

Playbook *pb-test.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-07.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the jails are stopped the IP4 tab says: *"DHCP (not running)"*.

.. literalinclude:: out/out-08.txt
    :language: bash

Playbook output
^^^^^^^^^^^^^^^

The jails are stopped.

.. literalinclude:: out/out-09.txt
    :language: bash

.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
