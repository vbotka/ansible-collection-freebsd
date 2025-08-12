.. _example_018:

018 Clone basejails. Use DHCP.
------------------------------

Extending example :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.iocage; Example 018
.. index:: single: inventory vbotka.freebsd.iocage; Example 018
.. index:: single: DHCP; Example 018
.. index:: single: SETENV; Example 018
.. index:: single: sudoers; Example 018

.. index:: single: option sudo; Example 018
.. index:: single: sudo; Example 018
.. index:: single: option sudo_preserve_env; Example 018
.. index:: single: sudo_preserve_env; Example 018

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
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  ├── iocage.yml
  ├── pb-iocage-clone-list.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* At two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage-clone-list.yml``, use the `module vbotka.freebsd.iocage`_ to:

  * clone 3 jails from the basejail
  * start all jails
  * display lists of jails.

* At the iocage host ``iocage_02``

  In the playbook ``pb-test.yml``, use the `inventory plugin vbotka.freebsd.iocage`_ to:

  * create the inventory groups and compose variables
  * display the hosts and composed variables in the group ``test``.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails ``ansible_client`` created in :ref:`example_010`

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml
   :caption:

Playbook pb-iocage-clone-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone-list.yml
   :language: yaml

Playbook output - clone, start, and list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-clone-list.yml -i iocage.ini

.. literalinclude:: out/out-03.txt
   :language: bash
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

Enable ``sudo: true``. Otherwise, `iocage`_ will complain ``DHCP (running -- address requires
root)``. Enable also ``sudo_preserve_env: true`` if ``env`` is used.

.. literalinclude:: iocage.yml
   :language: yaml
   :emphasize-lines: 4,5

.. hint::

   * Optionally, limit admins sudo to the command ``iocage list`` ::

       shell> grep iocage /usr/local/etc/sudoers
       admin ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/iocage list*

   * The tag ``SETENV``, to preserve the environment, is needed when ``env`` is used.


Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i iocage.yml --list --yaml

.. literalinclude:: out/out-06.txt
   :language: yaml

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - vars iocage_*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

If a jail is stopped, the IP4 tab says: ``DHCP (not running)``.

.. code-block:: console

   [iocage_02]# iocage stop test_112 test_113

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-08.txt
   :language: bash

Playbook output - vars iocage_*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:


.. _iocage: https://www.freshports.org/sysutils/iocage/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
