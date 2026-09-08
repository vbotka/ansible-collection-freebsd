pb_iocage_template
------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: pb_iocage_template.yml; pb_iocage_template
.. index:: single: act_pkg; pb_iocage_template
.. index:: single: act_user; pb_iocage_template
.. index:: single: act_pk; pb_iocage_template
.. index:: single: act_sudo; pb_iocage_template
.. index:: single: act_rcconf; pb_iocage_template
.. index:: single: act_dhclient; pb_iocage_template
.. index:: single: pkglist; pb_iocage_template
.. index:: single: option iocage --pkglist; pb_iocage_template

Synopsis
^^^^^^^^

This playbook creates `iocage templates`_ from the dictionary ``templates``. For
example:

.. code-block:: yaml

   templates:
     ansible_client:
       release: 14.3-RELEASE
       properties:
         bpf: 'on'
         dhcp: 'on'
         vnet: 'on'
       dhclient: "{{ act_dhclient | dict2items }}"
       rcconf: "{{ act_rcconf | dict2items }}"
       pkglist: /tmp/ansible/ansible_client/pkgs.json

This configuration creates the template ``ansible_client``:

.. code-block:: console

   shell> iocage list -lt
   +------+----------------+------+-------+----------+-----------------+--------------------+-----+----------+----------+
   | JID  |      NAME      | BOOT | STATE |   TYPE   |     RELEASE     |        IP4         | IP6 | TEMPLATE | BASEJAIL |
   +======+================+======+=======+==========+=================+====================+=====+==========+==========+
   | None | ansible_client | off  | down  | template | 14.3-RELEASE-p1 | DHCP (not running) | -   | -        | no       |
   +------+----------------+------+-------+----------+-----------------+--------------------+-----+----------+----------+

.. note::

   * The attributes ``release`` and ``properties`` are mandatory.
   * The lists ``dhclient`` and ``rcconf`` can be empty.
   * The attribute ``pkglist`` is optional.

.. hint::

   Look at the ``Index`` and search the playbook ``pb_iocage_template.yml`` to
   see what examples are available.

.. important::

   This playbook provides entry-level functionality to test iocage templates.
   Use the role `vbotka.freebsd.iocage_template`_ for advanced use cases.

Ansible Client Template variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A few variables are required to configure a template for Ansible
clients. Inspect the playbook tasks for specific implementation details.

.. code-block:: yaml

   act_pkg: []
   act_pkg_install: false
   act_user: ''
   act_pk: ''
   act_sudo: false
   act_rcconf: {}
   act_dhclient: {}

.. seealso::

   * `Setting the Python interpreter`_
   * `Understanding privilege escalation`_

act_pkg
"""""""

Install a list of packages by defining the ``template`` attribute ``act_pkg``:

.. code-block:: yaml

   templates:
     ansible_client:
       act_pkg:
         - security/sudo
         - lang/python311
       ...

If this attribute is omitted, the variable ``act_pkg`` is used instead. Below is
the minimal package list for an Ansible client (adjust the Python version as
needed):

.. code-block:: yaml

   act_pkg:
     - security/sudo
     - lang/python311

Adjust the package list to your requirements. Archiving tools like ``gtar`` are
typically needed (see `ansible.builtin.unarchive`_). If using the collection
`community.crypto`_, include ``security/py-openssl``:

.. code-block:: yaml

   act_pkg:
     - lang/python311
     - lang/python3
     - lang/python
     - security/sudo
     - archivers/gtar
     - security/py-openssl

Enable package installation by setting ``act_pkg_install: true`` (defaults to
``false``).

Notes:

* Prefer ``pkglist`` during template creation. Use ``act_pkg`` to install
  additional packages in an already created jail.

* The module `community.general.pkgng`_ is jail-aware::

    jail: Pkg will execute in the given jail name or ID.

* A short UUID does not work as a jail name; pass the ID instead::

    jail: "{{ iocage_jails[item.key]['jid'] }}"

.. seealso::

   * `Setting the Python interpreter`_
   * `Understanding privilege escalation`_

act_user
""""""""

Create a dedicated user in the jail, typically used as ``remote_user`` for
Ansible connections:

.. code-block:: yaml

   act_user: admin

.. seealso::

   * `Setting a remote user`_

act_pk
""""""

Path to a file containing public SSH keys authorized to connect as ``act_user``:

.. code-block:: yaml

   act_pk: pk_admins.txt

.. warning::

   The `ansible.posix.authorized_key`_ module used in this task is not
   jail-aware.  The user specified in ``act_user`` must also exist on the iocage
   host; otherwise, the module will fail.

