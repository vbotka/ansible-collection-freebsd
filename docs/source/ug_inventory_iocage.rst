.. _ug_inventory_iocage:

Inventory vbotka.freebsd.iocage
-------------------------------

The `inventory plugin vbotka.freebsd.iocage`_ gets the inventory from the `iocage`_ jail
manager.

.. toctree::
   :maxdepth: 1

   ug_inventory_iocage_basics
   ug_inventory_iocage_dhcp
   ug_inventory_iocage_hooks
   ug_inventory_iocage_properties
   ug_inventory_iocage_tags
   ug_inventory_iocage_aliases

.. note::

   This plugin:

   * requires `sysutils-iocage`_
   * extends `inventory plugin ansible.builtin.constructed`_. See the `Examples`_.
   * implements inventory caching. See `Enabling inventory cache plugins`_.

.. seealso::

   * Ansible Galaxy `inventory plugin vbotka.freebsd.iocage`_
   * `iocage - A FreeBSD Jail Manager`_
   * `man iocage`_
   * `Jails and Containers`_


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage&sektion=8
.. _sysutils-iocage: https://www.freshports.org/sysutils/iocage
.. _inventory plugin ansible.builtin.constructed: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html
.. _Examples: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#examples
.. _Enabling inventory cache plugins: https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins

.. _iocage - A FreeBSD Jail Manager: https://iocage.readthedocs.io/en/latest
.. _man iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage&sektion=8
.. _Jails and Containers: https://docs.freebsd.org/en/books/handbook/jails
