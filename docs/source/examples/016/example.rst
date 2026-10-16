.. _example_016:

016 Multiple inventory constructed
----------------------------------

This example extends :ref:`example_015`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: inventory groups; Example 016
   single: inventory ansible.builtin.constructed; Example 016
   single: option compose; Example 016
   single: compose; Example 016
   single: option groups; Example 016
   single: groups; Example 016

Use case
^^^^^^^^

Create inventory groups using the inventory plugin
`ansible.builtin.constructed`_ after loading the :ref:`inventory
vbotka.freebsd.iocage <ug_inventory_iocage>` configuration files.

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
  └── pb-test.yml

Synopsis
^^^^^^^^

* The :ref:`inventory vbotka.freebsd.iocage <ug_inventory_iocage>` retrieves the
  jails:

  * ``test_511:513`` from host ``iocage_05``.
  * ``test_611:613`` from host ``iocage_06``.

  and creates the inventory groups ``test_05`` and ``test_06``.

* The inventory plugin `ansible.builtin.constructed`_ creates the
  inventory groups:

  * ``test`` comprising hosts whose names start with ``'test'``.
  * ``test_up`` comprising running hosts whose names start with ``'test'``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Jails created in :ref:`example_013`.

Notes
^^^^^

* The inventory files in the directory ``hosts`` are evaluated in alphabetical
  order.

* See :ref:`example_015`.

* The :ref:`inventory vbotka.freebsd.iocage <ug_inventory_iocage>`
  does not provide the option `use_vars_plugins`_.

* See :ref:`example_019`.

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

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-02.txt
   :language: console
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: console
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:
