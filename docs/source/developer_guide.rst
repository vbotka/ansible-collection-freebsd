.. _dg:

Developer Guide
###############

.. contents:: Table of Contents
   :depth: 2

.. seealso::

   `Developing collections <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html#developing-collections>`_.


.. _create_collection_docsite:

Create collection docsite
*************************

See `Creating a collection docsite <https://ansible.readthedocs.io/projects/antsibull-docs/collection-docs/>`_.

Upon successful build, open the local page in a browser ::
  
  file:///<path_to_collections>/collections/ansible_collections/vbotka/freebsd/dest/build/html/collections/vbotka/freebsd/index.html

Don't forget to rebuild the page after you upgrade the collection ::

  shell> cd dest
  shell> ./build.sh

.. seealso::

   * `Documenting collections <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_documenting.html#documenting-collections>`_.
   * `docs directory <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_structure.html#docs-directory>`_.


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

   * This collection does not provide an upgrade procedure for
     preserving changes. After the upgrade, you are responsible for
     restoring your changes.
