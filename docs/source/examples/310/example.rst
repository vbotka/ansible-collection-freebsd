.. _example_310:

310 Role vbotka.freebsd.postinstall
-----------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: postinstall; Example 310
.. index:: single: vbotka.freebsd.postinstall; Example 310
.. index:: single: role vbotka.freebsd.postinstall; Example 310
.. index:: single: audit ansible_client; Example 310
.. index:: single: display_skipped_hosts; Example 310

.. index:: single: act_pkg; Example 310

.. index:: single: module community.general.pkgng; Example 310
.. index:: single: community.general.pkgng; Example 310
.. index:: single: delegate_to; Example 310

Use case
^^^^^^^^

Use the role `vbotka.freebsd.postinstall`_ to audit the basic configuration of Ansible clients. The
role is idempotent. A successful result means no changes are reported. This example implements the
same configuration as :ref:`example_200`.

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
  │       └── ansible-client.yml
  ├── hosts
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test-01.yml
  ├── pb-test-02.yml
  └── pb-test-03.yml

Synopsis
^^^^^^^^

In all running jails:

* Playbook ``pb-test-01.yml``: Test that the role does nothing by default.
* Playbook ``pb-test-02.yml``: Install packages using the module `community.general.pkgng`_.
* Playbook ``pb-test-03.yml``: Install packages by importing `vbotka.freebsd.postinstall`_.
* Playbook ``pb-test-01.yml``:

  * Install packages
  * Create user
  * Configure public keys
  * Configure sudo
  * Configure dhclient

Requirements
^^^^^^^^^^^^

* Running jails on the iocage host

Notes
^^^^^

* Jail names do not work in the `name`_ parameter of the module `community.general.pkgng`_ if the
  jail was created by ``iocage``. Use the JID instead.

* The plays below run inside the jails. The inventory ``iocage.ini`` is needed when a task is
  delegated to an iocage host.

* The public key in ``files/pk_admins.txt`` has been sanitized.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.
   | Please ensure the versions are identical before switching between them.

.. seealso::

   * `Ansible role FreeBSD postinstall`_

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

Do not display skipped hosts. See the `display_skipped_hosts`_ option.

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml
   :caption:

.. seealso::

   The `default variables`_ of the role `vbotka.freebsd.postinstall`_

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts -i iocage.ini --graph

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - By default do nothing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

Use the module `community.general.pkgng`_ to demonstrate installation in a jail.

.. literalinclude:: pb-test-02.yml
   :language: yaml

Playbook output - Install packages by community.general.pkgng
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the ``Install packages`` tasks.

.. code-block:: console

   (env) > ansible-playbook pb-test-02.yml -i hosts -i iocage.ini

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Playbook pb-test-03.yml
^^^^^^^^^^^^^^^^^^^^^^^

Use the imported tasks ``packages.yml`` from the role `vbotka.freebsd.postinstall`_.

.. literalinclude:: pb-test-03.yml
   :language: yaml

Playbook output - Import vbotka.freebsd_postinstall packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test-03.yml -i hosts -i iocage.ini

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

.. hint::

   Try ``pb-test-01.yml``, set the tag ``-t fp_packages``, and enable the import with ``-e fp_install=true``::

     (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -t fp_packages -e fp_install=true

   If the role ``vbotka.freebsd_postinstall`` is installed, try using it::

     - name: Install packages
       ansible.builtin.import_role:
         name: vbotka.freebsd_postinstall
         tasks_from: packages

   Both options should yield the same result.

Install packages, create user, configure public keys, sudo, and dhclient hooks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Test the configuration step by step. Run the plays below with the options ``--check --diff`` first.

* Install packages::

    (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -t fp_packages -e fp_install=true

* Create user::

    (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_users -e fp_users=true

* Configure public keys::

    (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_authorized_key -e fp_authorized_key=true

* Configure sudo::

    (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_sudoers -e fp_sudoers=true

* Configure dhclient hooks::

    (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_dhclient_hooks -e fp_dhclient=true

Put the extra variables into the file ``extra-vars.yml``:

.. literalinclude:: extra-vars.yml
   :language: yaml

Run the play:

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml \
            -i hosts -i iocage.ini \
            -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \
            -e @extra-vars.yml

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Optionally, disable the `display_ok_hosts`_ option:

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
            ansible-playbook pb-test-01.yml \
            -i hosts -i iocage.ini \
            -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \
            -e @extra-vars.yml

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:

The plays above show that, depending on your use case, it is possible to:

* Use tags to select task groups from the role.
* Import selected task groups from the role.
* Create tasks using standalone modules.

The first option is flexible for quickly selecting functionality from the command line. On the
other hand, importing tasks provides faster execution at the cost of command-line flexibility.


.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall/
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd

.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _default variables: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/guide-variables.html
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts