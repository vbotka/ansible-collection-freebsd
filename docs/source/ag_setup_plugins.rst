.. _ag_setup_plugins:

Plugins
-------

Tested plugins
^^^^^^^^^^^^^^
  
If you want to install other plugins into this collection see *bsd_plugins*. This dictionary keeps
tested plugins. Update *bsd_plugins_install* with the plugins you want to install and run the play ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t plugins


Other plugins
^^^^^^^^^^^^^

If you want to install other plugins into this collection update the dictionary *bsd_plugins*.


Upgrade plugins
^^^^^^^^^^^^^^^

This collection's new releases will come with current plugin versions in the dictionary
*bsd_plugins*. Fit the variable *bsd_plugins_install* to your needs and upgrade the plugins ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t plugins

.. seealso:: :ref:`dg_update_iocage_module`

.. warning::

   * The collection upgrade will override the changes. Backup your
     changes before you upgrade the collection.

   * This collection does not provide an upgrade procedure to preserve
     changes. After the upgrade, you are responsible for restoring
     your changes.
