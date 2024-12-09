.. _dg_update_iocage_module:

Update iocage module
********************

* Clone the git repository https://github.com/vbotka/ansible-iocage.git

* Switch to the branch *current*

* Make changes to the branch *current* or create new branch

* Update the code and commit the changes. You are encouraged to
  submit a PR.

* Calculate iocage.yml hash. For example, ::

    shell> sha512sum iocage.py

* To reflect your changes, update in the collection:

  * the checksum *setup/vars/checksum.yml*

  * the patch *setup/files/module-iocage.patch* if needed

  * the dictionary *bsd_plugins.modules.iocage* in the file *setup/vars/plugins.yml*

  * optionally, update *setup/vars/plugins_all.yml* ::

      shell> cd setup
      shell> ansible-playbook .configure.yml -t create_plugins_all
                                             -e create_plugins_all=true
                                             -e i_know_what_i_am_doing=true

  * Update *plugins/modules/iocage.py* ::

      shell> cd setup
      shell> ansible-playbook setup.yml -t plugins

    The *plugins* tasks are not idempotent if a patch is present.

.. warning::

   * The collection upgrade will override the changes. Backup your
     changes before you upgrade the collection.

   * This collection does not provide an upgrade procedure to
     preserve changes. After the upgrade, you are responsible for
     restoring your changes.
