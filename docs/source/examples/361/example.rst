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
  │   └── iocage_03.yml
  ├── iocage.ini
  ├── pb-network.yml
  └── pb-postinstall.yml

Synopsis
^^^^^^^^

* The Ansible controller connects to the iocage host ``iocage_03`` at
  IP 10.1.0.17 configured in ``/etc/rc.conf`` of the managed node:

  .. code-block:: ini

     defaultrouter="10.1.0.10"
     gateway_enable="YES"
     cloned_interfaces="bridge0"
     create_args_bridge0="addm em0"
     ifconfig_bridge0="inet 10.1.0.17/24"
     ifconfig_em0="up -tso -vlanhwtso"

* The nameserver is 10.1.0.1:

  .. code-block:: console

     shell> cat /etc/resolv.conf
     nameserver 10.1.0.1

     shell> cat /etc/resolvconf.conf
     resolvconf="NO"

* In the playbook ``pb-postinstall.yml`` on ``iocage_03``, ensure the
  nameserver is set to 10.1.0.1.

* In the playbook ``pb-network.yml`` on ``iocage_03``, configure load
  balancing across two NICs.

Requirements
^^^^^^^^^^^^

* Root privileges on the managed nodes.

Notes
^^^^^

The USB NICs ``ue0`` and ``ue1`` are used here for testing. Using them
in production is not recommended. See the FreeBSD Forum thread `rc.d
netif restart lagg0`_ to learn about issues with USB NICs.

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
   :language: yaml+jinja
   :caption:

Playbook pb-postinstall.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-postinstall.yml
   :language: yaml+jinja

Playbook output - Configure resolv.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The tasks ``fp_resolvconf`` configure ``/etc/resolvconf.conf`` and
``/etc/resolv.conf`` using the modules ``community.general.sysrc`` and
``ansible.builtin.lineinfile`` respectively. If you are not sure about
the contents of these files, you may want to clean them before
applying the configuration:

.. code-block:: yaml

   fp_resolvconf_conf_clean: true
   fp_resolv_conf_clean: true

This makes the play non-idempotent. The defaults are ``false``. To
keep the play idempotent, omit these variables.

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t fp_resolvconf \
                            -e fp_resolvconf_conf_clean=true \
                            -e fp_resolv_conf_clean=true \
                            pb-postinstall.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook pb-network.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-network.yml
   :language: yaml+jinja

Playbook output - Configure loadbalance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-network.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Result
^^^^^^

MAC addresses are sanitized.

.. code-block:: console

   (env) > ssh admin@10.1.0.17 ifconfig lagg0

.. literalinclude:: out/out-03.txt
   :language: bash
