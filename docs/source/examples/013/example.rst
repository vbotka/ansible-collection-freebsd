.. _example_013:

013 Tags and custom groups
--------------------------

Extending example :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.iocage; Example 013
.. index:: single: inventory vbotka.freebsd.iocage; Example 013
.. index:: single: property notes; Example 013
.. index:: single: notes; Example 013
.. index:: single: variable iocage_tags; Example 013
.. index:: single: iocage_tags; Example 013
.. index:: single: option compose; Example 013
.. index:: single: compose; Example 013
.. index:: single: option keyed_groups; Example 013
.. index:: single: keyed_groups; Example 013
.. index:: single: option get_properties; Example 013
.. index:: single: get_properties; Example 013
.. index:: single: variable iocage_properties; Example 013
.. index:: single: iocage_properties; Example 013

Use case
^^^^^^^^

Use the property ``notes`` to create tags:

* Add the property ``notes: "vmm={{ inventory_hostname }}"``

In the inventory plugin:

* compose the variable ``iocage_tags``
* create groups ``vmm_*`` from the attribute ``iocage_tags.vmm``

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 02_iocage.yml
  │   └── 04_iocage.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-all.yml
  ├── pb-ansible-client.yml
  ├── pb-iocage-base.yml
  ├── pb-iocage-clone.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* At two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage-base.yml``, use the `module vbotka.freebsd.iocage`_ to:

  * create basejail ``ansible_client``

  In the playbook ``pb-iocage-clone.yml``, use the `module vbotka.freebsd.iocage`_ to:

  * clone 3 jails from the basejail ``ansible_client``

  In the playbooks:

  * pb-all.yml
  * pb-ansible-client.yml
  * pb-test.yml

  use the `inventory plugin vbotka.freebsd.iocage`_ to:

  * create the inventory groups and compose variables
  * create the dictionary ``iocage_tags`` from ``iocage_properties.notes``
  * display hosts, composed variables, and groups
  * comment on hosts potentially overriding each other silently.

Requirements
^^^^^^^^^^^^

* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* activated `binary iocage`_
* fetched releases.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

Enable ``get_properties: true`` to create the dictionary ``iocage_properties``. Then, the dictionary
``iocage_tags`` can be created from ``iocage_properties.notes``

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 6,10,19

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 4,8,17

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml
   :caption:

.. note:: The structure of the ``notes`` is up to you. If you change it, fit the declaration of
          ``iocage_tags`` in the inventory.

Playbook pb-iocage-base.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-base.yml
   :language: yaml

Playbook output - create basejails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-base.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-iocage-clone.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone.yml
   :language: yaml

Playbook output - clone jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-clone.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook pb-all.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-all.yml
   :language: yaml

Playbook output - display variables and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-all.yml -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in alphabetical order.
   * The jail ``ansible_client`` from ``iocage_02`` overrides the one from ``iocage_01``
   * See the special variable `groups`_

Playbook pb-ansible-client.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-ansible-client.yml
   :language: yaml

Playbook output - display iocage_tags and group_names
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-ansible-client.yml -i hosts

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

.. note::

   * The structure of the inventory hosts and groups is flat. The jail ``ansible-client`` is the
     same in all groups.

   * See the special variable `group_names`_

.. warning:: There are no internal checks of the hosts overriding each other. The consistency is up to you.

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - display all jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:


.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
.. _groups:  https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-groups
.. _group_names: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-group_names
