.. _example_206:

206 Create DHCP and fixed IP jails from template.
-------------------------------------------------

Extending example :ref:`example_203`.

.. contents:: Table of Contents
   :depth: 2

Use case
^^^^^^^^

In the `inventory plugin vbotka.freebsd.iocage`_ configuration file, use the option
*hooks_results* to get the DHCP IP address. This option is common for all jails ::

  hooks_results:
    - /var/db/dhclient-hook.address.epair0b

It will silently fail in jails with fixed IP addresses. If the item fails the result is a dash
character '-' ::

  iocage_hooks:
    - '-'

This use-case demonstrates the advantage of silently ignoring failed items over the
potential explicit error handling. Let the option *compose* pick what is needed ::

  compose:
    ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

**Fixed IP**

In this example, one jail with fixed IP will be created from the template *ansible_client* ::

  clones:
    test_111:
      clone_from: ansible_client
      properties:
        ip4_addr: "em0|10.1.0.111/24"
        notes: "swarm=sw_01"

**Automatically generated UUID**

Two DHCP jails with generated UUID will be created from the template *ansible_client* ::

  swarms:
    sw_01:
      count: 3
      template: ansible_client
      properties:
        bpf: 1
        dhcp: 1
        vnet: 1

.. note:: The clone *test_111* belongs to the swarm *sw_01*. Set *count: 3* to create two more jails
          in the swarm *sw_01*.
	
The module *vbotka.freebsd.iocage* doesn't work with multiple names. We will use
*ansible.builtin.command* instead. Anyway, such a task is not idempotent if the UUID is generated
automatically. Example of the commands ::

  iocage create --short --template ansible_client --count 2  bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_02 swarm=sw_01"
  iocage start cd31c2a2 d254f889

**The variable iocage_tags**

The inventory plugin composes the variable *iocage_tags* ::

  iocage_tags: dict(iocage_properties.notes | split | map('split', '='))

For example, ::

  iocage_tags:
    vmm: iocage_02
    swarm: sw_01

This option is used to create groups from *iocage_tags* ::

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
   │   └── 02_iocage.yml
   ├── host_vars
   │   └── iocage_02
   │       └── iocage.yml
   ├── iocage-hosts.ini
   ├── pb-iocage-ansible-clients -> ../../../../playbooks/pb-iocage-ansible-clients
   ├── pb-iocage-ansible-clients.yml -> ../../../../playbooks/pb-iocage-ansible-clients.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

.. index:: single: template ansible_client; Example 206
.. index:: single: ansible_client; Example 206
.. index:: single: DHCP; Example 206
.. index:: single: inventory vbotka.freebsd.iocage; Example 206
.. index:: single: module vbotka.freebsd.iocage; Example 206
.. index:: single: module ansible.builtin.command; Example 206
.. index:: single: playbook pb-iocage-ansible-clients.yml; Example 206
.. index:: single: option get_properties; Example 206
.. index:: single: get_properties; Example 206
.. index:: single: option hooks_results; Example 206
.. index:: single: hooks_results; Example 206
.. index:: single: property notes; Example 206
.. index:: single: notes; Example 206
.. index:: single: variable iocage_hooks; Example 206
.. index:: single: iocage_hooks; Example 206
.. index:: single: variable iocage_properties; Example 206
.. index:: single: iocage_properties; Example 206
.. index:: single: variable iocage_tags; Example 206
.. index:: single: iocage_tags; Example 206
.. index:: single: option iocage --short; Example 206
.. index:: single: option iocage --template; Example 206

* On one iocage hosts:

  * iocage_02

  In the playbook *pb-iocage-ansible-clients.yml*, use the module:

  * *vbotka.freebsd.iocage* to:

    * create one jail with fixed IP
    * start the jail

  * *ansible.builtin.command* to:

    * create two DHCP jails with generated UUID
    * start the jails
  
* On all created jails:

  In the playbook *pb-test-01.yml*:

  * connect created jails
  * display basic configuration of the jails.


Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* activated *iocage*
* fetched releases
* templates created in example 205


Notes
^^^^^

* Templates created in :ref:`example_205` are used in this example.

* The dash "-" is used in `binary iocage`_ to represent a missing value. See for example:

  * `ioc_list.py#L259`_
  * `ioc_list.py#L276`_
  * `inventory plugin vbotka.freebsd.iocage`_ uses it too ::

      if iocage_ip4_dict['ip4']:
          iocage_ip4 = ','.join([d['ip'] for d in iocage_ip4_dict['ip4']])
      else:
          iocage_ip4 = '-'


.. seealso::

   * `binary iocage`_


List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml
	       
Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

Playbook *pb-iocage-ansible-clients.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-ansible-clients.yml
    :language: yaml

Create and start clones
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

Create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :emphasize-lines: 6,11

.. note::

   The option `"get_properties: True"` is needed to get the dictionary `iocage_properties`

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-06.txt
    :language: bash

.. hint::

   The below command stops and destroys the jails in *swarms* ::

     ansible-playbook pb-iocage-ansible-clients.yml -i iocage-hosts.ini \
                                                    -l iocage_02 \
                                                    -t swarm_destroy \
						    -e swarm_destroy=true


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
.. _ioc_list.py#L259: https://github.com/iocage/iocage/blob/master/iocage_lib/ioc_list.py#L259
.. _ioc_list.py#L276: https://github.com/iocage/iocage/blob/master/iocage_lib/ioc_list.py#L276
