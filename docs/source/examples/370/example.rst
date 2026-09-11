.. _example_370:

370 Configure pf
----------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pf; Example 370
.. index:: single: firewall; Example 370
.. index:: single: role vbotka.freebsd.pf; Example 370
.. index:: single: vbotka.freebsd.pf; Example 370

.. index:: single: blacklistd; Example 370
.. index:: single: fail2ban; Example 370
.. index:: single: sshguard; Example 370
.. index:: single: NAT; Example 370

Use case
^^^^^^^^

Use the role `vbotka.freebsd.pf`_ to configure pf.

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

* The Ansible controller connects to the iocage host ``iocage_04`` at
  IP 10.1.0.29 configured in ``/etc/rc.conf``:

  .. code-block:: ini

     cloned_interfaces="bridge0"
     create_args_bridge0="addm igb0"
     ifconfig_bridge0="inet 10.1.0.29/24"
     ifconfig_igb0="up -tso -vlanhwtso"

* In the playbook ``pb.yml`` for ``iocage_04``, configure:

  * blacklistd, fail2ban, and sshguard
  * NAT
  * log all blocked
  * pass from localnet to any

Requirements
^^^^^^^^^^^^

* Root privileges on the managed nodes.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.pf`_ is the role **pf** in the collection ``vbotka.freebsd``.
   | `vbotka.freebsd_pf`_ is the role **freebsd_pf** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

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

Starting and restarting the firewall breaks active SSH connections
(see the handlers for details).  Consequently, both the start and
reload handlers can fail to complete cleanly, causing the SSH session
to go stale. Therefore, configure the rules first before enabling the
service:

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

.. code-block:: console

   (env) > ssh admin@10.1.0.29 sudo service pf status

.. literalinclude:: out/out-04.txt
   :language: bash

/etc/pf.conf
""""""""""""

.. code-block:: console

   (env) > ssh admin@10.1.0.29 cat /etc/pf.conf

.. literalinclude:: out/out-05.txt
   :language: bash
