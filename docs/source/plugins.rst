.. _plugins:

Plugins
#######

.. contents:: Table of Contents
   :depth: 3

Installed plugins
*****************
	   
This collection is shipped with plugins:

* module vbotka.freebsd.iocage
* inventory vbotka.freebsd.iocage


Tested plugins
**************
  
If you want to install other plugins into this collection see *bsd_plugins*. This dictionary keeps
tested plugins. Update *bsd_plugins_install* with the plugins you want to install and run the play ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t plugins


Other plugins
*************

If you want to install other plugins into this collection update the dictionary *bsd_plugins*.

.. warning::

   * The collection upgrade will override the changes. Backup your
     changes before you upgrade the collection.

   * This collection does not provide an upgrade procedure to preserve
     changes. After the upgrade, you are responsible for restoring
     your changes.


Upgrade plugins
***************

This collection new releases will come with current plugins versions in the dictionary
*bsd_plugins*. Fit the variable *bsd_plugins_install* to your needs and upgrade the plugins ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t plugins


.. seealso:: :ref:`dg_update_iocage_module`


Installed plugins documentation
*******************************

.. _module_iocage:

Module vbotka.freebsd.iocage
----------------------------

.. literalinclude:: man/module-iocage.txt


.. _inventory_iocage:

Inventory vbotka.freebsd.iocage
-------------------------------

.. literalinclude:: man/inventory-iocage.txt
