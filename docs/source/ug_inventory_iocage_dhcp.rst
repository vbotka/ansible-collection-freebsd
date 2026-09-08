DHCP
^^^^

As root on the iocage host, start the jails:

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage start ALL
   No default gateway found for ipv6.
   * Starting srv_1
     + Started OK
     + Using devfs_ruleset: 1000 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.183/24
   No default gateway found for ipv6.
   * Starting srv_2
     + Started OK
     + Using devfs_ruleset: 1001 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.204/24
   No default gateway found for ipv6.
   * Starting srv_3
     + Started OK
     + Using devfs_ruleset: 1002 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.169/24
   Please convert back to a jail before trying to start ansible_client

List the running jails:

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage list -l
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID | NAME  | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+=======+======+=======+======+=================+====================+=====+================+==========+
   | 204 | srv_1 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.183 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 205 | srv_2 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.204 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 206 | srv_3 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.169 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+

As admin on the control node, query the jail list without root privileges. Note
that the ``IP4`` column indicates that reading DHCP addresses requires root
access:

.. code-block:: console
   :emphasize-lines: 1

   (env) > ssh admin@10.1.0.73 iocage list -l
   +-----+-------+------+-------+------+-----------------+-----------------------------------------+-----+----------------+----------+
   | JID | NAME  | BOOT | STATE | TYPE |     RELEASE     |                   IP4                   | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+=======+======+=======+======+=================+=========================================+=====+================+==========+
   | 204 | srv_1 | off  | up    | jail | 14.2-RELEASE-p3 | DHCP (running -- address requires root) | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+-----------------------------------------+-----+----------------+----------+
   | 205 | srv_2 | off  | up    | jail | 14.2-RELEASE-p3 | DHCP (running -- address requires root) | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+-----------------------------------------+-----+----------------+----------+
   | 206 | srv_3 | off  | up    | jail | 14.2-RELEASE-p3 | DHCP (running -- address requires root) | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+-----------------------------------------+-----+----------------+----------+

Run the command with ``sudo`` to display the IP addresses:

.. code-block:: console
   :emphasize-lines: 1

   (env) > ssh admin@10.1.0.73 sudo iocage list -l
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID | NAME  | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+=======+======+=======+======+=================+====================+=====+================+==========+
   | 204 | srv_1 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.183 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 205 | srv_2 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.204 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 206 | srv_3 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.169 | -   | ansible_client | no       |
   +-----+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+

Update the inventory configuration file ``hosts/02_iocage.yml`` to enable the
``sudo`` parameter:

.. code-block:: yaml
   :emphasize-lines: 4

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   sudo: true

Display the inventory:

.. code-block:: console

   (env) > ansible-inventory -i hosts/02_iocage.yml --list --yaml

.. code-block:: yaml

   all:
     children:
       ungrouped:
         hosts:
           srv_1:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_ip4: 10.1.0.183
             iocage_ip4_dict:
               ip4:
               - ifc: epair0b
                 ip: 10.1.0.183
                 mask: '-'
               msg: ''
             iocage_ip6: '-'
             iocage_jid: '204'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail
           srv_2:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_ip4: 10.1.0.204
             iocage_ip4_dict:
               ip4:
               - ifc: epair0b
                 ip: 10.1.0.204
                 mask: '-'
               msg: ''
             iocage_ip6: '-'
             iocage_jid: '205'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail
           srv_3:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_ip4: 10.1.0.169
             iocage_ip4_dict:
               ip4:
               - ifc: epair0b
                 ip: 10.1.0.169
                 mask: '-'
               msg: ''
             iocage_ip6: '-'
             iocage_jid: '206'
             iocage_release: 14.2-RELEASE-p3
             iocage_state: up
             iocage_template: ansible_client
             iocage_type: jail

If the ``env`` parameter is defined and ``sudo`` is enabled, also enable
``sudo_preserve_env``:

.. code-block:: yaml
   :emphasize-lines: 6-7

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   env:
     CRYPTOGRAPHY_OPENSSL_NO_LEGACY: 1
   sudo: true
   sudo_preserve_env: true

In this case, verify that the user's sudoers entry includes the ``SETENV`` tag:

.. code-block:: console
   :emphasize-lines: 1

   (env) > ssh admin@10.1.0.73 sudo cat /usr/local/etc/sudoers | grep admin
   admin ALL=(ALL) NOPASSWD:SETENV: ALL
