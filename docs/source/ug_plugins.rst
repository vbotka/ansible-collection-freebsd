.. _ug_plugins:

Plugins
*******

.. contents:: Table of Contents
   :depth: 3


Installed plugins
-----------------
	   
This collection is shipped with plugins:

* module vbotka.freebsd.iocage
* inventory vbotka.freebsd.iocage

Installed plugins documentation
-------------------------------

.. _ug_module_iocage:

Module vbotka.freebsd.iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: man/module-iocage.txt


.. _ug_inventory_iocage:

Inventory vbotka.freebsd.iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This inventory plugin:

* extends inventory plugin `ansible.builtin.constructed <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#ansible-builtin-constructed-inventory-uses-jinja2-to-construct-vars-and-groups-based-on-existing-inventory>`_. See the `Examples <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/constructed_inventory.html#examples>`_.

* implements inventory caching. See `Enabling inventory cache plugins <https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins>`_.

.. literalinclude:: man/inventory-iocage.txt
