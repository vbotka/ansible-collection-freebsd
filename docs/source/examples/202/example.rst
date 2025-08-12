.. _example_202:

202 Create iocage templates. Clone DHCP jails.
----------------------------------------------

Extending example :ref:`example_200`.

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

.. index:: single: playbook pb_iocage_template.yml; Example 202
.. index:: single: playbook pb_iocage_ansible_clients.yml; Example 202

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

Use case
^^^^^^^^

Create iocage templates for Ansible clients. Get the IP addresses by DHCP. Create the
``dhclient-exit-hooks``. For example, the below hook

.. code-block:: console

   shell> cat /zroot/iocage/templates/ansible_client/root/etc/dhclient-exit-hooks 

.. code-block:: bash

   case "$reason" in
       "BOUND"|"REBIND"|"REBOOT"|"RENEW")
       echo $new_ip_address > /var/db/dhclient-hook.address.$interface
       ;;
   esac

creates files. For example,

.. code-block:: console

   shell> cat /zroot/iocage/jails/test_131/root/var/db/dhclient-hook.address.epair0b
   10.1.0.130
  
Read the files, created by the hooks, and use the IP addresses to compose the variable
``ansible_host``

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

In the below declaration, the variable ``ansible_host`` defaults to ``iocage_ip4`` if the hook is
not available

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
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── hosts
  │   ├── 02_iocage.yml
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* At two iocage hosts:

  * iocage_02
  * iocage_04

  In the playbook `vbotka.freebsd.pb_iocage_template.yml`_, use the modules:

  * ``vbotka.freebsd.iocage`` to create, start, stop, and convert jails to templates.
  * ``vbotka.freebsd.iocage`` exec to create a user and set .ssh ownership.
  * ``community.general.sysrc`` to configure /etc/rc.conf
  * ``ansible.posix.authorized_key`` to configure public keys.
  * ``ansible.builtin.lineinfile`` to configure /usr/local/etc/sudoers
  * configure ``dhclient hooks``

  In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_, use the `module vbotka.freebsd.iocage`_ to:

  * create jails from the Ansible client templates
  * start all jails
  * optionally, display the lists of jails.
  
* At all created jails:

  In the playbook ``pb-test.yml``:

  * connect created jails
  * display basic jails' configuration.

Requirements
^^^^^^^^^^^^

* playbook `vbotka.freebsd.pb_iocage_template.yml`_
* playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_
* `module vbotka.freebsd.iocage`_
* `inventory plugin vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* activated ``iocage``
* fetched releases.

Notes
^^^^^

* The option ``hooks_results`` expects the ``poolname`` of a jail to be mounted to
  ``/poolname``. For example, if you activate the pool ``zroot`` this plugin expects to find the
  ``hooks_results`` items in the path ``/zroot/iocage/jails/<name>/root``. If you mount the
  ``poolname`` to a different path the easiest remedy is to create a symlink.

.. seealso::

   * `man dhclient-script <https://man.freebsd.org/cgi/man.cgi?dhclient-script>`_
   * `Using Templates <https://iocage.readthedocs.io/en/latest/templates.html>`_

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
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 24-29

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 24-29

.. hint::

   The minimal required hook is ::

     act_dhclient:
       dhclient-exit-hooks: |
         case "$reason" in
             "BOUND"|"REBIND"|"REBOOT"|"RENEW")
             echo $new_ip_address > /var/db/dhclient-hook.address.$interface
             ;;
         esac

.. note::

   The variables ``act_*`` are used to configure ``ansible_client`` template

   * The dhclient hooks ``act_dhclient`` will be created in ``/etc``.
   * The user ``act_user`` will be created in the template.
   * The user ``act_user`` will serve as Ansible ``remote_user``.
   * The file ``act_pk`` provides the public keys allowed to ssh to ``act_user`` in the jail.

.. warning::

   * The user ``act_user`` must exist on the ``iocage`` host. Otherwise, the module
     ``ansible.posix.authorized_key`` will crash. See ``playbooks/pb_iocage_template/pk.yml``

   * The file ``files/pk_admins.txt`` was sanitized. Fit the public keys to your needs ::

       shell> cat files/pk_admins.txt 
       ssh-rsa <sanitized> admin@controller

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
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

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini
                            -t clone -e clone=true

.. literalinclude:: out/out-04.txt
   :language: yaml
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
   :language: yaml
   :caption:

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
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
   :language: yaml

Playbook output - Display list iocage_hooks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

.. hint::

   The below command stops and destroys the cloned jails ::

     ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml -i iocage.ini \
                      -t clone_destroy -e clone_destroy=true

.. _vbotka.freebsd.pb_iocage_template.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_template.yml
.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml
.. _module vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/iocage/
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
