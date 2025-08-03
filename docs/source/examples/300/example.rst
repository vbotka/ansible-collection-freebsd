.. _example_300:

300 Module vbotka.freebsd.service
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.service; Example 300
.. index:: single: vbotka.freebsd.service; Example 300
.. index:: single: module community.general.ini; Example 300
.. index:: single: filter vbotka.freebsd.iocage; Example 300
.. index:: single: inventory vbotka.freebsd.iocage; Example 300

Use case
^^^^^^^^

Test the `module vbotka.freebsd.service`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test-01.yml
  ├── pb-test-02.yml
  ├── pb-test-03.yml
  ├── pb-test-04.yml
  ├── pb-test-05.yml
  ├── pb-test-06.yml
  └── pb-test-07.yml

Synopsis
^^^^^^^^

At all running jails:

  * playbook ``pb-test-01.yml``: display sshd rcvar.

At ``iocage_02`` jails:

  * playbook ``pb-test-02.yml``: display sshd rcvar
  * playbook ``pb-test-03.yml``: display enabled services
  * playbook ``pb-test-04.yml``: display sshd status
  * playbook ``pb-test-05.yml``: display sshd commands synopsis
  * playbook ``pb-test-06.yml``: display sendmail rcvars.

At ``iocage_03``:

  * playbook ``pb-test-07.yml``: start apcupsd.

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

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-02.txt
   :language: bash

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - get running jails sshd rcvar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The key and value of ``rcvar`` is returned in 1) the attribute ``rcvar`` of the registered variable
``out.rcvar`` and in 2) the ``stdout``. Usually, you'll use the first option. The second option shows
how to use the filter``community.general.jc``.

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
   :language: yaml

Playbook output - create dictionary jid_rcvar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-02.yml -i iocage.ini -l iocage_02 -e debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook pb-test-03.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-03.yml
   :language: yaml

Playbook output - display enabled services
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-03.yml -i iocage.ini -l iocage_02 -e debug=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-test-04.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-04.yml
   :language: yaml

Playbook output - display sshd status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-04.yml -i iocage.ini -l iocage_02

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook pb-test-05.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-05.yml
   :language: yaml

Playbook output - display sshd commands synopsis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-05.yml -i iocage.ini -l iocage_02

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Playbook pb-test-06.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-06.yml
   :language: yaml

Playbook output - display sendmail rcvars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-playbook pb-test-06.yml -i hosts

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

Playbook pb-test-07.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-07.yml
   :language: yaml

Playbook output - start apcupsd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-07.yml -i iocage.ini

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:

.. _module vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/
.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _man service: https://man.freebsd.org/cgi/man.cgi?service(8)
