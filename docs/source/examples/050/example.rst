.. _example_050:

050 Connection jailexec
-----------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: connection vbotka.freebsd.jailexec; Example 050
   single: vbotka.freebsd.jailexec; Example 050
   single: jailexec; Example 050

Use case
^^^^^^^^

Test the :ref:`connection plugin vbotka.freebsd.jailexec <ug_connection_jailexec>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Manually create and start jails.

  * Manually update the variables ``ansible_jail_*`` in the inventory file
    ``hosts``.

  * In the playbook ``pb.yml``, test the connection.

Requirements
^^^^^^^^^^^^

* :ref:`ug_connection_jailexec`
* Templates created in :ref:`example_202`

Notes
^^^^^

* TBD.

Manually create the jails
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_05]# iocage create --short -c 3 -t ansible-client  dhcp=1 vnet=1 boot=1

   [iocage_05]# iocage list -h
   30   2756b146        up      14.5-RELEASE    DHCP
   28   2e117f73        up      14.5-RELEASE    DHCP
   29   49f92d2a        up      14.5-RELEASE    DHCP
   None ansible-test    down    14.5-RELEASE    DHCP

.. seealso::

   * :ref:`ug_qa_jid_persistent`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini
   :caption:

hosts
^^^^^

.. literalinclude:: hosts
   :language: ini
   :caption:
   :emphasize-lines: 2-4, 9-11

.. hint::

   For dynamic assignment of the connection variables ``ansible_jail_*`` see:

   * :ref:`example_020`
   * :ref:`example_200`

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Test the connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
