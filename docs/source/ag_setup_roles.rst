.. _ag_setup_roles:

Roles
-----

Tested roles
^^^^^^^^^^^^
  
If you want to install other roles into this collection see *bsd_roles*. This dictionary keeps
tested roles. Update *bsd_roles_install* with the roles you want to install and run the play ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t roles


Other roles
^^^^^^^^^^^

If you want to install other roles into this collection update the dictionary *bsd_roles*. See
`Migrating Roles to Roles in Collections on Galaxy <https://docs.ansible.com/ansible/devel/dev_guide/migrating_roles.html>`_


Upgrade roles
^^^^^^^^^^^^^

This collection's new releases will come with current role versions in the dictionary *bsd_roles*. Fit
the variable *bsd_roles_install* to your needs and upgrade the roles ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t roles

.. note::

   To install roles outside this collection see
   `Installing roles <https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles>`_.

.. warning::

   * The collection upgrade will override the changes. Backup your
     changes before you upgrade the collection.

   * This collection does not provide an upgrade procedure to preserve
     changes. After the upgrade, you are responsible for restoring
     your changes.
