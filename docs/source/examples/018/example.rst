.. _example_018:

018 DHCP, auto UUID, and aliases
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: clones; Example 018
   single: module vbotka.freebsd.iocage; Example 018
   single: inventory vbotka.freebsd.iocage; Example 018
   single: DHCP; Example 018
   single: option inventory_hostname_tag; Example 018
   single: alias; Example 018
   single: option sudo; Example 018
   single: sudo; Example 018
   single: host_hostuuid; Example 018

Use case
^^^^^^^^

Clone basejails. Use `DHCP`_ to configure the interfaces. Automatically generate
jails ``UUID`` for jails and configure `inventory aliases`_.

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
  ├── pb-iocage-base.yml
  ├── pb-iocage-clone.yml
  ├── pb-iocage-destroy.yml
  ├── pb-iocage-start.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-iocage-base.yml``, use the :ref:`module
    vbotka.freebsd.iocage <ug_module_iocage>` to:

    * Create the basejail ``ansible-test``.

  * In the playbook ``pb-iocage-clone.yml``, use the :ref:`module
    vbotka.freebsd.iocage <ug_module_iocage>` to:

    * Clone 3 jails from ``ansible-test``:

      * Automatically generate jails ``UUID``.
      * Configure `inventory aliases`_.

    * Display `iocage datasets`_.

  * In the playbook ``pb-iocage-start.yml``, use `iocage`_ to:

    * Start cloned jails.

  * Use the :ref:`inventory plugin vbotka.freebsd.iocage <ug_inventory_iocage>` to:

    * Compose variables and create inventory groups.

* On the jails in the group ``example_018``:

  * In the playbook ``pb-test.yml``:

    * Display the jails, groups, :ref:`ug_concepts_iocage_tags`, and selected
      variables.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`

.. seealso::

   * :ref:`example_440`

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
   :emphasize-lines: 6

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 6

.. note::

   * The value of iocage tag ``alias`` is used as `inventory alias`_.

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   * The keys of the ``clones`` dictionaries are used as `inventory alias`_.

Playbook pb-iocage-base.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-base.yml
   :language: yaml+jinja

Playbook output - Create basejails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-base.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-iocage-clone.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-clone.yml
   :language: yaml+jinja
   :emphasize-lines: 13

.. important::

   Quoting option ``name`` from :ref:`inventory iocage <ug_inventory_iocage>`: ::

     States `present, cloned, template, basejail, thickjail' will return `uuid'
     and `uuid_short' if `name' is `None' or empty.

   :ref:`ug_inventory_iocage`

.. note::

   * :ref:`ug_concepts_iocage_tags` ``alias``, ``vmm``, and ``class`` are
     created from ``notes``.

Playbook output - Create clones
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-clone.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Graph
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-iocage-start.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-start.yml
   :language: yaml+jinja

Playbook output - Start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-iocage-start.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display variables and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:
