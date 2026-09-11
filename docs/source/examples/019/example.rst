.. _example_019:

019 Inventory option use_vars_plugins
-------------------------------------

Extending :ref:`example_016`.

.. contents::
   :local:
   :depth: 1

.. index:: single: inventory vbotka.freebsd.iocage; Example 019
.. index:: single: inventory ansible.builtin.constructed; Example 019

.. index:: single: option use_vars_plugins; Example 019
.. index:: single: use_vars_plugins; Example 019
.. index:: single: option compose; Example 019
.. index:: single: compose; Example 019
.. index:: single: option groups; Example 019
.. index:: single: groups; Example 019

.. index:: single: vars plugin ansible.builtin.host_group_vars; Example 019
.. index:: single: variable region; Example 019

Use case
^^^^^^^^

The option `use_vars_plugins`_, responsible for reading ``host_vars``
and ``group_vars`` directories, is not available in the `inventory
plugin vbotka.freebsd.iocage`_ because the `constructed fragment`_
does not provide it.

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
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   ├── 99_constructed.yml
  │   └── group_vars
  │       ├── test_02
  │       │   └── region.yml
  │       └── test_04
  │           └── region.yml
  ├── pb-test-all.yml
  └── pb-test-EU.yml

Synopsis
^^^^^^^^

* The :ref:`ug_inventory_iocage` retrieves the jails
  (managed nodes):

  * ``test_111:113`` from host ``iocage_02``
  * ``test_131:133`` from host ``iocage_04``

  and creates inventory groups ``test_02`` and ``test_04``.

* The inventory plugin `ansible.builtin.constructed`_ creates the
  inventory groups:

  * ``test`` comprising hosts whose names start with ``'test'``
  * ``test_up`` comprising running hosts whose names start with ``'test'``
  * ``region_EU`` comprising hosts where the variable ``region`` is ``'EU'``
  * ``region_US`` comprising hosts where the variable ``region`` is ``'US'``

Notes
^^^^^

* The inventory files in the directory ``hosts`` are evaluated in
  alphabetical order.

.. seealso::

   * `Documentation fragments`_
   * The `vars plugin ansible.builtin.host_group_vars`_
   * :ref:`example_016`

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 2

group_vars
^^^^^^^^^^

.. literalinclude:: hosts/group_vars/test_02/region.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/group_vars/test_04/region.yml
   :language: yaml+jinja
   :caption:

.. hint::

   Run the command below to see the complete inventory::

     shell> ansible-inventory -i hosts --list --yaml

.. warning::

   In the inventory plugin `ansible.builtin.constructed`_:

   * The option `use_vars_plugins`_ reads the **inventory**
     ``group_vars`` and ``host_vars``.

   * The **playbook** ``group_vars`` and ``host_vars`` will be
     silently ignored.

   See `Variable precedence. Where should I put a variable?`_

Playbook pb-test-all.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
   :language: yaml+jinja

Playbook output - List groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-all.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-EU.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-EU.yml
   :language: yaml+jinja

Playbook output - EU running hosts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the EU region to running hosts.

.. code-block:: console

   (env) > ansible-playbook -i hosts -l test_up pb-test-EU.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:
