.. _ag_setup_plugins:

Plugins
-------

.. contents::
   :local:
   :depth: 1

Tested plugins
^^^^^^^^^^^^^^

To install plugins into this collection, see ``setup/vars/plugins.yml``. The
dictionary ``plugins`` tracks tested plugins:

.. code-block:: yaml

   plugins:
     inventory:
       iocage: preinstalled in distfiles
     modules:
       iocage: https://raw.githubusercontent.com/vbotka/ansible-iocage
       ucl: https://raw.githubusercontent.com/vbotka/ansible-ucl

Specify the plugins you want to install in the ``plugins_install`` dictionary
located in ``setup/vars/plugins_install.yml``, then run the playbook:

.. code-block:: console

   shell> cd setup
   shell> ansible-playbook setup.yml -t plugins

Other plugins
^^^^^^^^^^^^^

To install other plugins into this collection, update the ``plugins``
dictionary. In addition, update the following files:

* ``setup/vars/branch.yml``
* ``setup/vars/checksum.yml``
* ``setup/vars/patch.yml`` and ``setup/files`` (if necessary)

.. seealso:: :ref:`dg_update_iocage_module`

.. warning::

   * Upgrading the collection will overwrite your changes. Back up your changes
     before upgrading.

   * This collection does not provide an upgrade procedure that preserves custom
     modifications. You are responsible for restoring your changes after an
     upgrade.
