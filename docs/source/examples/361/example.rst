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

The USB NICs ue0 and ue1 are used here for testing. It is not recommended to
use them in production. See FreeBSD Forum thread `rc.d netif restart lagg0`_ to
learn about the USB NICs problems.

.. seealso::

   * `Link Aggregation and Failover`_
   * `Wired Networks`_
   * `man ifconfig`_

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

The tasks *fp_resolvconf* configure */etc/resolvconf.conf* and
*/etc/resolv.conf* using the modules *sysrc* and *lineinfile* respectively. If
you're not sure about the content of these files you might want to clean the
content before the configuration ::

  fp_resolvconf_conf_clean: true
  fp_resolv_conf_clean: true

This makes the play not idempotent. The defaults are *false*. To make the play
idempotent, omit these variables according to your own discretion.

::

  (env) > ansible-playbook pb-postinstall.yml -i iocage-hosts.ini -l iocage_03 \
                                              -t fp_resolvconf \
                                              -e fp_resolvconf_conf_clean=true \
                                              -e fp_resolv_conf_clean=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-network.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-network.yml
   :language: yaml

Playbook output - configure loadbalance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-network.yml -i iocage-hosts.ini -l iocage_03

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Result
^^^^^^

MACs are sanitized.

::

  (env) > ssh admin@10.1.0.17 ifconfig -a

.. literalinclude:: out/out-03.txt
   :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _Link Aggregation and Failover: https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-aggregation
.. _Wired Networks: https://docs.freebsd.org/en/books/handbook/network/#config-network-connection
.. _man ifconfig: https://man.freebsd.org/cgi/man.cgi?query=ifconfig
.. _rc.d netif restart lagg0: https://forums.freebsd.org/threads/rc-d-netif-restart-lagg0-and-pf.95879/
