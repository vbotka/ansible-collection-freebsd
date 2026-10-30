.. _example_370:

370 Configure pf
----------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: pf; Example 370
   single: /etc/pf.conf; Example 370
   single: firewall; Example 370
   single: role vbotka.freebsd.pf; Example 370
   single: vbotka.freebsd.pf; Example 370
   single: blacklistd; Example 370
   single: fail2ban; Example 370
   single: sshguard; Example 370
   single: NAT; Example 370

Use case
^^^^^^^^

Use the role `vbotka.freebsd.pf`_ to configure `Packet Filter (PF)`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_04.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * The Ansible controller connects to the iocage host ``iocage_04`` at
    IP 10.1.0.29 configured in ``/etc/rc.conf``:

    .. code-block:: ini

       cloned_interfaces="bridge0"
       create_args_bridge0="addm igb0"
       ifconfig_bridge0="inet 10.1.0.29/24"
       ifconfig_igb0="up -tso -vlanhwtso"

  * In the playbook ``pb.yml``, configure:

    * `blacklistd`_, `fail2ban`_, and `sshguard`_
    * `NAT`_
    * Log all blocked packets
    * Pass traffic from ``localnet`` to any destination

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.pf`_
* Root privileges on the managed nodes.

Notes
^^^^^

* The network routes internal traffic through a bridged interface (``bridge0``
  bridging the physical uplink and local jail networks).

* The filter enforces a default-deny policy.

* Outbound connections, initiated by the host and local subnet (10.1.0.0/24),
  generate state table entries for two-way communication.

* Inbound flow requires stateful permissions.

* Perimeter defense: failed connection attempts and authentication abuses
  trigger host-level daemons (``blacklistd``, ``fail2ban``, and ``sshguard``) that inject
  offending source addresses into PF tables and anchors to isolate threats.

.. note::

   | `vbotka.freebsd.pf`_ is the role **pf** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_pf`_ is the role **freebsd_pf** in the namespace `vbotka`_.

.. seealso::

   * FreeBSD Handbook `Firewalls`_
   * FreeBSD Forum `pf and bridge`_
   * `man 4 if_bridge`_

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

.. literalinclude:: host_vars/iocage_04.yml
   :language: yaml+jinja
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t pf_packages -e pf_install=true \
                            pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook output - Configure pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting and restarting the firewall breaks active SSH connections (see the
handlers for details). Consequently, both the start and reload handlers can
fail to complete cleanly, causing the SSH session to go stale. Therefore,
configure the rules first before enabling the service:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -e pf_enable=false pb.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Playbook output - Enable pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t pf_rcconf_pf pb.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Result
^^^^^^

pf status
"""""""""

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_04]# service pf status

/etc/pf.conf
""""""""""""


.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: [iocage_04]# cat /etc/pf.conf
