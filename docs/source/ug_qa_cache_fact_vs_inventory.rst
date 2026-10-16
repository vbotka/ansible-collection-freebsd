.. _ug_qa_cache_fact_vs_inventory:

.. index::
   single: cache; Q&A
   single: fact cache; Q&A
   single: inventory cache; Q&A
   single: cache_timeout; Q&A
   single: --refresh-cache; Q&A
   single: --flush-cache; Q&A

Ansible Cache Invalidation: Fact vs Inventory
---------------------------------------------

Running ``ansible-playbook ... --flush-cache`` invalidates the **fact cache**,
but it **does not clear the inventory cache**.

Overview of Cache Types
^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 25 35 40
   :header-rows: 1

   * - Cache Type
     - Path
     - Affected by ``--flush-cache``?
   * - **Fact Cache**
     - ``/var/tmp/ansible_cache/``
     - **Yes** — Invalidation forced; facts re-gathered.
   * - **Inventory Cache**
     - ``/var/tmp/inventory_cache/``
     - **No** — Handled by the inventory plugin prior to play execution.

Detailed Behavior
^^^^^^^^^^^^^^^^^

Fact Cache (``/var/tmp/ansible_cache/``)
""""""""""""""""""""""""""""""""""""""""

The ``--flush-cache`` option instructs Ansible's engine to flush host facts
gathered during previous runs. Any files corresponding to cached host facts
(such as ``s1_localhost``, ``s1_planb``) are removed or invalidated, forcing
Ansible to run fact gathering again during the play.

Inventory Plugin Cache (``/var/tmp/inventory_cache/``)
""""""""""""""""""""""""""""""""""""""""""""""""""""""

Inventory plugins process inventory and their own caching parameters (such as
``cache_plugin: ansible.builtin.jsonfile``, ``cache_prefix``, and
``cache_timeout``) **before** playbook tasks or CLI fact-cache flags take
effect.

Consequently, files such as:

.. code-block:: text

   iocage_05_s1_vbotka.freebsd.iocage_ka06f2d

will remain untouched, and the inventory plugin will serve cached inventory
until the cache expires or is manually cleared.

How to Force an Inventory Cache Refresh
---------------------------------------

To force Ansible to update the inventory cache, use any of the following
approaches:

1. Manual Removal
^^^^^^^^^^^^^^^^^

Remove the specific cached files directly from the directory:

.. code-block:: bash

   rm -f /var/tmp/inventory_cache/iocage_05_*

2. Refresh via ``ansible-inventory``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the ``--refresh-cache`` flag provided by the inventory CLI:

.. code-block:: bash

   ansible-inventory -i iocage.yml --list --refresh-cache

3. Temporarily Disable Inventory Cache via Environment Variable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bypass the inventory cache entirely for a single playbook run:

.. code-block:: bash

   ANSIBLE_INVENTORY_CACHE=False ansible-playbook pb-vars-ip4.yml -i iocage.yml
