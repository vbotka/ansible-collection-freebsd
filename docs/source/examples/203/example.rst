.. _example_203:

203 Create DHCP jails with auto UUID and iocage_tags
----------------------------------------------------

Extending example :ref:`example_202`.

.. contents::
   :local:
   :depth: 1

.. index:: single: template ansible_client; Example 203
.. index:: single: ansible_client; Example 203
.. index:: single: DHCP; Example 203

.. index:: single: inventory vbotka.freebsd.iocage; Example 203
.. index:: single: module vbotka.freebsd.iocage; Example 203
.. index:: single: module ansible.builtin.command; Example 203
.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 203

.. index:: single: option compose; Example 203
.. index:: single: compose; Example 203
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

.. index:: single: option iocage --count; Example 203
.. index:: single: option iocage --short; Example 203
.. index:: single: option iocage --template; Example 203

Use case
^^^^^^^^

**Automatically generated UUID**

Automatically generate the jails UUID names. At each iocage host, create three jails from the
template ``ansible_client`` ::

  swarms:
    sw_01:
      count: 3
      template: ansible_client

The module ``vbotka.freebsd.iocage`` doesn't work with multiple names. Use
``ansible.builtin.command`` instead. If the UUID is generated automatically, such a task is not
idempotent anyway. Example of the commands ::

  iocage create --short --template ansible_client --count 3  bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_01 swarm=sw_01"
  iocage start cd31c2a2 d254f889 158ef36d

**The variable iocage_tags**

In the inventory plugin, compose the variable ``iocage_tags`` ::

  iocage_tags: dict(iocage_properties.notes | split | map('split', '='))

For example, ::

  iocage_tags:
    vmm: iocage_01
    swarm: sw_01

Create groups from ``iocage_tags`` ::

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
  ├── iocage.ini
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* At two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_, use:

  * `module vbotka.freebsd.iocage`_ to:

    * create facts only

  * module ``ansible.builtin.command`` to:

    * create jails
    * start jails
    * optionally stop and destroy the jails.
  
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
* templates created in :ref:`example_202`

Notes
^^^^^

* Templates created in :ref:`example_202` are used in this example.

.. seealso::

   * `binary iocage`_

List templates at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_01]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Playbook output - create and start swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
                            -t swarm \
                            -e swarm=true \
                            -e debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

List jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_01]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 4,9

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 6,11

.. literalinclude:: hosts/03_constructed.yml
   :language: yaml
   :caption:

.. note::

   The option ``get_properties: True`` is needed to get the dictionary ``iocage_properties``

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-07.txt
   :language: bash

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - display *iocage_tags*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

.. hint::

   The below command stops and destroys the jails in ``swarms`` ::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                      -i iocage.ini \
                      -t swarm_destroy \
                      -e swarm_destroy=true


.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
