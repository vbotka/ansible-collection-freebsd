.. _example_208:

208 Create iocage template for ansible-pull
-------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible-pull; Example 208

.. index:: single: ansible_client_pull; Example 208
.. index:: single: template ansible_client_pull; Example 208
.. index:: single: DHCP; Example 208
.. index:: single: dhclient; Example 208
.. index:: single: dhclient-exit-hooks; Example 208

.. index:: single: module vbotka.freebsd.iocage; Example 208
.. index:: single: module community.general.pkgng; Example 208
.. index:: single: community.general.pkgng; Example 208

.. index:: single: act_dhclient; Example 208
.. index:: single: act_pkg; Example 208
.. index:: single: act_user; Example 208
.. index:: single: act_pk; Example 208
.. index:: single: act_sudo; Example 208
.. index:: single: act_rcconf; Example 208

Use case
^^^^^^^^

Create ``iocage`` template that will use ``ansible-pull``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pk_admins.txt
  ├── host_vars
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test-01.yml

Synopsis
^^^^^^^^

* At the iocage host ``iocage_04`` in the playbook `vbotka.freebsd.pb_iocage_template`_, use the
  modules:

  * ``vbotka.freebsd.iocage`` to create, start, stop, and convert jail to templates.
  * ``vbotka.freebsd.iocage`` exec to create a user and set .ssh ownership.
  * ``community.general.pkgng`` to install packages.
  * ``ansible.posix.authorized_key`` to configure public keys.
  * ``ansible.builtin.lineinfile`` to configure ``/etc/rc.conf`` and ``/usr/local/etc/sudoers``
  * configure ``dhclient hooks``

Requirements
^^^^^^^^^^^^

* playbook `vbotka.freebsd.pb_iocage_template`_
* `module vbotka.freebsd.iocage`_
* root privilege on the iocage host

Notes
^^^^^

TBD

.. seealso::

   * `Using Templates <https://iocage.readthedocs.io/en/latest/templates.html>`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml
   :caption:

.. note::

   The variables ``act_*`` are used to configure ``ansible_client_pull`` template

   * The dhclient hooks ``act_dhclient`` will be created in ``/etc``
   * The user ``act_user`` will be created in the template.
   * The user ``act_user`` will serve as Ansible ``remote_user``
   * The file ``act_pk`` provides the public keys allowed to ssh to ``act_user``

.. warning::

   * The user ``act_user`` must exist on the ``iocage`` host. Otherwise, the module
     ``ansible.posix.authorized_key`` will crash. See ``pb_iocage_template/pk.yml``

   * The file ``files/pk_admins.txt`` was sanitized. Fit the public keys to your needs ::

       shell> cat files/pk_admins.txt 
       ssh-rsa <sanitized> admin@controller

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook output - create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to iocage_04

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_template.yml \
                            -i iocage.ini -l iocage_04

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

List templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

.. _vbotka.freebsd.pb_iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_template.yml/
.. _vbotka.freebsd.pb_iocage_ansible_clients: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