act_sudo
""""""""

Grant sudo permissions to ``act_user`` in
``<dataset>/root/usr/local/etc/sudoers``:

.. code-block:: yaml

   act_sudo: true

This creates the following passwordless entry:

.. code-block:: yaml

   line: "{{ _act_user }} ALL=(ALL) NOPASSWD: ALL"

.. note::

   See `Understanding privilege escalation`_.

act_rcconf
""""""""""

Configure settings in ``<dataset>/root/etc/rc.conf``:

.. code-block:: yaml

   act_rcconf:
     iocage_enable: "YES"
     sshd_enable: "YES"

act_dhclient
""""""""""""

Create ``dhclient`` hooks in ``<dataset>/root/etc/``:

.. code-block:: yaml

   act_dhclient:
     dhclient-exit-hooks: |
       case "$reason" in
           "BOUND"|"REBIND"|"REBOOT"|"RENEW")
           echo $new_ip_address > /var/db/dhclient-hook.address.$interface
           ;;
       esac

.. note::

   * These hooks are required to configure ``hooks_results`` in the `inventory
     plugin vbotka.freebsd.iocage`_.

   * See `man dhclient-script`_.

pkglist
^^^^^^^

``pkglist`` is an optional attribute of the ``templates`` dictionary. Its value
is the destination path on the iocage host where ``pkgs.json`` is copied. See
the ``--pkglist`` option in `man iocage`_:

.. code-block:: yaml

   templates:
     ansible_client:
       pkglist: /tmp/ansible/ansible_client/pkgs.json
       ...

Create the package list in ``files/pkgs.json``:

.. code-block:: json

   {
       "pkgs": [
           "python311",
           "sudo"
       ]
   }

The task file ``pkglist.yml`` expects ``files/pkgs.json`` relative to the
inventory directory:

.. code-block:: yaml

   - name: Copy pkglist files.
     ansible.builtin.copy:
       src: "{{ inventory_dir }}/files/{{ item.value.pkglist | basename }}"
       dest: "{{ item.value.pkglist }}"
     loop: "{{ _templates }}"
     vars:
       _templates: "{{ templates | dict2items
                                 | selectattr('value.pkglist', 'defined') }}"

Customize the packages as needed. For example, add ``gtar`` for
`ansible.builtin.unarchive`_ or ``py-openssl`` for `community.crypto`_:

.. code-block:: json

   {
       "pkgs": [
           "python311",
           "sudo",
           "gtar",
           "py-openssl"
       ]
   }

.. note::

   ``iocage`` tests DNS resolution before installing packages::

      Testing Host DNS response to pkg.freebsd.org
      2025/08/06 01:18:12 (INFO) Testing ansible_client's SRV response to pkg.freebsd.org
      2025/08/06 01:18:12 (INFO) Testing ansible_client's DNSSEC response to pkg.freebsd.org

.. seealso::

   `Install package inside jail vs install package from outside`_

Workflow
^^^^^^^^

The final tasks in ``template.yml`` convert the created jails into templates. If
the playbook is run again, the initial tasks in ``setup.yml`` will end the play
for hosts whose templates already exist.

To reconfigure an existing template, unset its template state manually:

.. code-block:: console

   shell> iocage set template=0 ansible_client

If the jail must be running to apply changes, start it:

.. code-block:: console

   shell> iocage start ansible_client

Then use playbook tags to run the desired tasks. For example, to install
additional packages defined in ``act_pkg``:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_template.yml -t pkg -e act_pkg_install=true

After completing modifications, stop the jail and convert it back to a template:

.. code-block:: console

   shell> iocage stop ansible_client
   shell> iocage set template=1 ansible_client

Alternatively, perform the stop and template conversion via the playbook:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_template.yml -t stop,template


.. _Setting the Python interpreter: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter
.. _Understanding privilege escalation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html
.. _Setting a remote user: https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _community.crypto: https://galaxy.ansible.com/ui/repo/published/community/crypto/

.. _ansible.builtin.unarchive: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html#notes
.. _ansible.posix.authorized_key: https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html
.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html

.. _iocage templates: https://freebsd.github.io/iocage/templates.html
.. _man iocage: https://man.freebsd.org/cgi/man.cgi?iocage(8)
.. _man dhclient-script: https://man.freebsd.org/cgi/man.cgi?dhclient-script(8)
.. _Install package inside jail vs install package from outside: https://forums.freebsd.org/threads/install-package-inside-jail-vs-install-package-from-outside.54123/
