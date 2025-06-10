.. _example_020:

020 Get inventory aliases from notes
------------------------------------

Extending example :ref:`example_016`.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: inventory aliases; Example 020
.. index:: single: inventory vbotka.freebsd.iocage; Example 020
.. index:: single: inventory ansible.builtin.constructed; Example 020
.. index:: single: option inventory_hostname_tag; Example 020
.. index:: single: inventory_hostname_tag; Example 020
.. index:: single: option inventory_hostname_required; Example 020
.. index:: single: inventory_hostname_required; Example 020
.. index:: single: compose; Example 020
.. index:: single: option compose; Example 020
.. index:: single: compose; Example 020

Use case
^^^^^^^^

Get the `inventory aliases`_ from the `iocage property notes`_. In the `inventory plugin
vbotka.freebsd.iocage`_ use option *inventory_hostname_tag* to tell the plugin which tag to use.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── swarms.yml
  ├── hosts
  │   ├── 02_iocage.yml
  │   ├── 03_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_03
  │       └── iocage.yml
  ├── iocage-hosts.ini
  ├── pb-iocage-swarms-create.yml
  ├── pb-iocage-swarms-destroy.yml
  ├── pb-test-all.yml
  └── pb-test-db.yml

Synopsis
^^^^^^^^

* At two iocage hosts:

  * create jails using a template and the option *--count*
  * at each jail, create property notes in the format "tag1=val1 tag2=val2 ..."
  * put the inventory alias into the tag "alias=<alias>"

* In the `inventory plugin vbotka.freebsd.iocage`_ get the inventory aliases from the tag *alias*

* In the inventory plugin `ansible.builtin.constructed`_ create the inventory groups.

* Display the jails and groups.

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* root privilege on the iocage hosts
* templates created in :ref:`example_202`.
 
Notes
^^^^^

   * The inventory files in the directory *hosts* are evaluated in alphabetical
     order.

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * :ref:`example_016`

List templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -lt

.. literalinclude:: out/out-01.txt
   :language: bash

List templates at iocage_03
^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_03]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/swarms.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_03/iocage.yml
   :language: yaml
   :caption:
  
Inventory hosts
^^^^^^^^^^^^^^^

The value of the iocage tag *alias* is used as the inventory alias. If the `iocage list is slow`_ use
the cache.

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 10

.. literalinclude:: hosts/03_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 10

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Playbook *pb-iocage-swarms-create.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-swarms-create.yml
   :language: yaml

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  env) > ansible-playbook pb-iocage-swarms-create.yml -i iocage-hosts.ini

.. literalinclude:: out/out-03.txt
   :language: bash

.. hint::

   Run the below command to see the complete inventory ::

     shell> ansible-inventory -i hosts --list --yaml

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash

List jails at iocage_03
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_03]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash

Playbook *pb-test-all.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml

Playbook output - all groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-all.yml -i hosts

.. literalinclude:: out/out-06.txt
   :language: yaml

Playbook *pb-test-db.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-db.yml
   :language: yaml

Playbook output - group swarm_db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-db.yml -i hosts

.. literalinclude:: out/out-07.txt
   :language: yaml

Playbook *pb-iocage-swarms-destroy.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-swarms-destroy.yml
   :language: yaml

Playbook output - Destroy swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Destroy the swarms if you don't need them.

::

  (env) > ansible-playbook pb-iocage-swarms-destroy.yml -i iocage-hosts.ini -i hosts

.. literalinclude:: out/out-08.txt
   :language: bash

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _Inventory aliases: https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#inventory-aliases
.. _iocage property notes: https://iocage.readthedocs.io/en/latest/basic-use.html?highlight=properties#set-jail-property
.. _Set Jail Property: https://iocage.readthedocs.io/en/latest/basic-use.html?highlight=properties#set-jail-property
.. _iocage list is slow: https://forums.freebsd.org/threads/freebsd-13-1-extremally-slow.86723
