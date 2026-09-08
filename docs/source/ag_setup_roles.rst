.. _ag_setup_roles:

Roles
-----

.. contents::
   :local:
   :depth: 2

Namespace vbotka
^^^^^^^^^^^^^^^^

To install other roles from the `vbotka`_ namespace, see ``setup/vars/roles.yml``. The
dictionary ``bsd_roles`` maintains the list of tested roles:

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
       version: 2.7.1
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

Add the roles you want to install to the ``bsd_roles_install`` list in
``setup/vars/roles_install.yml`` and run the playbook:

.. code-block:: console

   shell> cd setup
   shell> ansible-playbook setup.yml -t roles

Manually remove obsolete versions from the ``roles`` directory.

Naming convention
"""""""""""""""""

The naming convention is structured as follows:

* GitHub repository names always begin with ``ansible-``. If a role targets FreeBSD exclusively,
  the repository name begins with ``ansible-freebsd-``.

* Ansible Galaxy role names start with the namespace ``vbotka`` followed by the repository name,
  omitting the ``ansible-`` prefix and replacing hyphens (``-``) with underscores (``_``).

* Collection role names start with ``vbotka.freebsd.`` followed by the trailing segment of the
  GitHub repository name, with hyphens (``-``) replaced by underscores (``_``).

For example:

.. csv-table::
   :header: "GitHub vbotka", "Galaxy vbotka", "Collection vbotka.freebsd"
   :widths: 30, 30, 30

   "ansible-ansible", "vbotka.ansible", "vbotka.freebsd.ansible"
   "ansible-config-light", "vbotka.config_light", "vbotka.freebsd.config_light"
   "ansible-freebsd-custom-image", "vbotka.freebsd_custom_image", "vbotka.freebsd.custom_image"

Roles imported into the Ansible Galaxy namespace `vbotka`_ and those included in the
`vbotka.freebsd`_ collection are identical. They can be used interchangeably or in parallel
without restriction.

.. note::

   Role ``README.md`` files are imported directly into the collection documentation. Their titles
   may appear misleading because they retain their Galaxy role names. For example, the
   `vbotka.freebsd.custom_image`_ documentation heading displays:

   .. code-block:: text

      freebsd_custom_image
      --------------------

      This role is included in the collection vbotka.freebsd as vbotka.freebsd.custom_image

Role vbotka.ansible_lib
"""""""""""""""""""""""

The `vbotka.ansible_lib`_ role provides independent, reusable tasks that can be imported or included
in playbooks and other roles.

.. csv-table::
   :header: "GitHub vbotka", "Galaxy vbotka", "Collection vbotka.freebsd"
   :widths: 30, 30, 30

   "ansible-lib", "vbotka.ansible_lib", "vbotka.freebsd.lib"

Several roles depend on it. When included in the `vbotka.freebsd`_ collection, dependent roles
are configured to reference the ``<name>_ansible_lib`` mapping. For example, the ``rsnapshot_ansible_lib``
dictionary:

.. code-block:: yaml

   rsnapshot_ansible_lib:
     vbotka.rsnapshot: vbotka.ansible_lib
     vbotka.freebsd.rsnapshot: vbotka.freebsd.lib

resolves to ``vbotka.ansible_lib`` or ``vbotka.freebsd.lib`` depending on whether the role is running
inside the collection context:

.. code-block:: yaml

   - name: "Vars: Include OS vars."
     vars:
       al_os_vars_path: "{{ ansible_parent_role_paths.0 }}"
     ansible.builtin.include_role:
       name: "{{ rsnapshot_ansible_lib[ansible_role_name] }}"
       tasks_from: al_include_os_vars_path

.. seealso::

   The special variable `ansible_role_name`_

Other dependent roles
"""""""""""""""""""""

Other inter-role dependencies follow the same pattern. For example, the `vbotka.freebsd.zfs`_ role
depends on `vbotka.freebsd.postinstall`_. The ``fzfs_freebsd_postinstall`` dictionary:

.. code-block:: yaml

   fzfs_freebsd_postinstall:
     vbotka.freebsd_zfs: vbotka.freebsd_postinstall
     vbotka.freebsd.zfs: vbotka.freebsd.postinstall

resolves to ``vbotka.freebsd_postinstall`` or ``vbotka.freebsd.postinstall`` based on the runtime context:

.. code-block:: yaml

   - name: "Sysctl: Include vbotka.freebsd.postinstall sysctl"
     ansible.builtin.include_role:
       name: "{{ fzfs_freebsd_postinstall[ansible_role_name] }}"
       tasks_from: sysctl.yml
       apply:
         tags: fzfs_sysctl
         vars:
           fp_sysctl_conf: "{{ fzfs_sysctl_conf }}"
           fp_sysctl_tuneables_warning: "{{ fzfs_sysctl_tuneables_warning | bool }}"

Other roles
^^^^^^^^^^^

To add custom or external roles to this collection, update the ``bsd_roles`` dictionary.

.. seealso::

   `Migrating Roles to Roles in Collections on Galaxy`_.

.. note::

   To install roles outside this collection, see
   `Installing roles <https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles>`_.

.. warning::

   * Upgrading the collection will overwrite your changes. Back up your modifications before upgrading.
   * This collection does not provide an upgrade procedure that preserves local modifications. You are responsible for reapplying your changes after an upgrade.


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
.. _ansible_role_name: https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#term-ansible_role_name