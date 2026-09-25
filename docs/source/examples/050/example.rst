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

Test the :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 01-iocage.ini
  │   └── 02-iocage.yml
  ├── jailexec.ini
  └── pb.yml

Synopsis
^^^^^^^^

On an iocage node, test the :ref:`connection vbotka.freebsd.jailexec
<ug_connection_jailexec>`.

Requirements
^^^^^^^^^^^^

* TBD

Notes
^^^^^

* In this example, the jails are not dynamically updated in the
  inventory file ``jailexec.ini`` below.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini
   :caption:

Inventory of jail hosts
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01-iocage.ini
   :language: ini
   :caption:

Dynamic inventory of jails
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02-iocage.yml
   :language: yaml+jinja
   :caption:

Inventory jailexec.ini
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: jailexec.ini
   :language: ini
   :caption:

Jails
^^^^^

.. code-block:: console

   (env) > ansible-inventory --list --yaml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Test jailexec
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i jailexec.ini pb.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
