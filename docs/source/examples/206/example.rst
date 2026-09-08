.. _example_206:

206 Create DHCP and fixed IP jails
----------------------------------

Extending :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 206

.. index:: single: template ansible_client; Example 206
.. index:: single: ansible_client; Example 206
.. index:: single: DHCP; Example 206
.. index:: single: property notes; Example 206
.. index:: single: notes; Example 206

.. index:: single: inventory vbotka.freebsd.iocage; Example 206
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

In the `inventory plugin vbotka.freebsd.iocage`_ configuration file, use the option
``hooks_results`` to get the DHCP IP address. This option is common for all jails in this example:

.. code-block:: yaml

   hooks_results:
     - /var/db/dhclient-hook.address.epair0b

It will silently fail in jails with fixed IP addresses. If the item fails, the result is the dash
character '-':

.. code-block:: yaml

   iocage_hooks:
     - '-'

This use case demonstrates the advantage of silently ignoring failed items over potential
explicit error handling. Let the option ``compose`` pick what is needed:

.. code-block:: yaml

   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

**Fixed IP**

One jail with a fixed IP is created from the template ``ansible_client`` in this example:

.. code-block:: yaml

   clones:
     test_131:
       clone_from: ansible_client
       properties:
         ip4_addr: "em0|10.1.0.131/24"
         notes: "swarm=sw_01"

**Automatically generated UUID**

Two DHCP jails with generated UUIDs are created from the template ``ansible_client``:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible_client
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1

.. note:: The clone ``test_131`` belongs to the swarm ``sw_01``. Set ``count: 3`` to create two more jails
          in the swarm ``sw_01``.

The `module vbotka.freebsd.iocage`_ does not work with multiple names. We will use
``ansible.builtin.command`` instead. Such a task is not idempotent anyway if the UUID is generated
automatically. Example commands:

.. code-block:: bash

   shell> iocage create --short --template ansible_client --count 2 bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_02 swarm=sw_01"
   shell> iocage start cd31c2a2 d254f889

**The variable iocage_tags**

The inventory plugin composes the variable ``iocage_tags``:

.. code-block:: yaml

   iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))

For example:

.. code-block:: yaml

   iocage_tags:
     vmm: iocage_04
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
  │   └── 04_iocage.yml
  ├── host_vars
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On one managed node:

  * iocage_04

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_, use:

  * `module vbotka.freebsd.iocage`_ to:

    * Create one jail with a fixed IP
    * Start the jail

  * Module ``ansible.builtin.command`` to:

    * Create two DHCP jails with generated UUIDs
    * Start the jails

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Connect to the created jails
  * Display basic configuration of the jails

Requirements
^^^^^^^^^^^^

* Playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* Root privileges on the managed nodes
* Templates created in :ref:`example_202`

Notes
^^^^^

* Templates created in :ref:`example_202` are used in this example.

* The dash '-' is used in `binary iocage`_ to represent a missing value. See, for example:

  * `ioc_list.py#L258`_
  * `ioc_list.py#L275`_
  * The `inventory plugin vbotka.freebsd.iocage`_ uses it too::

      if iocage_ip4_dict['ip4']:
          iocage_ip4 = ','.join([d['ip'] for d in iocage_ip4_dict['ip4']])
      else:
          iocage_ip4 = '-'

.. seealso::

   * `binary iocage`_

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

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

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Create and start clones
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini \
                            -t clone -e clone=true

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini \
                            -t swarm -e swarm=true -e debug=true

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4,9

.. note::

   The option ``get_properties: True`` is needed to compose the dictionary ``iocage_tags``.

Display inventory
^^^^^^^^^^^^^^^^^

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

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the jails in ``swarms``::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini \
                      -t swarm_destroy -e swarm_destroy=true


.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _binary iocage: https://github.com/freebsd/iocage/
.. _ioc_list.py#L258: https://github.com/freebsd/iocage/blob/master/iocage_lib/ioc_list.py#L258
.. _ioc_list.py#L275: https://github.com/freebsd/iocage/blob/master/iocage_lib/ioc_list.py#L275