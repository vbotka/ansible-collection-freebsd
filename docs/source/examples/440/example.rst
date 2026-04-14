.. _example_440:

440 Configure DHCP
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: DHCP; Example 440
.. index:: single: bridge; Example 440
.. index:: single: wlan; Example 440
.. index:: single: pf; Example 440
.. index:: single: pf port redirection; Example 440
.. index:: single: port redirection; Example 440
.. index:: single: redirection of ports; Example 440
.. index:: single: forwarding of ports; Example 440
.. index:: single: firewall; Example 440
.. index:: single: role vbotka.freebsd.dhcp; Example 440
.. index:: single: role vbotka.freebsd.pf; Example 440
.. index:: single: vbotka.freebsd.dhcp; Example 440
.. index:: single: vbotka.freebsd.pf; Example 440


Use case
^^^^^^^^

Use the role `vbotka.freebsd.dhcp`_ to configure DHCP. Use the role `vbotka.freebsd.pf`_ to
configure pf. Redirect the ports from the local network to the SSH in the jails.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pf-rdr-ssh.conf
  ├── host_vars
  │   └── iocage_05
  │       ├── dhcp.yml
  │       └── pf.yml
  ├── iocage.ini
  ├── pb-dhcp.yml
  ├── pb-pf-setup.yml
  └── pb-pf.yml

Synopsis
^^^^^^^^

* The Ansible controller connects the iocage host ``iocage_05`` at the wlan interface configured in
  ``/etc/rc.conf``

  .. code-block:: ini

    gateway_enable="YES"
    defaultrouter="192.168.1.1"
    cloned_interfaces="bridge0"
    ifconfig_bridge0="inet 192.168.99.1/24"
    wlans_iwm0="wlan0"
    create_args_wlan0="country US"
    ifconfig_wlan0="WPA SYNCDHCP"
    dhcpd_ifaces="bridge0"

* In the playbook ``pb-dhcp.yml`` at ``iocage_05`` configure:

  * subnet 192.168.99.0/24
  * routers [192.168.99.1]
  * range 100-200

* In the playbook ``pb-pf.yml`` at ``iocage_05`` configure:

  * blacklistd, fail2ban, and sshguard
  * nat
  * log all blocked
  * allow SSH from the external network
  * pass from localnet and jails' vnet to any
  * redirect ssh ports to jails
    
Requirements
^^^^^^^^^^^^

* root privilege in the managed nodes.

Notes
^^^^^

* In this example, a cheap HW connected via WiFi is used for the iocage server
  testing.

* Change this to fit the configuration to your needs:

  * ``/etc/rc.conf`` :

    * defaultrouter
    * ifconfig_bridge0

  * ``dhcp.yml`` :

    * bsd_dhcpd_subnet
    * bsd_dhcpd_subnet_from
    * bsd_dhcpd_subnet_to
    * bsd_dhcpd_routers

  * ``pf.yml`` :

    * pf_local_net
    * pf_jail_net
    * pf_ssh_redirected_ports

.. note::

   | `vbotka.freebsd.dhcp`_ is the role **dhcp** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_dhcp`_ is the role **freebsd_dhcp** in the namespace `vbotka`_.
   | `vbotka.freebsd.pf`_ is the role **pf** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_pf`_ is the role **freebsd_pf** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * FreeBSD Handbook `Installing and Configuring a DHCP Server`_
   * FreeBSD Handbook `Firewalls`_
   * FreeBSD Forum `pf and bridge`_
   * `man 4 if_bridge`_
   * `Dell XPS 13 9365 15.0-RELEASE dmesg`_ used as ``iocage_05``

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

files
^^^^^

.. literalinclude:: files/pf-rdr-ssh.conf
   :lines: 1-10
   :language: console
   :caption:

.. note::

   * The above listing is limited to the first 10 lines.
   * See the playbook ``pb-pf-setup.yml`` below how to create the file.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/dhcp.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_05/pf.yml
   :language: yaml
   :caption:

Playbook pb-dhcp.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-dhcp.yml
   :language: yaml

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-dhcp.yml -i iocage.ini -t bsd_dhcpd_packages -e bsd_dhcpd_install=true

.. literalinclude:: out/out-11.txt
   :language: yaml
   :force:

Playbook output - Configure DHCP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-dhcp.yml -i iocage.ini

.. literalinclude:: out/out-12.txt
   :language: yaml
   :force:

Playbook pb-pf-setup.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pf-setup.yml
   :language: yaml

Playbook output - Create files/pf-rdr-ssh.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-pf-setup.yml -i iocage.ini

.. literalinclude:: out/out-13.txt
   :language: yaml
   :force:

Playbook pb-pf.yml
^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pf.yml
   :language: yaml

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-pf.yml -i iocage.ini -t pf_packages -e pf_install=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - Configure pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Firewall starting and restarting breaks the ssh connections. See the handlers for details. As a
consequence, both handlers starting and reloading don't work properly and the ssh connection will
stale. Therefore, let us first configure the rules

.. code-block:: console

   (env) > ansible-playbook pb-pf.yml -i iocage.ini -e pf_enable=false

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - Enable pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-pf.yml -i iocage.ini -t pf_rcconf_pf

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Results
^^^^^^^

isc-dhcpd status
""""""""""""""""

.. code-block:: console

   (env) > ssh admin@handy sudo service isc-dhcpd status

.. literalinclude:: out/out-14.txt
   :language: bash

/usr/local/etc/dhcpd.conf
"""""""""""""""""""""""""

.. code-block:: console

   (env) > ssh admin@handy cat /usr/local/etc/dhcpd.conf

.. literalinclude:: out/out-15.txt
   :language: bash

pf status
"""""""""

.. code-block:: console

   (env) > ssh admin@handy sudo service pf status

.. literalinclude:: out/out-04.txt
   :language: bash

/etc/pf.conf
""""""""""""

.. code-block:: console

   (env) > ssh admin@handy cat /etc/pf.conf

.. literalinclude:: out/out-05.txt
   :language: bash

List jails
""""""""""

.. code-block:: console

   (env) > ssh admin@handy sudo iocage list -l

.. literalinclude:: out/out-16.txt
   :language: console

SSH to a jail
"""""""""""""

.. code-block:: console

   (env) > ssh -p 2200 admin@handy

.. literalinclude:: out/out-17.txt
   :language: console
     
.. _vbotka.freebsd.dhcp: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/dhcp/
.. _vbotka.freebsd_dhcp: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_dhcp/
.. _vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/
.. _vbotka.freebsd_pf: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_pf/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _Installing and Configuring a DHCP Server: https://docs.freebsd.org/en/books/handbook/network-servers/#network-dhcp-server
.. _Firewalls: https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-intro
.. _pf and bridge: https://forums.freebsd.org/threads/pf-and-bridge-4.77952/
.. _man 4 if_bridge: https://man.freebsd.org/cgi/man.cgi?query=if_bridge

.. _Dell XPS 13 9365 15.0-RELEASE dmesg: http://dmesgd.nycbug.org/index.cgi?do=view&id=8848
