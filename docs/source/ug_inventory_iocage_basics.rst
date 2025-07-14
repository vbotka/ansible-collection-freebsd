Basics
^^^^^^

As root at the iocage host, create three `VNET jails`_ with a DHCP interface from the template
``ansible_client``

.. code-block:: console
   :emphasize-lines: 1,3,5

   shell> iocage create --template ansible_client --name srv_1 bpf=1 dhcp=1 vnet=1
   srv_1 successfully created!
   shell> iocage create --template ansible_client --name srv_2 bpf=1 dhcp=1 vnet=1
   srv_2 successfully created!
   shell> iocage create --template ansible_client --name srv_3 bpf=1 dhcp=1 vnet=1
   srv_3 successfully created!

.. seealso::

   `Configuring a VNET Jail`_

As admin at the controller, list the jails

.. code-block:: console
   :emphasize-lines: 1

   (env) > ssh admin@10.1.0.73 iocage list -l
   +------+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID  | NAME  | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +======+=======+======+=======+======+=================+====================+=====+================+==========+
   | None | srv_1 | off  | down  | jail | 14.2-RELEASE-p3 | DHCP (not running) | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | None | srv_2 | off  | down  | jail | 14.2-RELEASE-p3 | DHCP (not running) | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | None | srv_3 | off  | down  | jail | 14.2-RELEASE-p3 | DHCP (not running) | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+--------------------+-----+----------------+----------+

Create the inventory configuration ``hosts/02_iocage.yml``

.. code-block:: yaml

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin

Display the inventory

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
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (not running)
             iocage_ip6: '-'
             iocage_jid: None
             iocage_release: 14.2-RELEASE-p3
             iocage_state: down
             iocage_template: ansible_client
             iocage_type: jail
           srv_2:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (not running)
             iocage_ip6: '-'
             iocage_jid: None
             iocage_release: 14.2-RELEASE-p3
             iocage_state: down
             iocage_template: ansible_client
             iocage_type: jail
           srv_3:
             iocage_basejail: 'no'
             iocage_boot: 'off'
             iocage_ip4: '-'
             iocage_ip4_dict:
               ip4: []
               msg: DHCP (not running)
             iocage_ip6: '-'
             iocage_jid: None
             iocage_release: 14.2-RELEASE-p3
             iocage_state: down
             iocage_template: ansible_client
             iocage_type: jail

Optionally, create `Shared IP jails`_

.. code-block:: console
   :emphasize-lines: 1,3,5

   shell> iocage create --template ansible_client --name srv_1 ip4_addr="em0|10.1.0.101/24"
   srv_1 successfully created!
   shell> iocage create --template ansible_client --name srv_2 ip4_addr="em0|10.1.0.102/24"
   srv_2 successfully created!
   shell> iocage create --template ansible_client --name srv_3 ip4_addr="em0|10.1.0.103/24"
   srv_3 successfully created!

.. code-block:: console
   :emphasize-lines: 1

    shell> iocage list -l
   +------+-------+------+-------+------+-----------------+-------------------+-----+----------------+----------  +
   | JID  | NAME  | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL   |
   +======+=======+======+=======+======+=================+===================+=====+================+==========+
   | None | srv_1 | off  | down  | jail | 14.2-RELEASE-p3 | em0|10.1.0.101/24 | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
   | None | srv_2 | off  | down  | jail | 14.2-RELEASE-p3 | em0|10.1.0.102/24 | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
   | None | srv_3 | off  | down  | jail | 14.2-RELEASE-p3 | em0|10.1.0.103/24 | -   | ansible_client | no       |
   +------+-------+------+-------+------+-----------------+-------------------+-----+----------------+----------+

.. seealso::

   `Configuring a Shared IP Jail`_

.. hint::
     
   If iocage needs environment variable(s), use the parameter `env`_. For example,

   .. code-block:: yaml
   
      plugin: vbotka.freebsd.iocage
      host: 10.1.0.73
      user: admin
      env:
        CRYPTOGRAPHY_OPENSSL_NO_LEGACY: 1


.. _Configuring a VNET Jail: https://iocage.readthedocs.io/en/latest/networking.html#configuring-a-vnet-jail
.. _VNET jails: https://iocage.readthedocs.io/en/latest/networking.html#configuring-a-vnet-jail
.. _Configuring a Shared IP Jail: https://iocage.readthedocs.io/en/latest/networking.html#configuring-a-shared-ip-jail
.. _Shared IP jails: https://iocage.readthedocs.io/en/latest/networking.html#configuring-a-shared-ip-jail

.. _env: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage#parameters
