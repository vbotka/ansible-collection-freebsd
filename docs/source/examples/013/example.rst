.. _example_013:

013 Tags and custom groups
--------------------------

This example extends :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: clones; Example 013
   single: inventory groups; Example 013
   single: module vbotka.freebsd.iocage; Example 013
   single: inventory vbotka.freebsd.iocage; Example 013
   single: property notes; Example 013
   single: notes; Example 013
   single: variable iocage_tags; Example 013
   single: iocage_tags; Example 013
   single: option compose; Example 013
   single: compose; Example 013
   single: option keyed_groups; Example 013
   single: keyed_groups; Example 013
   single: option get_properties; Example 013
   single: get_properties; Example 013
   single: variable iocage_properties; Example 013
   single: iocage_properties; Example 013
   single: iocage_jails; Example 013
   single: iocage_plugins; Example 013
   single: iocage_releases; Example 013
   single: iocage_templates; Example 013

Use case
^^^^^^^^

Use the `iocage jail property`_ ``notes`` to create ``iocage tags``:

* Add the property ``notes: "vmm={{ inventory_hostname }}"``.

In the inventory plugin:

* Compose the variable ``iocage_tags``.
* Create groups ``vmm_*`` from the attribute ``iocage_tags.vmm``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   ├── 06_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-all.yml
  ├── pb-iocage-base.yml
  ├── pb-iocage-clone.yml
  ├── pb-test-vmm.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On managed nodes:

  * In the playbook ``pb-iocage-base.yml``, use the :ref:`module
    vbotka.freebsd.iocage <ug_module_iocage>` to create the basejail
    ``ansible-test``.

  * In the playbook ``pb-iocage-clone.yml``, use the :ref:`module
    vbotka.freebsd.iocage <ug_module_iocage>` to clone 3 jails from the
    basejail ``ansible-test``.

  * In the playbooks ``pb-all.yml``, ``pb-test.yml``, and
    ``pb-test-vmm.yml``, use the :ref:`inventory vbotka.freebsd.iocage
    <ug_inventory_iocage>` to:

    * Create inventory groups and compose variables.
    * Create the dictionary ``iocage_tags`` from ``iocage_properties.notes``.
    * Display hosts, composed variables, and groups.

* Comment on hosts potentially silently overriding each other.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Activated `iocage`_.
* Fetched releases.
* Root privileges on the managed nodes.

.. seealso::

   * :ref:`example_016`

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

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5,11-12

.. note::

   * Enable ``get_properties: true`` to create the dictionary
     ``iocage_properties``. Then, the dictionary ``iocage_tags`` can be created
     from ``iocage_properties.notes``.

   * The structure of ``notes`` is arbitrary. If you change it, update the
     ``iocage_tags`` declaration accordingly.

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 27

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 27

Playbook pb-iocage-base.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-base.yml
   :language: yaml+jinja

Playbook output - Create basejails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-base.yml

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

   (env) > ansible-playbook -i iocage.ini pb-iocage-clone.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-03.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in
     alphabetical order.

   * The jail ``ansible-test`` from ``06_iocage.yml`` overrides the one from
     ``05_iocage.yml``.

   * See the special variable `groups`_.

Playbook pb-all.yml
^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-all.yml
   :language: yaml+jinja

Playbook output - Display variables and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-all.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display tags and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

.. note::

   * The structure of the inventory hosts and groups is flat. The jail
     ``ansible-test`` is the same in all groups.

   * See the special variable `group_names`_.

.. warning::

   There are no internal checks for hosts overriding each
   other. Maintaining inventory consistency is up to the user.

   See :ref:`ug_qa_inventory_flat`.

Playbook pb-test-vmm.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-vmm.yml
   :language: yaml+jinja

Playbook output - Display jails running on hosts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-vmm.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:
