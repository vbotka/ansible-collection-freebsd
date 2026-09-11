.. _example_013:

013 Tags and custom groups
--------------------------

Extending :ref:`example_010`.

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

.. index:: single: iocage_jails; Example 013
.. index:: single: iocage_plugins; Example 013
.. index:: single: iocage_releases; Example 013
.. index:: single: iocage_templates; Example 013

Use case
^^^^^^^^

Use the property ``notes`` to create tags:

* Add the property ``notes: "vmm={{ inventory_hostname }}"``

In the inventory plugin:

* Compose the variable ``iocage_tags``
* Create groups ``vmm_*`` from the attribute ``iocage_tags.vmm``

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 02_iocage.yml
  │   └── 04_iocage.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-all.yml
  ├── pb-ansible-client.yml
  ├── pb-iocage-base.yml
  ├── pb-iocage-clone.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage-base.yml``, use the :ref:`ug_module_iocage` to:

  * Create the basejail ``ansible_client``

  In the playbook ``pb-iocage-clone.yml``, use the :ref:`ug_module_iocage` to:

  * Clone 3 jails from the basejail ``ansible_client``

  In the playbooks:

  * pb-all.yml
  * pb-ansible-client.yml
  * pb-test.yml

  use the :ref:`ug_inventory_iocage` to:

  * Create inventory groups and compose variables
  * Create the dictionary ``iocage_tags`` from ``iocage_properties.notes``
  * Display hosts, composed variables, and groups

* Comment on hosts potentially silently overriding each other.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Root privileges on the managed nodes
* An activated `binary iocage`_
* Fetched releases

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

Enable ``get_properties: true`` to create the dictionary
``iocage_properties``. Then, the dictionary ``iocage_tags`` can be created from
``iocage_properties.notes``.

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 6,10,19

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4,8,17

.. note::

   The structure of ``notes`` is arbitrary. If you change it, adjust the
   declaration of ``iocage_tags`` in the inventory accordingly.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-iocage-base.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-base.yml
   :language: yaml+jinja

Playbook output - Create basejails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-base.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook pb-iocage-clone.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone.yml
   :language: yaml+jinja

Playbook output - Clone jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage-clone.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Playbook pb-all.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-all.yml
   :language: yaml+jinja

Playbook output - Display variables and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-all.yml -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in
     alphabetical order.

   * The jail ``ansible_client`` defined in ``04_iocage.yml`` overrides the one
     from ``02_iocage.yml``.

   * See the special variable `groups`_.

Playbook pb-ansible-client.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-ansible-client.yml
   :language: yaml+jinja

Playbook output - Display iocage_tags and group_names
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-ansible-client.yml -i hosts

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

.. note::

   * The structure of the inventory hosts and groups is flat. The jail
     ``ansible_client`` is the same in all groups.

   * See the special variable `group_names`_.

.. warning::

   There are no internal checks for hosts overriding each other. Maintaining
   inventory consistency is up to the user.

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display all jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:
