.. _ag_setup_roles:

Roles
-----

.. contents::
   :local:
   :depth: 2

Namespace vbotka
^^^^^^^^^^^^^^^^
  
If you want to install other roles from the namespace `vbotka`_, see ``setup/vars/roles.yml``. The
dictionary ``bsd_roles`` keeps the tested roles

.. code-block:: yaml
   :force:

   bsd_roles:
     - galaxy: vbotka.ansible
       name: ansible
       scm: git
       src: https://github.com/vbotka/ansible-ansible
       version: 2.7.1
     - galaxy: vbotka.ansible_lib
       name: lib
       scm: git
       src: https://github.com/vbotka/ansible-lib
       version: 2.7.0
       ...
     - galaxy: vbotka.config_light
       name: config_light
       scm: git
       src: https://github.com/vbotka/ansible-config-light
       version: 2.7.
       ...
     - galaxy: vbotka.freebsd_custom_image
       name: custom_image
       scm: git
       src: https://github.com/vbotka/ansible-freebsd-custom-image
       version: 2.7.5
     - galaxy: vbotka.freebsd_dns
       name: dns
       scm: git
       src: https://github.com/vbotka/ansible-freebsd-dns
       version: 2.6.2
       ...

Put the roles you want to install into the list ``bsd_roles_install`` in
``setup/vars/roles_linstall.yml`` and run the play

.. code-block:: console

   shell> cd setup
   shell> ansible-playbook setup.yml -t roles

Manually remove obsolete versions from the directory ``roles``.

Naming convention
"""""""""""""""""

The naming convention is simple:

* The GitHub repositories' names always start with ``ansible-``. If a role works with FreeBSD only,
  the GitHub name starts with ``ansible-freebsd``.

* The Ansible Galaxy roles' names start with the namespace ``vbotka`` and follow with the GitHub name
  without the prefix ``ansible-`` where dashes ``-`` are replaced with underscores ``_``.

* The collection roles' names start with ``vbotka.freebsd`` and follow with the last parts of the
  GitHub names where dashes ``-`` are replaced by underscores ``_``.

For example,

.. csv-table::
   :header: "GitHub vbotka", "Galaxy vbotka", "Collection vbotka.freebsd"
   :widths: 30, 30, 30

   "ansible-ansible", "vbotka.ansible", "vbotka.freebsd.ansible"
   "ansible-config-light", "vbotka.config_light", "vbotka.freebsd.config_light"
   "ansible-freebsd-custom-image", "vbotka.freebsd_custom_image", "vbotka.freebsd.custom_image"

The roles imported in the Ansible Galaxy namespace `vbotka`_ and included in the collection
`vbotka.freebsd`_ are identical. You can use them in parallel or interchange them without
restrictions.

.. note::

   The roles' files ``README.md`` are imported in the collection documentation. The titles might
   be misleading because they keep the Galaxy names. For example, the role
   `vbotka.freebsd.custom_image`_ documentation says:

   .. code-block:: text
      
     freebsd_custom_image
     --------------------

     This role is included in the collection vbotka.freebsd as vbotka.freebsd.custom_image

Role vbotka.ansible_lib
"""""""""""""""""""""""

The role `vbotka.ansible_lib`_ comprises independent tasks. The purpose is providing a library of
reusable tasks that can be included in playbooks and other roles.

.. csv-table::
   :header: "GitHub vbotka", "Galaxy vbotka", "Collection vbotka.freebsd"
   :widths: 30, 30, 30

   "ansible-lib", "vbotka.ansible_lib", "vbotka.freebsd.lib"

Some roles depend on it. If such roles are included in the collection `vbotka.freebsd`_ they are
modified to use the dictionary ``<name>__ansible_lib``. For example, the dictionary ``rsnapshot_ansible_lib``

.. code-block:: yaml

   rsnapshot_ansible_lib:
     vbotka.rsnapshot: vbotka.ansible_lib
     vbotka.freebsd.rsnapshot: vbotka.freebsd.lib

is used to select ``vbotka.ansible_lib`` or ``vbotka.freebsd.lib`` depending on the role running in
the collection or not. For example,

.. code-block:: yaml

   - name: "Vars: Include OS vars."
     vars:
       al_os_vars_path: "{{ ansible_parent_role_paths.0 }}"
     ansible.builtin.include_role:
       name: "{{ rsnapshot_ansible_lib[ansible_role_name] }}"
       tasks_from: al_include_os_vars_path

Other dependent roles
"""""""""""""""""""""

There might be other dependent roles. See for example, the role `vbotka.freebsd.zfs`_ depends on the
role `vbotka.freebsd.postinstall`_. The procedures, described in the previous chapter, apply also
here. With minimal modifications, it is possible to use a standalone role, for example
`vbotka.freebsd_zfs`_, depending on the role `vbotka.freebsd_postinstall`_.

Other roles
^^^^^^^^^^^

If you want to install other roles into this collection update the dictionary ``bsd_roles``.

.. seealso::

   `Migrating Roles to Roles in Collections on Galaxy`_.

.. note::

   To install roles outside this collection see
   `Installing roles <https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles>`_.

.. warning::

   * The collection upgrade will override the changes. Backup your changes before you upgrade the
     collection.

   * This collection does not provide an upgrade procedure that preserve changes. After the upgrade,
     you are responsible for restoring your changes.


.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka.freebsd.lib: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/lib
.. _vbotka.ansible_lib: https://galaxy.ansible.com/ui/standalone/roles/vbotka/ansible_lib

.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd_zfs: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_zfs
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall

.. _vbotka.freebsd.custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image

.. _Migrating Roles to Roles in Collections on Galaxy: https://docs.ansible.com/ansible/devel/dev_guide/migrating_roles.html
