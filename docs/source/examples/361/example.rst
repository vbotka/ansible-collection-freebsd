.. _example_361:

361 Configure loadbalance
-------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: network; Example 361
.. index:: single: loadbalance; Example 361
.. index:: single: role vbotka.freebsd.network; Example 361
.. index:: single: vbotka.freebsd.network; Example 361

Use case
^^^^^^^^

Use the role `vbotka.freebsd.network`_ to configure ``loadbalance``.

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

* The Ansible controller connects the iocage host ``iocage_03`` at IP 10.1.0.17 configured in
  ``/etc/rc.conf`` of the managed node

  .. code-block:: ini

     defaultrouter="10.1.0.10"
     gateway_enable="YES"
     cloned_interfaces="bridge0"
     create_args_bridge0="addm em0"
     ifconfig_bridge0="inet 10.1.0.17/24"
     ifconfig_em0="up -tso -vlanhwtso"

* The nameserver is 10.1.0.1

  .. code-block:: console

     shell> cat /etc/resolv.conf
     nameserver 10.1.0.1

     shell> cat /etc/resolvconf.conf
     resolvconf="NO"

* In the playbook ``pb-postinstall.yml`` at ``iocage_03`` make sure the nameserver is 10.1.0.1

* In the playbook ``pb-network.yml`` at ``iocage_03`` configure loadbalance of two NICs.
    
Requirements
^^^^^^^^^^^^

* root privilege in the managed nodes.

Notes
^^^^^

The USB NICs ``ue0`` and ``ue1`` are used here for testing. It is not recommended to use them in
production. See FreeBSD Forum thread `rc.d netif restart lagg0`_ to learn about the USB NICs
problems.

.. seealso::

   * `Link Aggregation and Failover`_
   * `Wired Networks`_
   * `man ifconfig`_

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

.. literalinclude:: host_vars/iocage_03.yml
   :language: yaml
   :caption:

Playbook pb-postinstall.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-postinstall.yml
   :language: yaml

Playbook output - configure resolv.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The tasks ``fp_resolvconf`` configure ``/etc/resolvconf.conf`` and ``/etc/resolv.conf`` using the
modules ``community.general.sysrc`` and ``ansible.builtin.lineinfile`` respectively. If you're not
sure about the content of these files, you might want to clean the content before the configuration

.. code-block:: yaml

   fp_resolvconf_conf_clean: true
   fp_resolv_conf_clean: true

This makes the play not idempotent. The defaults are ``false``. To make the play idempotent, omit
these variables at your own discretion.

.. code-block:: console

   (env) > ansible-playbook pb-postinstall.yml -i iocage.ini \
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

.. code-block:: console

   (env) > ansible-playbook pb-network.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Result
^^^^^^

MACs are sanitized.

.. code-block:: console

   (env) > ssh admin@10.1.0.17 ifconfig lagg0

.. literalinclude:: out/out-03.txt
   :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _Link Aggregation and Failover: https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-aggregation
.. _Wired Networks: https://docs.freebsd.org/en/books/handbook/network/#config-network-connection
.. _man ifconfig: https://man.freebsd.org/cgi/man.cgi?query=ifconfig
.. _rc.d netif restart lagg0: https://forums.freebsd.org/threads/rc-d-netif-restart-lagg0-and-pf.95879/
