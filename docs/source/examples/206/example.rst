.. _example_206:

206 Create DHCP and fixed IP jails
----------------------------------

This example extends :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 206
.. index:: single: swarms destroy; Example 206

.. index:: single: template ansible-client; Example 206
.. index:: single: ansible-client; Example 206
.. index:: single: DHCP; Example 206
.. index:: single: property notes; Example 206
.. index:: single: notes; Example 206

.. index:: single: inventory vbotka.freebsd.iocage2; Example 206
.. index:: single: module vbotka.freebsd.iocage; Example 206
.. index:: single: module ansible.builtin.command; Example 206
.. index:: single: pb_iocage_ansible_clients.yml; Example 206

.. index:: single: option compose; Example 206
.. index:: single: compose; Example 206
.. index:: single: option get_properties; Example 206
.. index:: single: get_properties; Example 206
.. index:: single: option hooks_results; Example 206
.. index:: single: hooks_results; Example 206

.. index:: single: option iocage --count; Example 206
.. index:: single: option iocage --short; Example 206
.. index:: single: option iocage --template; Example 206

.. index:: single: variable iocage_hooks; Example 206
.. index:: single: iocage_hooks; Example 206
.. index:: single: variable iocage_properties; Example 206
.. index:: single: iocage_properties; Example 206
.. index:: single: variable iocage_tags; Example 206
.. index:: single: iocage_tags; Example 206

Use case
^^^^^^^^

In the :ref:`inventory vbotka.freebsd.iocage2 <ug_inventory_iocage2>`
configuration file, use the option ``hooks_results`` to get the DHCP IP
address. This option is common for all jails in this example:

.. code-block:: yaml

   hooks_results:
     - /var/db/dhclient-hook.address.epair0b

It will silently fail in jails with fixed IP addresses. If the item fails, the
result is the dash character '-':

.. code-block:: yaml

   iocage_hooks:
     - '-'

This use case demonstrates the advantage of silently ignoring failed items over
potential explicit error handling. Let the option ``compose`` pick what is
needed:

.. code-block:: yaml

   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

**Fixed IP**

One jail with a fixed IP is created from the template ``ansible-client`` in this
example:

.. code-block:: yaml

   clones:
     test-161:
       clone_from: ansible-client
       properties:
         bpf: 1
         vnet: 1
         ip4_addr: "vnet0|172.16.99.201/24"
         defaultrouter: '172.16.99.1'
         notes: "swarm=sw_01 alias=test_161"

**Automatically generated UUID**

Two DHCP jails with generated UUIDs are created from the template
``ansible-client``:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible-client
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1

.. note::

   The clone ``test-161`` belongs to the swarm ``sw_01``. Set ``count: 3`` to
   create two more jails in the swarm ``sw_01``.

The :ref:`module vbotka.freebsd.iocage <ug_module_iocage>` does not work with
multiple names. Use ``ansible.builtin.command`` instead. Such a task is not
idempotent anyway if the UUID is generated automatically. Example commands:

.. code-block:: bash

   shell> iocage create --short --template ansible-client --count 2 bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_06 swarm=sw_01"
   shell> iocage start cd31c2a2 d254f889

**The variable iocage_tags**

The inventory plugin composes the variable ``iocage_tags``:

.. code-block:: yaml

   iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))

For example:

.. code-block:: yaml

   iocage_tags:
     vmm: iocage_06
     swarm: sw_01

This dictionary is used to create groups:

.. code-block:: yaml

   keyed_groups:
     - prefix: swarm
       key: iocage_tags.swarm
     - prefix: vmm
       key: iocage_tags.vmm

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook :ref:`ug_pb-iocage-ansible-client`, use:

  * :ref:`ug_module_iocage` to:

    * Create one jail with a fixed IP.
    * Start the jail.

  * Module ``ansible.builtin.command`` to:

    * Create two DHCP jails with generated UUIDs.
    * Start the jails.

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Connect to the created jails.
  * Display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-ansible-client`
* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Root privileges on the managed nodes
* Templates created in :ref:`example_202`

Notes
^^^^^

* Templates created in :ref:`example_202` are used in this example.

* The dash '-' is used in `binary iocage`_ to represent a missing
  value. See, for example:

  * `ioc_list.py#L258`_
  * `ioc_list.py#L275`_
  * The :ref:`inventory vbotka.freebsd.iocage2 <ug_inventory_iocage2>` uses it too::

      if iocage_ip4_dict['ip4']:
          iocage_ip4 = ','.join([d['ip'] for d in iocage_ip4_dict['ip4']])
      else:
          iocage_ip4 = '-'

.. seealso::

   * `binary iocage`_

Templates
^^^^^^^^^

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
   :emphasize-lines: 5,11

.. note::

   The option ``get_properties: true`` is needed to compose the dictionary
   ``iocage_tags``.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

Create and start clones
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone -e clone=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true -e debug=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Jails
^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-05.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display jails in the swarm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook output - Destroy swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Destroy the swarms if you do not need them anymore.

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm_destroy -e swarm_destroy=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:
