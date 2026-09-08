.. _dg_update_iocage_module:

Update iocage module
********************

* Clone the Git repository: https://github.com/vbotka/ansible-iocage.git

* Switch to the branch ``current``.

* Make changes to the ``current`` branch or create a new branch.

* Update the code and commit your changes. (Pull requests are welcome!)

* Calculate the ``iocage.py`` hash. For example::

    shell> sha512sum iocage.py

* To incorporate your changes, update the following in the collection:

  * The checksum in ``setup/vars/checksum.yml``

  * The patches in ``setup/files/module-iocage.*.patch`` (if needed)

  * The dictionary entry ``plugins.modules.iocage`` in ``setup/vars/plugins.yml``

* Review ``setup/vars/plugins_install.yml`` and update ``plugins/modules/iocage.py``::

    shell> cd setup
    shell> ansible-playbook setup.yml -t plugins

.. note::

   The ``plugins`` tasks are not idempotent if a patch is present.

.. warning::

   * Upgrading the collection will overwrite your changes. Back up your changes
     before upgrading.

   * This collection does not provide an upgrade procedure that preserves local
     modifications. You are responsible for restoring your changes after an
     upgrade.
