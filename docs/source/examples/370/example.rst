.. _example_370:

370 Configure pf
----------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.pf; Example 370
.. index:: single: vbotka.freebsd.pf; Example 370
.. index:: single: firewall; Example 370
.. index:: single: pf; Example 370
.. index:: single: blacklistd; Example 370
.. index:: single: fail2ban; Example 370
.. index:: single: sshguard; Example 370
.. index:: single: NAT; Example 370

Use case
^^^^^^^^

Configure pf using the role `vbotka.freebsd.pf`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── iocage_03.yml
  ├── iocage-hosts.ini
  └── pb.yml

Synopsis
^^^^^^^^

* The Ansible controller connects the iocage host ``iocage_03`` at IP 10.1.0.17 configured in
  /etc/rc.conf ::

    defaultrouter="10.1.0.10"
    gateway_enable="YES"
    ifconfig_em0="inet 10.1.0.17 netmask 255.255.255.0"

* In the playbook ``pb.yml`` at ``iocage_03`` configure:

  * blacklistd, fail2ban, and sshguard
  * nat
  * log all blocked
  * pass from localnet to any
    
Requirements
^^^^^^^^^^^^

* root privilege in the managed nodes.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.pf`_ is the role **pf** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_pf`_ is the role **freebsd_pf** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * FreeBSD Handbook `Firewalls`_

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

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install packages

.. code-block:: console

   (env) > ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -t pf_packages -e pf_install=true

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - configure pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting and restarting of the firewall breaks the ssh connections. See the handlers for details. As
a consequence, both handlers starting and reloading don't work properly and the ssh connection will
stale. Therefore, let us first configure the rules

.. code-block:: console

   (env) > ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -e pf_enable=false

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output - enable pf
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i iocage-hosts.ini -l iocage_03 -t pf_rcconf_pf

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Result
^^^^^^

pf status
"""""""""

.. code-block:: console

   (env) > ssh admin@10.1.0.17 sudo service pf status

.. literalinclude:: out/out-04.txt
   :language: bash

/etc/pf.conf
""""""""""""

.. code-block:: console

   (env) > ssh admin@10.1.0.17 cat /etc/pf.conf

.. literalinclude:: out/out-05.txt
   :language: bash

     
.. _vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf/
.. _vbotka.freebsd_pf: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_pf/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _Firewalls: https://docs.freebsd.org/en/books/handbook/firewalls/#firewalls-intro
