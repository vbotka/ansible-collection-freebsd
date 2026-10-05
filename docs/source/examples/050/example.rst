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

* Manually create and start jails. Update the inventory file ``hosts``.

* Test the :ref:`connection plugin vbotka.freebsd.jailexec
  <ug_connection_jailexec>`.

Requirements
^^^^^^^^^^^^

* :ref:`Connection plugin vbotka.freebsd.jailexec <ug_connection_jailexec>`

Notes
^^^^^

* TBD

Manually create the jails
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage create --short --count 3 --template ansible-client bpf=1 dhcp=1 vnet=1 boot=1
   e712848e successfully created!
   No default gateway found for ipv6.
   * Starting e712848e
     + Started OK
     + Using devfs_ruleset: 1000 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 172.16.99.168/24
   de9c03ab successfully created!
   No default gateway found for ipv6.
   * Starting de9c03ab
     + Started OK
     + Using devfs_ruleset: 1001 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 172.16.99.167/24
   bbf40e62 successfully created!
   No default gateway found for ipv6.
   * Starting bbf40e62
     + Started OK
     + Using devfs_ruleset: 1002 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 172.16.99.142/24

   [iocage_06]# iocage list -l
   +-----+---------------+------+-------+------+-----------------+-----------------------+-----+------------------+----------+
   | JID |     NAME      | BOOT | STATE | TYPE |     RELEASE     |          IP4          | IP6 |     TEMPLATE     | BASEJAIL |
   +=====+===============+======+=======+======+=================+=======================+=====+==================+==========+
   | 12  | bbf40e62      | on   | up    | jail | 15.1-RELEASE-p1 | epair0b|172.16.99.142 | -   | ansible-client   | no       |
   +-----+---------------+------+-------+------+-----------------+-----------------------+-----+------------------+----------+
   | 11  | de9c03ab      | on   | up    | jail | 15.1-RELEASE-p1 | epair0b|172.16.99.167 | -   | ansible-client   | no       |
   +-----+---------------+------+-------+------+-----------------+-----------------------+-----+------------------+----------+
   | 10  | e712848e      | on   | up    | jail | 15.1-RELEASE-p1 | epair0b|172.16.99.168 | -   | ansible-client   | no       |
   +-----+---------------+------+-------+------+-----------------+-----------------------+-----+------------------+----------+

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

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Test jailexec
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
