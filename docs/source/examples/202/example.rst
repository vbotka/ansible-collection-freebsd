.. _example_202:

202 Clone jails from iocage templates (DHCP)
--------------------------------------------

This example extends :ref:`example_200`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: clones; Example 202
   single: ansible-client; Example 202
   single: template ansible_client; Example 202
   single: sudoers; Example 202
   single: pb_iocage_template.yml; Example 202
   single: pb_iocage_ansible_clients.yml; Example 202
   single: inventory vbotka.freebsd.iocage; Example 202
   single: module vbotka.freebsd.iocage; Example 202
   single: module ansible.posix.authorized; Example 202
   single: ansible.posix.authorized; Example 202
   single: module ansible.builtin.lineinfile; Example 202
   single: ansible.builtin.lineinfile; Example 202
   single: module community.general.sysrc; Example 202
   single: community.general.sysrc; Example 202
   single: option compose; Example 202
   single: compose; Example 202
   single: option groups; Example 202
   single: act_user; Example 202
   single: act_pk; Example 202
   single: act_sudo; Example 202
   single: act_rcconf; Example 202
   single: pkglist; Example 202
   single: pkgs.json; Example 202
   single: defaultrouter; Example 202

Use case
^^^^^^^^

Create the `iocage`_ template ``ansible-client``. Configure
``dhclient-exit-hooks``. Clone jails from the template. Obtain IP addresses via
DHCP. In the inventory plugin, configure ``hooks_results`` and create the
variable ``ansible_host``.

For example, the hook below:

.. code-block:: console

   shell> cat /zroot/iocage/templates/ansible-client/root/etc/dhclient-exit-hooks

.. code-block:: bash

   case "$reason" in
       "BOUND"|"REBIND"|"REBOOT"|"RENEW")
       echo $new_ip_address > /var/db/dhclient-hook.address.$interface
       ;;
   esac

creates IP address files:

.. code-block:: console

   shell> cat /zroot/iocage/jails/test-131/root/var/db/dhclient-hook.address.epair0b
   10.1.0.130

In the configuration of the iocage plugin, set the option ``hooks_results`` to
read the file(s) created by the hook(s) and use the IP address(es) to compose
the variable ``ansible_host``:

.. code-block:: console

   shell> cat hosts/01_iocage.yml

.. code-block:: yaml+jinja
   :force:
   :emphasize-lines: 3-4

   plugin: vbotka.freebsd.iocage
   ...
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: iocage_hooks.0

In the declaration below, the variable ``ansible_host`` defaults to
``iocage_ip4`` if the hook is not available:

.. code-block:: yaml+jinja

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
  │   ├── 05_iocage.yml
  │   ├── 06_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

In addition to the configuration in :ref:`example_200`:

* Configure ``dhclient-exit-hooks`` in the template ``ansible-client``.

* Configure ``hooks_results`` in the inventory plugin and create the variable
  ``ansible_host``.

* Clone jails from this template and start them.

* Display selected variables.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-template`
* Playbook :ref:`ug_pb-iocage-ansible-clients`
* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage2`
* An activated ``iocage`` installation.
* Fetched releases.
* Root privileges on the managed nodes.

Notes
^^^^^

* The option ``hooks_results`` expects the ``poolname`` of a jail to be mounted
  to ``/poolname``. For example, if you activate the pool ``zroot``, this plugin
  expects to find the ``hooks_results`` items in the path
  ``/zroot/iocage/jails/<name>/root``. If you mount the ``poolname`` to a
  different path, the easiest remedy is to create a symlink.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-6,9

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-6,9

.. hint::

   If there is a route from your Ansible controller to the jails, try to connect
   with the connection plugin `ansible.builtin.ssh`_ (default).

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

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

   * The dhclient hooks ``act_dhclient`` will be created in ``/etc``.

files
^^^^^

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:

Playbook output - Create templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Templates
^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -lt

Playbook output - Clone and start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t clone \
                            -e clone=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook output - List jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t list \
                            -e debug=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-06.txt
   :language: console

Jails
^^^^^

.. literalinclude:: out/out-07.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-08.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the cloned jails::

     ansible-playbook -i iocage.ini \
                      -t clone_destroy \
                      -e clone_destroy=true \
                      vbotka.freebsd.pb_iocage_ansible_clients.yml