.. _example_300:

300 Module vbotka.freebsd.service
---------------------------------

.. contents:: Table of Contents
   :depth: 2

.. index:: single: module vbotka.freebsd.service; Example 300
.. index:: single: module community.general.ini; Example 300
.. index:: single: filter vbotka.freebsd.iocage; Example 300
.. index:: single: inventory vbotka.freebsd.iocage; Example 300


Use case
^^^^^^^^

Test the `module vbotka.freebsd.service`_


Tree
^^^^

.. code:: bash

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 02_iocage.yml
   │   └── 99_constructed.yml
   ├── iocage-hosts.ini
   ├── pb-test-01.yml
   ├── pb-test-02.yml
   └── pb-test-03.yml


Synopsis
^^^^^^^^

* Playbook  pb-test-01.yml: display sshd rcvar on all running jails.
* Playbook  pb-test-02.yml: display sshd rcvar on jails running at the iocage host.
* Playbook  pb-test-03.yml: display enabled services on jails running at the iocage host.


Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.service`_
* `filter vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* running jails at the iocage host.


Notes
^^^^^

* Jail name doesn't work in iocage jails. Use JID instead.

.. seealso::

   * `man service`_


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

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output. Get running jails sshd rcvar.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-03.txt
    :language: yaml

Playbook *pb-test-02.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
    :language: yaml

Playbook output. Set dictionary jid_rcvar.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-04.txt
    :language: yaml

Playbook *pb-test-03.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-03.yml
    :language: yaml

Playbook output. Set dictionary jid_service_enabled.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-05.txt
    :language: yaml

.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/
.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _man service: https://man.freebsd.org/cgi/man.cgi?service(8)
