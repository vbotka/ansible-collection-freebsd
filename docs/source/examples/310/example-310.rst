.. _example_310:

310 Role vbotka.freebsd.postinstall
-----------------------------------

.. contents:: Table of Contents
   :depth: 2

.. index:: single: role vbotka.freebsd.postinstall; Example 310


Use case
^^^^^^^^

Audit Ansible clients using the `role vbotka.freebsd.postinstall`_


Tree
^^^^

.. code:: bash

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 02_iocage.yml
   │   └── 99_constructed.yml
   └── pb-test-01.yml


Synopsis
^^^^^^^^

* Playbook  pb-test-01.yml: Audit all running jails.


Requirements
^^^^^^^^^^^^

* running jails at the iocage host.


Notes
^^^^^

* Jail name doesn't work in iocage jails. Use JID instead.

.. seealso::

   * TBD


List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory hosts/02_iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: ini

Inventory hosts/99_constructed.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/99_constructed.yml
    :language: ini

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output. Audit Ansible clients.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-03.txt
    :language: yaml


.. _role vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
