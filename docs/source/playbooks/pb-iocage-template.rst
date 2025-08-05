pb-iocage-template
------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: playbook pb-iocage-template.yml; pb-iocage-template
.. index:: single: act_user; pb-iocage-template
.. index:: single: act_pk; pb-iocage-template
.. index:: single: act_sudo; pb-iocage-template
.. index:: single: act_rcconf; pb-iocage-template
.. index:: single: act_dhclient; pb-iocage-template
.. index:: single: pkglist; pb-iocage-template

Synopsis
^^^^^^^^

This playbook creates `iocage templates`_ from the dictionary ``templates``. For example,

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
       pkglist: "{{ inventory_dir }}/files/pkgs.json"

creates the template ``ansible_client``

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

   Take a look at Index and search ``playbook pb-iocage-template.yml`` to see what examples are
   available.

Ansible Client Template variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A few variables are required to configure a template for Ansible clients. The below variables are
mandatory. Some of them are used as defaults. See the playbook tasks to learn details.

.. code-block:: yaml

   act_user: ''
   act_pk: ''
   act_sudo: false
   act_rcconf: {}
   act_dhclient: {}

.. seealso::

   * `Setting the Python interpreter`_
   * `Understanding privilege escalation`_

act_user
""""""""

Create a user in the jail. Usually, this user will be used as a ``remote_user`` to connect to the
jail.

.. code-block:: yaml

   act_user: admin

.. seealso::

   * `Setting a remote user`_
  
act_pk
""""""

A path to a file comprising the public keys allowed to connect to the ``act_user`` at the jail.

.. code-block:: yaml

   act_pk: pk_admins.txt

.. warning::

   The module `ansible.posix.authorized_key`_, used in this task, is not jail-aware. The user
   ``act_user`` must exist on the iocage host. Otherwise, the module `ansible.posix.authorized_key`_
   will crash.

act_sudo
""""""""

Add ``act_user`` to ``/root/usr/local/etc/sudoers``

.. code-block:: yaml

   act_sudo: true

The below passwordless entry will be created

.. code-block:: yaml

   line: "{{ _act_user }} ALL=(ALL) NOPASSWD: ALL"

.. note::

   See `Understanding privilege escalation`_
  
act_rcconf
""""""""""

Configure ``/root/etc/rc.conf``

.. code-block:: yaml

   act_rcconf:
     iocage_enable: '"YES"'
     sshd_enable: '"YES"'

act_dhclient
""""""""""""

Create ``dhclient`` hooks

.. code-block:: yaml

   act_dhclient:
     dhclient-exit-hooks: |
       case "$reason" in
           "BOUND"|"REBIND"|"REBOOT"|"RENEW")
           echo $new_ip_address > /var/db/dhclient-hook.address.$interface
           ;;
       esac

.. note::

   * These *hooks* are needed to configure ``hooks_results`` in `inventory plugin vbotka.freebsd.iocage`_
   * See `man dhclient-script`_

pkglist
^^^^^^^

``pkglist`` is an optional attribute of the dictionary ``templates``. The value is a path on the
iocage host where the file ``pkgs.json`` will be copied to. See the option ``--pkglist`` in `man
iocage`_

.. code-block::

   templates:
     ansible_client:
       pkglist: tmp/ansible/ansible_client/pkgs.json
       ...

Create the file ``files/pkgs.json``. For example,

.. code-block:: json

   {
       "pkgs": [
           "python311",
           "sudo"
           ]
   }

Fit the list to your needs. Usually, you want to add ``gtar`` and other archivers. See the module
`ansible.builtin.unarchive`_. Add ``py-openssl`` if you want to use the collection
`community.crypto`_

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

   ``iocage`` tests DNS on installing the packages::

     Testing Host DNS response to pkg.freebsd.org
     2025/08/06 01:18:12 (INFO) Testing ansible_client's SRV response to pkg.freebsd.org
     2025/08/06 01:18:12 (INFO) Testing ansible_client's DNSSEC response to pkg.freebsd.org

.. seealso::

  `Install package inside jail vs install package from outside`_

Workflow
^^^^^^^^

The last tasks ``template.yml`` convert the jails to templates. If you start the play again the first
tasks ``setup.yml`` ends the host(s) if all templates have already been created. If you want to
reconfigure already created template set ``template=0`` manually. For example,

.. code-block:: console

   shell> iocage set template=0 ansible_client

If a running jail is needed start it

.. code-block:: console

   shell> iocage start ansible_client

Then, use the playbook tags to execute selected tasks. For example, to install packages

.. code-block:: console

   (env) > ansible-playbook pb-iocage-template.yml -t pkg

After the reconfiguration stop the jail and convert it to the template manually

.. code-block:: console

   shell> iocage stop ansible_client
   shell> iocage set template=1 ansible_client

, or by the play

.. code-block:: console

   (env) > ansible-playbook pb-iocage-template.yml -t stop,template


.. _Setting the Python interpreter: https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html#setting-the-python-interpreter
.. _Understanding privilege escalation: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html
.. _Setting a remote user: https://docs.ansible.com/ansible/latest/inventory_guide/connection_details.html

.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/

.. _community.crypto: https://galaxy.ansible.com/ui/repo/published/community/crypto/

.. _ansible.builtin.unarchive: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html#notes
.. _ansible.posix.authorized_key: https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html
.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html

.. _iocage templates: https://iocage.readthedocs.io/en/latest/templates.html
.. _man iocage: https://man.freebsd.org/cgi/man.cgi?iocage(8)
.. _man dhclient-script: https://man.freebsd.org/cgi/man.cgi?dhclient-script(8)
.. _Install package inside jail vs install package from outside: https://forums.freebsd.org/threads/install-package-inside-jail-vs-install-package-from-outside.54123/
