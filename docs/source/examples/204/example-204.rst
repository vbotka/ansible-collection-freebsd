.. _example_204:

204 Create DHCP jails from template v2. Auto UUID, iocage_tags.
---------------------------------------------------------------

| Extending example :ref:`example_203`

.. contents:: Table of Contents
   :depth: 2

Use case
^^^^^^^^

| Instead of the module *vbotka.freebsd.iocage* create the variable *iocage_jails* using the `filter vbotka.freebsd.iocage`_

.. literalinclude:: pb-iocage-ansible-clients/iocage_jails.yml
    :language: yaml

**Test filter vbotka.freebsd.iocage**

Given the input *vars/iocage_datasets.yml*

.. literalinclude:: vars/iocage_datasets.yml
    :language: yaml

The below playbook *pb-test-02.yml*

.. literalinclude:: pb-test-02.yml
    :language: yaml

gives

.. literalinclude:: out/out-01.txt
    :language: yaml

	       
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
   ├── pb-iocage-ansible-clients
   │   ├── iocage_jails.yml
   │   ├── swarm_destroy.yml
   │   └── swarm.yml
   ├── pb-iocage-ansible-clients-v2.yml
   ├── pb-test-01.yml
   ├── pb-test-02.yml
   └── vars
       └── iocage_datasets.yml

Synopsis
^^^^^^^^

.. index:: single: template ansible_client; Example 204
.. index:: single: ansible_client; Example 204
.. index:: single: DHCP; Example 204
.. index:: single: filter vbotka.freebsd.iocage; Example 204
.. index:: single: inventory vbotka.freebsd.iocage; Example 204
.. index:: single: module ansible.builtin.command; Example 204
.. index:: single: playbook pb-iocage-ansible-clients-v2.yml; Example 204
.. index:: single: option get_properties; Example 204
.. index:: single: get_properties; Example 204
.. index:: single: option hooks_results; Example 204
.. index:: single: hooks_results; Example 204
.. index:: single: property notes; Example 204
.. index:: single: notes; Example 204
.. index:: single: variable iocage_jails; Example 204
.. index:: single: iocage_jails; Example 204
.. index:: single: variable iocage_hooks; Example 204
.. index:: single: iocage_hooks; Example 204
.. index:: single: variable iocage_properties; Example 204
.. index:: single: iocage_properties; Example 204
.. index:: single: variable iocage_tags; Example 204
.. index:: single: iocage_tags; Example 204
.. index:: single: option iocage --short; Example 204
.. index:: single: option iocage --template; Example 204

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-ansible-clients-v2.yml*, use the module:

  * *ansible.builtin.command* to:

    * create variable iocage_jails
    * create jails
    * start jails
    * optionally stop and destroy the jails.
  
* On all created jails:

  In the playbook *pb-test-01.yml*:

  * connect created jails
  * display basic configuration of the jails.


Requirements
^^^^^^^^^^^^

* `filter vbotka.freebsd.iocage`_
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

Playbook *pb-iocage-ansible-clients-v2.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-ansible-clients-v2.yml
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

     ansible-playbook pb-iocage-ansible-clients-v2.yml -i iocage-hosts.ini \
                                                       -t swarm_destroy \
                                                       -e swarm_destroy=true


.. _filter vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
