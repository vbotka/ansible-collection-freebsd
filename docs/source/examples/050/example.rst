.. _example_050:

050 Connection jailexec
-----------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: connection vbotka.freebsd.jailexec; Example 050
.. index:: single: vbotka.freebsd.jailexec; Example 050
.. index:: single: jailexec; Example 050

Use case
^^^^^^^^

Test the `connection plugin vbotka.freebsd.jailexec`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 01-iocage.ini
  │   └── 02-iocage.yml
  ├── jailexec.ini
  └── pb.yml

Synopsis
^^^^^^^^

At an iocage node test the `connection plugin vbotka.freebsd.jailexec`_

Requirements
^^^^^^^^^^^^

TBD

Notes
^^^^^

* The jails are not dynamically updated in the inventory file ``jailexec.ini``.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini
   :caption:

Inventory of iocage nodes
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01-iocage.ini
   :language: yaml
   :caption:

Dynamic inventory of the jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02-iocage.yml
   :language: yaml
   :caption:

Inventory jailexec.ini
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: jailexec.ini
   :language: ini
   :caption:

Display the inventory of jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory --list --yaml

.. literalinclude:: out/out-01.txt
   :language: yaml

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i jailexec.ini pb.yml

.. literalinclude:: out/out-02.txt
   :language: yaml

.. _connection plugin vbotka.freebsd.jailexec: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/connection/jailexec/
