.. _example_019:

019 Inventory option use_vars_plugins
-------------------------------------

This example extends :ref:`example_018`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: inventory groups; Example 019
   single: inventory vbotka.freebsd.iocage; Example 019
   single: inventory ansible.builtin.constructed; Example 019
   single: option use_vars_plugins; Example 019
   single: use_vars_plugins; Example 019
   single: option compose; Example 019
   single: compose; Example 019
   single: option groups; Example 019
   single: groups; Example 019
   single: option keyed_groups; Example 019
   single: keyed_groups; Example 019
   single: ansible.builtin.host_group_vars; Example 019

Use case
^^^^^^^^

The option `use_vars_plugins`_, responsible for reading ``host_vars``
and ``group_vars`` directories, is not available in the
:ref:`inventory vbotka.freebsd.iocage <ug_inventory_iocage>` because
the `constructed fragment`_ does not provide it.

* Use the inventory plugin `ansible.builtin.constructed`_ to read
  ``group_vars``.

* Use the variable ``region`` to create the groups ``region_EU`` and
  ``region_US``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   ├── 06_iocage.yml
  │   ├── 99_constructed.yml
  │   └── group_vars
  │       ├── test_CA
  │       │   └── region.yml
  │       └── test_NL
  │           └── region.yml
  ├── pb-test-all.yml
  └── pb-test-region.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * The :ref:`inventory vbotka.freebsd.iocage <ug_inventory_iocage>`
    retrieves the jails:

    * ``test_511:513`` from host ``iocage_05``.
    * ``test_611:613`` from host ``iocage_06``.

    and creates the inventory groups ``test_CA`` and ``test_NL``.

  * The inventory plugin `ansible.builtin.constructed`_ creates the
    inventory groups:

    * ``test`` comprising hosts whose names start with ``'test'``.
    * ``test_up`` comprising running hosts whose names start with ``'test'``.
    * ``region_EU`` comprising hosts where the variable ``region`` is ``'EU'``.
    * ``region_US`` comprising hosts where the variable ``region`` is ``'US'``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Jails created in :ref:`example_018`.

Notes
^^^^^

* The inventory files in the directory ``hosts`` are evaluated in
  alphabetical order.

.. seealso::

   * `Documentation fragments`_
   * The `vars plugin ansible.builtin.host_group_vars`_
   * :ref:`example_018`

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

.. hint::

   Run the command below to see the complete inventory::

     (env) > ansible-inventory -i hosts --list --yaml

Jails
^^^^^

.. literalinclude:: out/out-02.txt
   :language: console
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: console
   :caption: [iocage_06]# iocage list -l

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 2

group_vars
^^^^^^^^^^

.. literalinclude:: hosts/group_vars/test_CA/region.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/group_vars/test_NL/region.yml
   :language: yaml+jinja
   :caption:

.. important::

   In the inventory plugin `ansible.builtin.constructed`_:

   * The option `use_vars_plugins`_ reads the **inventory**
     ``group_vars`` and ``host_vars``.

   * The **playbook** ``group_vars`` and ``host_vars`` are
     silently ignored.

   See: `Variable precedence. Where should I put a variable?`_

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - List all jails and groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-region.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-region.yml
   :language: yaml+jinja

Playbook output - List jails in region
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-region.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force: