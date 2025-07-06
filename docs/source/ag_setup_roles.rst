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
modified to use the role `vbotka.freebsd.lib`_. If there are no other dependencies on the collection
`vbotka.freebsd`_ the following comment is included in the ``README.md``

.. code-block:: text

   Optionally, use the role vbotka.ansible_lib
   -------------------------------------------
   
   This role requires the collection vbotka.freebsd to include tasks from the role
   vbotka.freebsd.lib. See in the tasks:
      
      ansible.builtin.include_role:
        name: vbotka.freebsd.lib

   Instead of the collection vbotka.freebsd, you can install and use the role
   vbotka.ansible_lib. Edit the tasks:

     ansible.builtin.include_role:
       name: vbotka.ansible_lib

If you switch to ``vbotka.ansible_lib``, remove ``vbotka.freebsd`` from the ``collections`` in
``meta/main.yml``. Then, the role can be used without the collection `vbotka.freebsd`_.

.. warning::

   Make sure the role doesn't use collection ``vbotka.freebsd`` plugins before you start editing the
   inclusions.


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

.. _vbotka.freebsd.custom_image: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/custom_image

.. _Migrating Roles to Roles in Collections on Galaxy: https://docs.ansible.com/ansible/devel/dev_guide/migrating_roles.html
