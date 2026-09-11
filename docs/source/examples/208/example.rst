.. _example_208:

208 Create iocage template for ansible-pull
-------------------------------------------

.. contents::
   :local:
   :depth: 1

TODO: Run ansible-pull on boot.

.. index:: single: ansible-pull; Example 208
.. index:: single: ansible_client_pull; Example 208
.. index:: single: template ansible_client_pull; Example 208

.. index:: single: DHCP; Example 208
.. index:: single: dhclient; Example 208
.. index:: single: dhclient-exit-hooks; Example 208

.. index:: single: module vbotka.freebsd.iocage; Example 208
.. index:: single: module community.general.sysrc; Example 208
.. index:: single: community.general.sysrc; Example 208

.. index:: single: act_user; Example 208
.. index:: single: act_pk; Example 208
.. index:: single: act_sudo; Example 208
.. index:: single: act_rcconf; Example 208
.. index:: single: act_dhclient; Example 208
.. index:: single: pkglist; Example 208
.. index:: single: pkgs.json; Example 208

Use case
^^^^^^^^

Create the `iocage`_ template ``ansible_client_pull`` that will use
`ansible-pull`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── host_vars
  │   └── iocage_04
  │       └── iocage.yml
  └── iocage.ini

Synopsis
^^^^^^^^

* On the iocage host ``iocage_04``, in the playbook
  `vbotka.freebsd.pb_iocage_template.yml`_, use the modules:

  * ``vbotka.freebsd.iocage`` to create, start, stop, and convert a jail to a template.
  * ``vbotka.freebsd.iocage`` exec to create a user and set ``.ssh`` ownership.
  * ``community.general.sysrc`` to configure ``/etc/rc.conf``.
  * ``ansible.posix.authorized_key`` to configure public keys.
  * ``ansible.builtin.lineinfile`` to configure ``/usr/local/etc/sudoers``.
  * Configure ``dhclient hooks``.

Requirements
^^^^^^^^^^^^

* Playbook `vbotka.freebsd.pb_iocage_template.yml`_
* :ref:`ug_module_iocage`
* Root privileges on the managed nodes

Notes
^^^^^

* TBD

.. seealso::

   * `Using Templates <https://freebsd.github.io/iocage/templates.html>`_
   * :ref:`ug_pb-iocage-template`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   The variables ``act_*`` are used to configure the template:

   * The user ``act_user`` will be created in the template.
   * The user ``act_user`` will serve as the Ansible ``remote_user``.
   * The file ``act_pk`` provides the public keys allowed to SSH to ``act_user``.
   * The dhclient hooks ``act_dhclient`` will be created in ``/etc``.

   Create the file ``files/pkgs.json``::

     {
         "pkgs": [
             "git",
             "python311",
             "py311-ansible",
             "sudo"
         ]
     }

.. warning::

   * The user ``act_user`` must exist on the ``iocage``
     host. Otherwise, the module ``ansible.posix.authorized_key`` will
     crash. See ``playbooks/pb_iocage_template/pk.yml``.

   * The file ``files/pk_admins.txt`` has been sanitized. Adjust the
     public keys to your needs::

       shell> cat files/pk_admins.txt
       ssh-rsa <sanitized> admin@controller

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to ``iocage_04``:

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -l iocage_04 \
                            -e debug=true \
			     vbotka.freebsd.pb_iocage_template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash
