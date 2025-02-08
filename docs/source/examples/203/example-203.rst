.. _example_203:

203 Create DHCP jails from template. Auto UUID, iocage_tags.
------------------------------------------------------------

Extending example :ref:`example_202`.

.. contents:: Table of Contents
   :depth: 2

Use case
^^^^^^^^

**Automatically generated UUID**

In this example, the names of the jails are automatically generated UUID. At each iocage host three
jails will be created from the template *ansible_client* ::

  swarms:
    sw_01:
      count: 3
      template: ansible_client

The module *vbotka.freebsd.iocage* doesn't work with multiple names. We will use
*ansible.builtin.command* instead. Such a task is not idempotent anyway if the UUID is generated
automatically. Example of the commands ::

  iocage create --short --template ansible_client --count 3  bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_01 swarm=sw_01"
  iocage start cd31c2a2 d254f889 158ef36d

**The variable iocage_tags**

The inventory plugin composes the variable *iocage_tags* ::

  iocage_tags: dict(iocage_properties.notes | split | map('split', '='))

For example ::

  iocage_tags:
    vmm: iocage_01
    swarm: sw_01

This variable is used to create groups ::

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
   ├── group_vars
   │   └── all
   │       └── iocage.yml
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   └── 03_constructed.yml
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   └── iocage_02
   │       └── iocage.yml
   ├── iocage-hosts.ini
   ├── pb-iocage-ansible-clients -> ../../../../playbooks/pb-iocage-ansible-clients
   ├── pb-iocage-ansible-clients.yml -> ../../../../playbooks/pb-iocage-ansible-clients.yml
   └── pb-test-01.yml

Synopsis
^^^^^^^^

.. index:: single: template ansible_client; Example 203
.. index:: single: ansible_client; Example 203
.. index:: single: DHCP; Example 203
.. index:: single: inventory vbotka.freebsd.iocage; Example 203
.. index:: single: module vbotka.freebsd.iocage; Example 203
.. index:: single: module ansible.builtin.command; Example 203
.. index:: single: playbook pb-iocage-ansible-clients.yml; Example 203
.. index:: single: option get_properties; Example 203
.. index:: single: get_properties; Example 203
.. index:: single: option hooks_results; Example 203
.. index:: single: hooks_results; Example 203
.. index:: single: property notes; Example 203
.. index:: single: notes; Example 203
.. index:: single: variable iocage_hooks; Example 203
.. index:: single: iocage_hooks; Example 203
.. index:: single: variable iocage_properties; Example 203
.. index:: single: iocage_properties; Example 203
.. index:: single: variable iocage_tags; Example 203
.. index:: single: iocage_tags; Example 203
.. index:: single: option iocage --short; Example 203
.. index:: single: option iocage --template; Example 203

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-ansible-clients.yml*, use the module:

  * *vbotka.freebsd.iocage* to:

    * create facts only

  * *ansible.builtin.command* to:

    * create jails
    * start jails
    * optionally stop and destroy the jails.
  
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
* templates created in example 202


Notes
^^^^^

Templates created in :ref:`example_202` are used in this example

.. seealso::

   * `binary iocage`_


List templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

group_vars/all/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
    :language: yaml

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

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

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
    :language: bash

List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-05.txt
    :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-06.txt
    :language: bash
	       
Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml
    :emphasize-lines: 4,9

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :emphasize-lines: 6,11

.. note::

   The option `"get_properties: True"` is needed to get the dictionary `iocage_properties`

Inventory *hosts/03_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/03_constructed.yml
    :language: yaml

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-07.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^
	       
.. literalinclude:: out/out-08.txt
    :language: bash

.. hint::

   The below command stops and destroys the jails in *swarms* ::

     ansible-playbook pb-iocage-ansible-clients.yml -i iocage-hosts.ini \
                                                    -t swarm_destroy \
						    -e swarm_destroy=true


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
