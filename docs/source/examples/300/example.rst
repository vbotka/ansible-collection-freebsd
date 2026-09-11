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
.. index:: single: inventory vbotka.freebsd.iocage2; Example 300
.. index:: single: connection vbotka.freebsd.jailexec; Example 300

Use case
^^^^^^^^

Test the :ref:`ug_module_service`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 06_iocage2.yml
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

In all running jails on the managed node:

* Playbook ``pb-test-01.yml``: Display ``sshd`` ``rcvar``
* Playbook ``pb-test-06.yml``: Display ``sendmail`` ``rcvar``

On the managed node:

* Playbook ``pb-test-02.yml``: Display ``sshd`` ``rcvar``
* Playbook ``pb-test-03.yml``: Display enabled services
* Playbook ``pb-test-04.yml``: Display ``sshd`` status
* Playbook ``pb-test-05.yml``: Display ``sshd`` command synopsis
* Playbook ``pb-test-07.yml``: Start ``apcupsd``

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_service`
* :ref:`ug_filter_iocage`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Running jails on the iocage host

Notes
^^^^^

* Jail names do not work in iocage jails. Use the JID instead.

.. seealso::

   * `man service`_

Jails at managed node
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   # iocage list -l

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

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-02.txt
   :language: bash

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml+jinja

Playbook output - Display sshd rcvar in jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The key and value of ``rcvar`` are returned in 1) the attribute
``rcvar`` of the registered variable ``out.rcvar`` and in 2)
``stdout``. Usually, you will use the first option. The second option
shows how to use the filter ``community.general.jc``.

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-01.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
   :language: yaml+jinja

Playbook output - Create jid_rcvar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -e debug=true pb-test-02.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-03.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-03.yml
   :language: yaml+jinja

Playbook output - Display enabled services
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -e debug=true pb-test-03.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-04.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-04.yml
   :language: yaml+jinja

Playbook output - Display sshd status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test-04.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-05.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-05.yml
   :language: yaml+jinja

Playbook output - Display sshd commands synopsis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test-05.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-06.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-06.yml
   :language: yaml+jinja

Playbook output - Display sendmail rcvar
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-06.yml

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-07.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-07.yml
   :language: yaml+jinja

Playbook output - Start apcupsd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test-07.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:
