.. _example_018:

018 Clone basejails and use DHCP
--------------------------------

Extending example :ref:`example_010`.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: DHCP; Example 018
.. index:: single: module vbotka.freebsd.iocage; Example 018
.. index:: single: inventory vbotka.freebsd.iocage; Example 018
.. index:: single: option sudo; Example 018
.. index:: single: sudo; Example 018
.. index:: single: option sudo_preserve_env; Example 018
.. index:: single: sudo_preserve_env; Example 018
.. index:: single: sudoers; Example 018
.. index:: single: SETENV; Example 018
.. index:: single: variable iocage_ip4_dict; Example 018
.. index:: single: iocage_ip4_dict; Example 018

Use case
^^^^^^^^

Use DHCP to configure the interfaces.

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
  * display the hosts and composed variables in the group *test*.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails *ansible_client* created in :ref:`example_010`

Jails at iocage_01
^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
    
Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

Playbook *pb-iocage-clone-list.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone-list.yml
   :language: yaml

Playbook output - clone, start, and list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-iocage-clone-list.yml -i iocage-hosts.ini

.. literalinclude:: out/out-03.txt
   :language: bash

List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash
	       
Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

Enable *"sudo: true"*. Otherwise, *iocage* will complain *"DHCP (running -- address requires
root)"*. Enable also *"sudo_preserve_env: true"* if *env* is used.

.. literalinclude:: iocage.yml
   :language: yaml
   :emphasize-lines: 4,5

.. hint::

   * Limit admins sudo to the *"iocage list"* command ::

       shell> grep iocage /usr/local/etc/sudoers
       admin ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/iocage list*

   * The tag *SETENV*, to preserve the environment, is needed when *env* is set.

       
Display inventory
^^^^^^^^^^^^^^^^^

::

  (env) > ansible-inventory -i iocage.yml --list --yaml

.. literalinclude:: out/out-06.txt
   :language: yaml

Playbook *pb-test.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - list some iocage_* vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-07.txt
   :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a jail is stopped the IP4 tab says: *"DHCP (not running)"*.

::

  [iocage_01]# iocage list -l

.. literalinclude:: out/out-08.txt
   :language: bash

Playbook output - list some iocage_* vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some jails are stopped.

::

  (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-09.txt
   :language: bash


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
