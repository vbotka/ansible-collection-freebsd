.. _example_441:

441 Redirect SHH to jails
-------------------------

| Extending example :ref:`example_440`.
| Extending example :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 441

.. index:: single: option compose; Example 441
.. index:: single: compose; Example 441

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
``ansible_host`` and ``ansible_port`` to connect the jails via the redirected SSH
ports. See the example :ref:`example_440` how ``pf`` is configured.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   └── iocage_05.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* At a managed node:

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_:
  
  * create jails
  * start jails
  * optionally, stop and destroy the jails.

* Create dynamic inventory to redirect SSH to the jails.

* At all created jails:

  In the playbook ``pb-test.yml``:

  * connect to the created jails
  * display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* template ``ansible_client`` created in :ref:`example_202`

Notes
^^^^^

The only difference between this example and the example :ref:`example_442` are the
following two lines in the file ``hosts/05_iocage.yml``

.. code-block:: yaml

   ansible_host: dict(iocage_properties.notes | split | map('split', '=')).vmm
   ansible_port: iocage_ip4 | split('.') | last | int - 100 + 2200

.. seealso::

   example :ref:`example_050`

Templates at iocage_05
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_05]# iocage list -lt

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

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05.yml
   :language: yaml
   :emphasize-lines: 6
   :caption:

.. hint::

   If the default iocage option ``defaultrouter=auto`` doesn't work set it. This may be
   needed if the jails are provided with the DHCP on the bridge. In this case, the
   defaultrouter for the jails is the IP address of the bridge. pf must provide NAT and
   redirection. See example :ref:`example_440`.

Playbook output - Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
                            -t swarm \
                            -e swarm=true \
                            -e debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Jails at iocage_05
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 9,10

.. note::

   * In the example :ref:`example_440`, the variables ``ssh_rdr_start=2200`` and
     ``dhcp_ip_start=100`` are used in the playbook ``pb-pf-setup.yml`` to calculate the
     ports to redirect SSH from, and to create the file ``pf-rdr-ssh.conf``.

   * For example, from the controller, the following command connects to the jail at
     <bsd_dhcpd_subnet>.106::

       shell> ssh -p 2206 admin@iocage_05

   * See the variable ``bsd_dhcpd_subnet`` in the example :ref:`example_440`
		  
.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - Test SSH redirection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

.. hint::

   The below play stops and destroys the jails in ``swarms`` ::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                      -i iocage.ini \
                      -t swarm_destroy \
                      -e swarm_destroy=true


.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
