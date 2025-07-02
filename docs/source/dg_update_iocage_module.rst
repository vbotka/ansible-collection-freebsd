.. _dg_update_iocage_module:

Update iocage module
********************

* Clone the git repository https://github.com/vbotka/ansible-iocage.git

* Switch to the branch *current*

* Make changes to the branch *current* or create a new branch

* Update the code and commit the changes. You are encouraged to submit a PR.

* Calculate ``iocage.py`` hash. For example, ::

    shell> sha512sum iocage.py

* To incorporate your changes, update in the collection:

  * the checksum ``setup/vars/checksum.yml``

  * the patches ``setup/files/module-iocage.*.patch`` if needed

  * the dictionary ``plugins.modules.iocage`` in the file ``setup/vars/plugins.yml``

* See ``setup/vars/plugins_install.yml`` and update ``plugins/modules/iocage.py`` ::

    shell> cd setup
    shell> ansible-playbook setup.yml -t plugins

.. note:: The ``plugins`` tasks are not idempotent if a patch is present.

.. warning::

   * The collection upgrade will override the changes. Backup your changes before you upgrade the
     collection.

   * This collection does not provide an upgrade procedure to preserve changes. After the upgrade,
     you are responsible for restoring your changes.
