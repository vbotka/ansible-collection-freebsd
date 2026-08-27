.. _ag_setup_plugins:

Plugins
-------

.. contents::
   :local:
   :depth: 1

Tested plugins
^^^^^^^^^^^^^^^
  
If you want to install plugins into this collection, see ``setup/vars/plugins.yml``. The dictionary
``plugins`` keeps tested plugins

.. code-block:: yaml

   plugins:
     inventory:
       iocage: preinstalled in distfiles
     modules:
       iocage: https://raw.githubusercontent.com/vbotka/ansible-iocage
       ucl: https://raw.githubusercontent.com/vbotka/ansible-ucl

Put the plugins you want to install into the dictionary ``plugins_install`` in
``setup/vars/plugins_install.yml`` and run the play

.. code-block:: console

   shell> cd setup
   shell> ansible-playbook setup.yml -t plugins

Other plugins
^^^^^^^^^^^^^

If you want to install other plugins into this collection, update the dictionary ``plugins``. In
addition to this, you have to update:

* ``setup/vars/branch.yml``

* ``setup/vars/checksum.yml``

* ``setup/vars/patch.yml`` and ``setup/files`` if necessary.

.. seealso:: :ref:`dg_update_iocage_module`

.. warning::

   * The collection upgrade will override the changes. Backup your changes before you upgrade the
     collection.

   * This collection does not provide an upgrade procedure that preserve changes. After the upgrade,
     you are responsible for restoring your changes.
