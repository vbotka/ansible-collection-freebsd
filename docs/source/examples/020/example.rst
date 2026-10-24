.. _example_020:

020 Inventory option hooks_results
----------------------------------

This example extends :ref:`example_018`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: option hooks_results; Example 020
   single: hooks_results; Example 020
   single: variable iocage_hooks; Example 020
   single: iocage_hooks; Example 020
   single: swarms; Example 020
   single: swarms destroy; Example 020
   single: inventory vbotka.freebsd.iocage2; Example 020
   single: inventory ansible.builtin.constructed; Example 020
   single: option inventory_hostname_required; Example 020
   single: inventory_hostname_required; Example 020
   single: option inventory_hostname_tag; Example 020
   single: inventory_hostname_tag; Example 020
   single: iocage tag alias; Example 020
   single: inventory alias; Example 020
   single: alias; Example 020
   single: option compose; Example 020
   single: compose; Example 020
   single: option iocage --count; Example 020

Use case
^^^^^^^^

In the :ref:`inventory vbotka.freebsd.iocage2 <ug_inventory_iocage2>`, use the
option :ref:`hooks_results <ug_inventory_iocage_hooks>` to get the IP address
set by DHCP. Use the option :ref:`inventory_hostname_tag
<ug_inventory_iocage_aliases>` to specify which iocage tag to create aliases
from. Get the `inventory aliases`_ from the `jail property`_ ``notes``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── swarms.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  ├── pb-iocage-swarms-create.yml
  ├── pb-iocage-swarms-destroy.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-iocage-swarms-create.yml``:

    * Create jails using the template ``ansible-client`` and the ``--count``
      option.

    * For each jail, set the property ``notes`` in the format
      ``tag1=val1 tag2=val2 ...``.

    * In the ``notes``, set the inventory alias ``alias=<alias>``.

    * In the :ref:`inventory plugin vbotka.freebsd.iocage2
      <ug_inventory_iocage2>`:

      * Create the variable ``ansible_host`` from the first item of the
        list ``iocage_hooks``.

      * Retrieve the inventory aliases from the iocage tag ``alias``.

    * In the inventory plugin `ansible.builtin.constructed`_:

      * Create inventory groups.

* On the jails in the group ``project_example_020``:

  * In the playbook ``pb-test.yml``:

    * Display the jails, groups, iocage tags, and selected variables.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage2`
* Templates created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* TBD

.. seealso::

   * `Inventory aliases`_
   * `Set Jail Property`_
   * :ref:`example_016`

Templates
^^^^^^^^^

.. literalinclude:: out/out-01.txt
   :language: bash
   :caption: [iocage_05]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_06]# iocage list -lt

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

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-6

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-6

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in alphabetical
     order.

   * The value of the iocage tag ``alias`` is used as the :ref:`inventory alias
     <ug_inventory_iocage_aliases>`.

   * The content of the files listed in ``hooks_results`` is stored in
     the list ``iocage_hooks``.

   * The hook :ref:`dhclient-exit-hooks <ug_inventory_iocage_hooks>` is
     configured in the template :ref:`ansible-client <example_202>`.

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/swarms.yml
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

Playbook pb-iocage-swarms-create.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-swarms-create.yml
   :language: yaml+jinja

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-swarms-create.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-04.txt
   :language: console
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

.. hint::

   Run the command below to see the complete inventory::

     shell> ansible-inventory -i hosts --list --yaml

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
