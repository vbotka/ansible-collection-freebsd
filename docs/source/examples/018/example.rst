.. _example_018:

018 Clone basejails. Use DHCP.
------------------------------

Extending :ref:`example_010`.

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

* On two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage-clone-list.yml``, use the `module vbotka.freebsd.iocage`_ to:

  * Clone 3 jails from the basejail ``ansible_client``
  * Start all jails
  * Display lists of jails

* On the iocage host ``iocage_02``:

  In the playbook ``pb-test.yml``, use the `inventory plugin vbotka.freebsd.iocage`_ to:

  * Create inventory groups and compose variables
  * Display the hosts and composed variables in the group ``test``

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* Jails ``ansible_client`` created in :ref:`example_010`

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
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-iocage-clone-list.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone-list.yml
   :language: yaml+jinja

Playbook output - Clone, start, and list
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
root)``. Also enable ``sudo_preserve_env: true`` if ``env`` is used.

.. literalinclude:: iocage.yml
   :language: yaml+jinja
   :emphasize-lines: 4,5

.. hint::

   * Optionally, limit admin sudo access to the command ``iocage list``::

       shell> grep iocage /usr/local/etc/sudoers
       admin ALL=(ALL) NOPASSWD:SETENV: /usr/local/bin/iocage list*

   * The ``SETENV`` tag, to preserve the environment, is needed when ``env`` is used.

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i iocage.yml --list --yaml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display iocage_* variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

If a jail is stopped, the IP4 column displays: ``DHCP (not running)``.

.. code-block:: console

   [iocage_02]# iocage stop test_112 test_113

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-08.txt
   :language: bash

Playbook output - Display iocage_* variables (stopped jails)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i iocage.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:


.. _iocage: https://www.freshports.org/sysutils/iocage/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/