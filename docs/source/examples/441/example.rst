.. _example_441:

441 Redirect SSH to jails
-------------------------

| Extending :ref:`example_440`.
| Extending :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 441

.. index:: single: pb_iocage_ansible_clients.yml; Example 441

.. index:: single: option compose; Example 441
.. index:: single: compose; Example 441

.. index:: single: option defaultrouter; Example 441
.. index:: single: defaultrouter; Example 441

.. index:: single: variable iocage_tags; Example 441
.. index:: single: iocage_tags; Example 441

.. index:: single: option iocage --count; Example 441
.. index:: single: option iocage --short; Example 441
.. index:: single: option iocage --template; Example 441

.. index:: single: pf port redirection; Example 441
.. index:: single: port redirection; Example 441
.. index:: single: redirection of ports; Example 441

Use case
^^^^^^^^

Create multiple jails with auto UUID names. In the inventory, compose the variables
``ansible_host`` and ``ansible_port`` to connect to the jails via redirected SSH
ports. See :ref:`example_440` for how ``pf`` is configured.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project-hosts.yml
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   └── iocage_06.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_:

  * create jails
  * start jails
  * optionally, stop and destroy the jails.

* Create a dynamic inventory to redirect SSH to the jails.

* For all created jails:

  In the playbook ``pb-test.yml``:

  * connect to the created jails
  * display the basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* Playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage2`_
* Root privileges on the managed nodes.
* Template ``ansible_client`` created in :ref:`example_202`.

Notes
^^^^^

The only difference between this example and :ref:`example_442` is
the following two lines in the inventory configuration file:

.. code-block:: yaml

   ansible_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm
   ansible_port: iocage_ip4 | split('.') | last | int - 100 + 2200

.. seealso::

   Example :ref:`example_050`

Templates at iocage_06
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 9,10

.. note::

   * In :ref:`example_440`, the variables ``ssh_rdr_start=2200`` and
     ``dhcp_ip_start=100`` are used in the playbook ``pb-pf-setup.yml`` to calculate the
     ports to redirect SSH from, and to create the file ``pf-rdr-ssh.conf``.

   * For example, from the controller, the following command connects to the jail at
     ``<bsd_dhcpd_subnet>.106``::

       shell> ssh -p 2206 admin@iocage_06

   * See the variable ``bsd_dhcpd_subnet`` in :ref:`example_440`.

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06.yml
   :language: yaml+jinja
   :emphasize-lines: 6
   :caption:

.. hint::

   If the default iocage option ``defaultrouter=auto`` does not work, set it explicitly. This may be
   needed if the jails are assigned IP addresses via DHCP on the bridge. In this case, the
   defaultrouter for the jails is the IP address of the bridge. pf must provide NAT and
   redirection. See :ref:`example_440`.

Playbook output - Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm \
                            -e swarm=true \
                            -e debug=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Jails at iocage_06
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Test SSH redirection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

.. hint::

   The following play stops and destroys the jails in ``swarms``::

     ansible-playbook -i iocage.ini \
                      -t swarm_destroy \
                      -e swarm_destroy=true \
                      vbotka.freebsd.pb_iocage_ansible_clients.yml


.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
