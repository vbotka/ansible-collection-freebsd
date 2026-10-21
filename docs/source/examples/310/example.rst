.. _example_310:

310 Role vbotka.freebsd.postinstall
-----------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: postinstall; Example 310
   single: vbotka.freebsd.postinstall; Example 310
   single: role vbotka.freebsd.postinstall; Example 310
   single: audit ansible client; Example 310
   single: display_skipped_hosts; Example 310
   single: act_pkg; Example 310
   single: module community.general.pkgng; Example 310
   single: community.general.pkgng; Example 310
   single: delegate_to; Example 310

Use case
^^^^^^^^

Use the role `vbotka.freebsd.postinstall`_ to audit the basic configuration of
Ansible clients. The role is idempotent. A successful result means no changes
are reported. Use the template ``ansible-client`` created in :ref:`example_202`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── extra-vars.yml
  ├── files
  │   └── pk_admins.txt
  ├── group_vars
  │   └── all
  │       ├── iocage.yml
  │       └── swarms.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test-01.yml
  ├── pb-test-02.yml
  └── pb-test-03.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`:

    * Create ``swarm`` from the template ``ansible-client``.
    * Start the jails.

  * In the :ref:`inventory plugin vbotka.freebsd.iocage2 <ug_inventory_iocage2>`:

    * Create variables for :ref:`connection plugin vbotka.freebsd.jailexec
      <ug_connection_jailexec>`.

    * Create groups.

  * In the playbook ``pb-test-01.yml``, test the role
    `vbotka.freebsd.postinstall`_ does nothing by default.

  * In the playbook ``pb-test-02.yml``, install packages using the module
    `community.general.pkgng`_.

  * In the playbook ``pb-test-03.yml``, install packages by importing
    `vbotka.freebsd.postinstall`_.

  * In the playbook ``pb-test-01.yml``, use the role
    `vbotka.freebsd.postinstall`_ to:

    * Install packages.
    * Create user.
    * Configure public keys.
    * Configure sudo.
    * Configure dhclient.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.postinstall`_
* Playbook :ref:`ug_pb-iocage-ansible-clients`
* :ref:`ug_module_iocage`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Template ``ansible-client`` created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* Jail names created by ``iocage`` do not work in the `jail
  parameter`_ of the module `community.general.pkgng`_. Use the JID
  instead::

    jail: "{{ iocage_jid }}"

* The below plays run inside the jails. The inventory ``iocage.ini`` is needed
  when a task is delegated to an iocage host.

* The public key in ``files/pk_admins.txt`` has been sanitized.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.

.. seealso::

   * `Ansible role FreeBSD postinstall`_
   * :ref:`ug_qa_jexec_iocage_name`

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

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml+jinja
   :caption:

.. seealso::

   * Role `postinstall default variables`_.

.. literalinclude:: group_vars/all/swarms.yml
   :language: yaml+jinja
   :caption:

Playbook output - Create and start jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts -i iocage.ini --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml+jinja

Playbook output - By default do nothing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test-01.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

Use the module `community.general.pkgng`_ to demonstrate installation in a jail.

.. literalinclude:: pb-test-02.yml
   :language: yaml+jinja

Playbook output - Install packages by community.general.pkgng
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the task ``Install packages``
tasks.

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-test-02.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-03.yml
^^^^^^^^^^^^^^^^^^^^^^^

Use the imported tasks ``packages.yml`` from the role `vbotka.freebsd.postinstall`_.

.. literalinclude:: pb-test-03.yml
   :language: yaml+jinja

Playbook output - Install packages by importing tasks packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-test-03.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

.. hint::

   * Try ``pb-test-01.yml``, set the tag ``-t fp_packages``, and enable
     the import with ``-e fp_install=true``::

       (env) > ansible-playbook -i hosts -i iocage.ini \
                                -t fp_packages -e fp_install=true \
                                pb-test-03.yml

   * If the role ``vbotka.freebsd_postinstall`` is installed, try using it::

       - name: Install packages
         ansible.builtin.import_role:
           name: vbotka.freebsd_postinstall
           tasks_from: packages

   Both options should yield the same result.

Troubleshooting
^^^^^^^^^^^^^^^

Test the configuration step by step. Run the below plays with the options
``--check --diff`` first.

* Install packages::

    (env) > ansible-playbook -i hosts -i iocage.ini \
                             -t fp_packages -e fp_install=true \
                             pb-test-01.yml

* Create user::

    (env) > ansible-playbook -i hosts \
                             -t fp_users -e fp_users=true \
                             pb-test-01.yml

* Configure public keys::

    (env) > ansible-playbook -i hosts \
                             -t fp_authorized_key -e fp_authorized_key=true \
                             pb-test-01.yml

* Configure sudo::

    (env) > ansible-playbook -i hosts \
                             -t fp_sudoers -e fp_sudoers=true \
                             pb-test-01.yml

* Configure dhclient hooks::

    (env) > ansible-playbook -i hosts \
                             -t fp_dhclient_hooks -e fp_dhclient=true \
                             pb-test-01.yml

Put the extra variables into the file ``extra-vars.yml``:

.. literalinclude:: extra-vars.yml
   :language: yaml+jinja

Run the play:

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini \
                            -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \
                            -e @extra-vars.yml \
                            pb-test-01.yml

.. literalinclude:: out/out-08.txt
   :language: yaml+jinja
   :force:

Optionally, disable the `display_ok_hosts`_ option:

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
          ansible-playbook -i hosts -i iocage.ini \
                           -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \
                           -e @extra-vars.yml \
                           pb-test-01.yml

.. literalinclude:: out/out-09.txt
   :language: yaml+jinja
   :force:

.. hint::

   The above plays show that, depending on the use case, you can:

   * Use tags to select task groups from a role.

   * Import selected task groups from a role.

   * Create tasks using standalone modules.

   The first option provides the flexibility to quickly select functionality
   from the command line. In contrast, importing tasks improves execution speed
   at the expense of command-line flexibility.
