.. _example_361:

361 Configure loadbalance
-------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.network; Example 361
.. index:: single: vbotka.freebsd.network; Example 361
.. index:: single: loadbalance; Example 361

Use case
^^^^^^^^

Configure loadbalance using the role `vbotka.freebsd.network`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_03.yml
  ├── iocage-hosts.ini
  ├── pb-network.yml
  └── pb-postinstall.yml

Synopsis
^^^^^^^^

* The Ansible controller connects the iocage host *iocage_03* at IP
  10.1.0.17 configured in /etc/rc.conf ::

    defaultrouter="10.1.0.10"
    gateway_enable="YES"
    ifconfig_em0="inet 10.1.0.17 netmask 255.255.255.0"

  The nameserver is 10.1.0.1 ::

    shell> cat /etc/resolv.conf
    nameserver 10.1.0.1
    shell> cat /etc/resolvconf.conf
    resolvconf="NO"

* In the playbook *pb-postinstall.yml* at *iocage_03* make sure the nameserver is 10.1.0.1.

* In the playbook *pb-network.yml* at *iocage_03* configure loadbalance of three NICs.
    
Requirements
^^^^^^^^^^^^

* root privilege on the iocage host.

Notes
^^^^^

TBD

.. seealso::

   * `Link Aggregation and Failover`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_03.yml
    :language: yaml
    :caption:

Playbook pb-postinstall.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-postinstall.yml
    :language: yaml

Playbook output - configure resolv.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-postinstall.yml -i iocage-hosts.ini -l iocage_03 \
                                              -t fp_resolvconf \
					      -e fp_resolvconf_conf_clean=true \
					      -e fp_resolv_conf_clean=true

.. literalinclude:: out/out-01.txt
    :language: bash

Playbook pb-network.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-network.yml
    :language: yaml

Playbook output - configure loadbalance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-network.yml -i iocage-hosts.ini -l iocage_03

.. literalinclude:: out/out-02.txt
    :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _Link Aggregation and Failover: https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-aggregation
