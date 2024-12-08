.. _roles_bsd:

Roles
#####

.. contents:: Table of Contents
   :depth: 3


Installed roles
***************

This collection is shipped with one role:

* vbotka.freebsd.iocage


Tested roles
************
  
If you want to install other roles into this collection see *bsd_roles*. This dictionary keeps
tested roles. Update *bsd_roles_install* with the roles you want to install and run the play ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t roles

Other roles
***********

If you want to install other roles into this collection update the dictionary *bsd_roles*. See
`Migrating Roles to Roles in Collections on Galaxy <https://docs.ansible.com/ansible/devel/dev_guide/migrating_roles.html>`_

.. warning::

   * The collection upgrade will override the changes. Backup your
     changes before you upgrade the collection.

   * This collection does not provide an upgrade procedure to preserve
     changes. After the upgrade, you are responsible for restoring
     your changes.

Upgrade roles
*************

This collection new releases will come with current role versions in the dictionary *bsd_roles*. Fit
the variable *bsd_roles_install* to your needs and upgrade the roles ::

  shell> cd setup
  shell> ansible-playbook setup.yml -t roles

Documented roles
****************

Some tested roles were documented at `readtthedocs.io <https://rtfd.io/>`_


* `freebsd_postinstall <https://ansible-freebsd-postinstall.readthedocs.io/en/latest/>`_
* `freebsd_poudriere <https://ansible-freebsd-poudriere.readthedocs.io/en/latest/>`_
* `freebsd_custom_image <https://ansible-freebsd-custom-image.readthedocs.io/en/latest/>`_
* `freebsd_wpa_cli <https://ansible-freebsd-wpa-cli.readthedocs.io/en/latest/>`_
* `ansible <https://ansible-ansible.readthedocs.io/en/latest/>`_
* `ansible_runner <https://ansible-runner-role.readthedocs.io/en/latest/>`_
* `apache <https://ansible-apache.readthedocs.io/en/latest/>`_
* `config_light <https://ansible-config-light.readthedocs.io/en/latest/>`_

.. note::

   To install roles outside this collection see
   `Installing roles <https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles>`_.
