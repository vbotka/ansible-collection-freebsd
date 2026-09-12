.. _ug_inventory_iocage:

.. index:: single: inventory vbotka.freebsd.iocage; Plugins

Inventory vbotka.freebsd.iocage
-------------------------------

This ``iocage`` inventory plugin gets the inventory from the `iocage`_ jail
manager.

.. toctree::
   :maxdepth: 1

   ug_inventory_iocage_basics
   ug_inventory_iocage_dhcp
   ug_inventory_iocage_hooks
   ug_inventory_iocage_properties
   ug_inventory_iocage_tags
   ug_inventory_iocage_aliases

.. hint::

   View the documentation from the command line:

   .. code:: console

      shell> ansible-doc -t inventory vbotka.freebsd.iocage

.. note::

   This plugin:

   - requires `sysutils/iocage`_ on the jail host.

   - extends `inventory plugin ansible.builtin.constructed`_. See the
     `Examples`_.

   - implements inventory caching. See `Enabling inventory cache
     plugins`_.

.. seealso::

   - Ansible Galaxy `inventory iocage`_
   - `iocage - A FreeBSD Jail Manager`_
   - `man iocage`_
   - `Jails and Containers`_
