.. _example_202:

202 Create iocage templates. Clone DHCP jails.
----------------------------------------------

Extending :ref:`example_200`.

.. contents::
   :local:
   :depth: 1

.. index:: single: ansible_client; Example 202
.. index:: single: template ansible_client; Example 202
.. index:: single: DHCP; Example 202

.. index:: single: dhclient; Example 202
.. index:: single: dhclient-exit-hooks; Example 202
.. index:: single: property notes; Example 202
.. index:: single: notes; Example 202
.. index:: single: sudoers; Example 202

.. index:: single: inventory vbotka.freebsd.iocage; Example 202
.. index:: single: module vbotka.freebsd.iocage; Example 202
.. index:: single: module ansible.posix.authorized; Example 202
.. index:: single: ansible.posix.authorized; Example 202
.. index:: single: module ansible.builtin.lineinfile; Example 202
.. index:: single: ansible.builtin.lineinfile; Example 202
.. index:: single: module community.general.sysrc; Example 202
.. index:: single: community.general.sysrc; Example 202

.. index:: single: pb_iocage_template.yml; Example 202
.. index:: single: pb_iocage_ansible_clients.yml; Example 202

.. index:: single: option compose; Example 202
.. index:: single: compose; Example 202
.. index:: single: option hooks_results; Example 202
.. index:: single: hooks_results; Example 202

.. index:: single: variable iocage_hooks; Example 202
.. index:: single: iocage_hooks; Example 202
.. index:: single: act_user; Example 202
.. index:: single: act_pk; Example 202
.. index:: single: act_sudo; Example 202
.. index:: single: act_dhclient; Example 202
.. index:: single: act_rcconf; Example 202
.. index:: single: pkglist; Example 202
.. index:: single: pkgs.json; Example 202

Use case
^^^^^^^^

Create iocage templates for Ansible clients. Obtain IP addresses via
DHCP and create ``dhclient-exit-hooks``. For example, the hook below:

.. code-block:: console

   shell> cat /zroot/iocage/templates/ansible_client/root/etc/dhclient-exit-hooks

.. code-block:: bash

   case "$reason" in
       "BOUND"|"REBIND"|"REBOOT"|"RENEW")
       echo $new_ip_address > /var/db/dhclient-hook.address.$interface
       ;;
   esac

creates address files:

.. code-block:: console

   shell> cat /zroot/iocage/jails/test_131/root/var/db/dhclient-hook.address.epair0b
   10.1.0.130

Read the files created by the hooks and use the IP addresses to
compose the variable ``ansible_host``:

.. code-block:: console

   shell> cat hosts/01_iocage.yml

.. code-block:: yaml
   :force:

   plugin: vbotka.freebsd.iocage
   ...
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: iocage_hooks.0

In the declaration below, the variable ``ansible_host`` defaults to
``iocage_ip4`` if the hook is not available:

.. code-block:: yaml

   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── hosts
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_02
  * iocage_04

  In the playbook `vbotka.freebsd.pb_iocage_template.yml`_, use the
  modules:

  * ``vbotka.freebsd.iocage`` to create, start, stop, and convert jails to templates.
  * ``vbotka.freebsd.iocage`` exec to create a user and set ``.ssh`` ownership.
  * ``community.general.sysrc`` to configure ``/etc/rc.conf``.
  * ``ansible.posix.authorized_key`` to configure public keys.
  * ``ansible.builtin.lineinfile`` to configure ``/usr/local/etc/sudoers``.
  * Configure ``dhclient hooks``.

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_, use
  the :ref:`ug_module_iocage` to:

  * Create jails from the Ansible client templates
  * Start all jails
  * Optionally, display the lists of jails

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Connect to created jails
  * Display basic jail configuration

Requirements
^^^^^^^^^^^^

* Playbook `vbotka.freebsd.pb_iocage_template.yml`_
* Playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage`
* Root privileges on the managed nodes
* An activated ``iocage`` installation
* Fetched releases

Notes
^^^^^

* The option ``hooks_results`` expects the ``poolname`` of a jail to
  be mounted to ``/poolname``. For example, if you activate the pool
  ``zroot``, this plugin expects to find the ``hooks_results`` items
  in the path ``/zroot/iocage/jails/<name>/root``. If you mount the
  ``poolname`` to a different path, the easiest remedy is to create a
  symlink.

.. seealso::

   * `man dhclient-script <https://man.freebsd.org/cgi/man.cgi?dhclient-script>`_
   * `Using Templates <https://freebsd.github.io/iocage/templates.html>`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

files
^^^^^

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 24-29

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 24-29

.. hint::

   The minimal required hook is::

     act_dhclient:
       dhclient-exit-hooks: |
         case "$reason" in
             "BOUND"|"REBIND"|"REBOOT"|"RENEW")
             echo $new_ip_address > /var/db/dhclient-hook.address.$interface
             ;;
         esac

.. note::

   The variables ``act_*`` are used to configure the
   ``ansible_client`` template:

   * The dhclient hooks ``act_dhclient`` will be created in ``/etc``.
   * The user ``act_user`` will be created in the template.
   * The user ``act_user`` will serve as the Ansible ``remote_user``.
   * The file ``act_pk`` provides the public keys allowed to SSH to ``act_user`` in the jail.

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

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Templates at iocage_02
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: bash

Templates at iocage_04
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook output - Clone and start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone -e clone=true \
                             vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-05.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-07.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display list iocage_hooks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the cloned jails::

     ansible-playbook -i iocage.ini \
                      -t clone_destroy -e clone_destroy=true \
                       vbotka.freebsd.pb_iocage_ansible_clients.yml
