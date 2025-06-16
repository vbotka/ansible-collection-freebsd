Aliases
^^^^^^^

Quoting `Inventory aliases`_:

  The `inventory_hostname`_ is the unique identifier for a host in Ansible, this can be an IP or a
  hostname, but also just an 'alias' or short name for the host.

.. note::

   Given the host ``foo.example.com`` with the IP address ``10.1.0.11`` resolves via DNS or
   /etc/hosts, all below inventory entries are correct

   .. code-block:: console

     foo.example.com
     10.1.0.11
     bar ansible_host=foo.example.com
     bar ansible_host=10.1.0.11

.. seealso::

   * Ansible special variable `inventory_hostname`_
   * Ansible test `ansible.utils.resolvable`_ – Test if an IP or name can be resolved.
   * `Connection methods and details`_

As root at the iocage host, stop and destroy all jails

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage stop ALL
   * Stopping srv_1
     + Executing prestop OK
     + Stopping services OK
     + Tearing down VNET OK
     + Removing devfs_ruleset: 1000 OK
     + Removing jail process OK
     + Executing poststop OK
   * Stopping srv_2
     + Executing prestop OK
     + Stopping services OK
     + Tearing down VNET OK
     + Removing devfs_ruleset: 1001 OK
     + Removing jail process OK
     + Executing poststop OK
   * Stopping srv_3
     + Executing prestop OK
     + Stopping services OK
     + Tearing down VNET OK
     + Removing devfs_ruleset: 1002 OK
     + Removing jail process OK
     + Executing poststop OK
   ansible_client is not running!

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage destroy -f srv_1 srv_2 srv_3
   Destroying srv_1
   Destroying srv_2
   Destroying srv_3

Create three VNET jails with a DHCP interface from the template *ansible_client*. Use the option
``--count``

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage create --short --template ansible_client --count 3 bpf=1 dhcp=1 vnet=1
   1c11de2d successfully created!
   9d94cc9e successfully created!
   052b9557 successfully created!

The names are random. Start the jails

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage start ALL
   No default gateway found for ipv6.
   * Starting 052b9557
     + Started OK
     + Using devfs_ruleset: 1000 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.137/24
   No default gateway found for ipv6.
   * Starting 1c11de2d
     + Started OK
     + Using devfs_ruleset: 1001 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.146/24
   No default gateway found for ipv6.
   * Starting 9d94cc9e
     + Started OK
     + Using devfs_ruleset: 1002 (iocage generated default)
     + Configuring VNET OK
     + Using IP options: vnet
     + Starting services OK
     + Executing poststart OK
     + DHCP Address: 10.1.0.115/24
   Please convert back to a jail before trying to start ansible_client

List the jails

.. code-block:: console
   :emphasize-lines: 1

   shell> iocage list -l
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID |   NAME   | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+==========+======+=======+======+=================+====================+=====+================+==========+
   | 207 | 052b9557 | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.137 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 208 | 1c11de2d | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.146 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 209 | 9d94cc9e | off  | up    | jail | 14.2-RELEASE-p3 | epair0b|10.1.0.115 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+

Set *notes*. The tag *alias* is used to create `inventory aliases`_

.. code-block:: console
   :emphasize-lines: 1,3,5

   shell> iocage set notes="vmm=iocage_02 project=foo alias=srv_1" 052b9557
   notes: none -> vmm=iocage_02 project=foo alias=srv_1
   shell> iocage set notes="vmm=iocage_02 project=foo alias=srv_2" 1c11de2d
   notes: none -> vmm=iocage_02 project=foo alias=srv_2
   shell> iocage set notes="vmm=iocage_02 project=bar alias=srv_3" 9d94cc9e
   notes: none -> vmm=iocage_02 project=bar alias=srv_3

Update the inventory configuration. Set the parameter ``inventory_hostname_tag`` to *alias*. This tag
keeps the value of the `inventory alias`_. The *properties* are required. Enable the parameter
``get_properties``

.. code-block:: console

   (env) > cat hosts/02_iocage.yml

.. code-block:: yaml
   :emphasize-lines: 4,5

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   get_properties: true
   inventory_hostname_tag: alias
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)
     iocage_tags: dict(iocage_properties.notes | split | map('split', '='))
   keyed_groups:
     - prefix: vmm
       key: iocage_tags.vmm
     - prefix: project
       key: iocage_tags.project

Display tags and groups. Create a playbook

.. code-block:: console

   (env) > cat pb-test-groups.yml

.. code-block:: yaml+jinja

   - hosts: all
     remote_user: admin

     vars:

       ansible_python_interpreter: auto_silent

     tasks:

       - debug:
	   var: iocage_tags

       - debug:
           msg: |
	   {% for group in groups %}
	   {{ group }}: {{ groups[group] }}
	   {% endfor %}
	 run_once: true

Run the playbook

.. code-block:: console

   (env) > ansible-playbook -i hosts/02_iocage.yml pb-test-groups.yml

.. code-block:: yaml
   :force:

   PLAY [all] **********************************************************************************************************

   TASK [debug] ********************************************************************************************************
   ok: [srv_1] =>
       iocage_tags:
           alias: srv_1
           project: foo
           vmm: iocage_02
   ok: [srv_2] =>
       iocage_tags:
           alias: srv_2
           project: foo
           vmm: iocage_02
   ok: [srv_3] =>
       iocage_tags:
           alias: srv_3
           project: bar
           vmm: iocage_02

   TASK [debug] ********************************************************************************************************
   ok: [srv_1] =>
       msg: |-
           all: ['srv_1', 'srv_2', 'srv_3']
           ungrouped: []
           vmm_iocage_02: ['srv_1', 'srv_2', 'srv_3']
           project_foo: ['srv_1', 'srv_2']
           project_bar: ['srv_3']

   PLAY RECAP **********************************************************************************************************
   srv_1                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_2                      : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_3                      : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


.. _Inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _inventory alias: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases

.. _ansible.utils.resolvable: https://docs.ansible.com/ansible/latest/collections/ansible/utils/resolvable_test.html
.. _Connection methods and details: https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html
.. _inventory_hostname: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-inventory_hostname
