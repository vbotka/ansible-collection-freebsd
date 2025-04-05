.. _example_019:

019 Inventory option use_vars_plugins
-------------------------------------

Extending example 016.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: option use_vars_plugins; Example 019
.. index:: single: use_vars_plugins; Example 019
.. index:: single: inventory vbotka.freebsd.iocage; Example 019
.. index:: single: inventory ansible.builtin.constructed; Example 019
.. index:: single: option compose; Example 019
.. index:: single: compose; Example 019
.. index:: single: option groups; Example 019
.. index:: single: groups; Example 019
.. index:: single: vars plugin ansible.builtin.host_group_vars; Example 019

Use case
^^^^^^^^

The option `use_vars_plugins`_, responsible for reading *host_vars* and *group_vars* directories, is
not available in the `inventory plugin vbotka.freebsd.iocage`_ because the `constructed fragment`_
doesn't provide it.

* Use the inventory plugin `ansible.builtin.constructed`_ to read *group_vars*.
* Use the variable *region* to create the groups *region_EU* and *region_US*.

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   ├── 02_iocage.yml
   │   ├── 99_constructed.yml
   │   └── group_vars
   │       ├── test_01
   │       │   └── region.yml
   │       └── test_02
   │           └── region.yml
   ├── pb-test-all.yml
   └── pb-test-US.yml

Synopsis
^^^^^^^^

* The `inventory plugin vbotka.freebsd.iocage`_ gets the jails(hosts):

  * *test_101:103* from the host *iocage_01* 
  * *test_111:113* from the host *iocage_02* 

  and creates inventory groups *test_01* and *test_02*

* The inventory plugin `ansible.builtin.constructed`_ creates the inventory groups:

  * *test* including all hosts starting *'test'*
  * *test_up* including running hosts starting ‘test’
  * *region_EU* including all hosts with the variable *region=EU*
  * *region_US* including all hosts with the variable *region=US*

Notes
^^^^^

   * The inventory files in *hosts* are evaluated in alphabetical order.

.. seealso::

   * `Documentation fragments`_
   * The `vars plugin ansible.builtin.host_group_vars`_
   * :ref:`example_016`

List all jails at iocage_01
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

List all jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini
  
Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml

Inventory *hosts/99_constructed.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/99_constructed.yml
    :language: yaml
    :emphasize-lines: 2

*hosts/group_vars/test_01/region.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/group_vars/test_01/region.yml
    :language: yaml

*hosts/group_vars/test_02/region.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/group_vars/test_02/region.yml
    :language: yaml

.. hint::

   Run the below command to see the complete inventory ::

     shell> ansible-inventory -i hosts --list --yaml

.. warning::

   * The option `use_vars_plugins`_ reads the **inventory** *group_vars* and *host_vars*
   * The **playbook** *group_vars* and *host_vars* will be silently ignored.
   * See `Variable precedence. Where should I put a variable?`_

Playbook *pb-test-all.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-all.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Playbook *pb-test-US.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-US.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

Limit the US region to running hosts

.. literalinclude:: out/out-04.txt
    :language: bash


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _use_vars_plugins: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#parameter-use_vars_plugins
.. _constructed fragment: https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/doc_fragments/constructed.py
.. _Documentation fragments: https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_documenting.html#documentation-fragments
.. _Variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
.. _vars plugin ansible.builtin.host_group_vars: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/host_group_vars_vars.html
