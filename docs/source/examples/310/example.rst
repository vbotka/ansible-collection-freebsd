.. _example_310:

310 Role vbotka.freebsd.postinstall
-----------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.postinstall; Example 310
.. index:: single: audit ansible_client; Example 310
.. index:: single: display_skipped_hosts; Example 310

Use case
^^^^^^^^

Audit basic configuration of Ansible clients using the role
`vbotka.freebsd.postinstall`_. The role is idempotent. Successful result means
no changes are reported. Implement the same configuration as the example
:ref:`example_202`.

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
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage-hosts.ini
  ├── pb-test-01.yml
  ├── pb-test-02.yml
  └── pb-test-03.yml

Synopsis
^^^^^^^^

On all running jails:

* playbook *pb-test-01.yml*: test the role does nothing by default
* playbook *pb-test-02.yml*: install packages using the module *community.general.pkgng*
* playbook *pb-test-03.yml*: Install packages importing *vbotka.freebsd.postinstall*.
* playbook *pb-test-01.yml*:

  * install packages
  * create user
  * configure public keys
  * configure sudo
  * configure dhclient.

Requirements
^^^^^^^^^^^^

* running jails at the iocage host.

Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module
  `community.general.pkgng`_ if the jail was created by *iocage*. Use JID
  instead.

* The below plays run at the jails. The inventory *iocage-hosts.ini* is needed
  when a task is delegated to an iocage host.

* The public key in *files/pk_admins.txt* is sanitized.

.. seealso::

   * role `vbotka.freebsd_postinstall`_
   * documentation `Ansible role FreeBSD postinstall`_

.. warning::

   * `vbotka.freebsd.postinstall`_ is the role **postinstall** in the collection `vbotka.freebsd`_
   * `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_

   Please make sure the versions are the same before you switch between them.

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

::

  [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
    :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: ini
    :caption:

.. literalinclude:: hosts/99_constructed.yml
    :language: ini
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

::

  (env) > ansible-inventory -i hosts -i iocage-hosts.ini --graph

.. literalinclude:: out/out-03.txt
    :language: bash

Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml

Playbook output - by default do nothing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-01.yml -i hosts

.. literalinclude:: out/out-04.txt
    :language: yaml


Playbook *pb-test-02.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

Use the module `community.general.pkgng`_ to demonstrate the installation in a jail.

.. literalinclude:: pb-test-02.yml
    :language: yaml


Playbook output - install packages by community.general.pkgng
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory *iocage-hosts.ini* is needed to delegate the tasks *Install packages*.

::

  (env) > ansible-playbook pb-test-02.yml -i hosts -i iocage-hosts.ini

.. literalinclude:: out/out-05.txt
    :language: yaml

Playbook *pb-test-03.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

Use the imported tasks *packages.yml* from the role `vbotka.freebsd.postinstall`_

.. literalinclude:: pb-test-03.yml
    :language: yaml

Playbook output - import vbotka.freebsd_postinstall packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-test-03.yml -i hosts -i iocage-hosts.ini

.. literalinclude:: out/out-06.txt
    :language: yaml

.. hint::

   Try *pb-test-01.yml*, set tags ``-t fp_packages``, and enable the import ``-e
   fp_install=true`` ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage-hosts.ini -t fp_packages -e fp_install=true

   Try the standalone role if the role *vbotka.freebsd_postinstall* is installed ::

     - name: Install packages
       ansible.builtin.import_role:
         name: vbotka.freebsd_postinstall
         tasks_from: packages.yml

   Both options should give the same results.


Install packages, create user, configure public keys, sudo, and dhclient hooks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Test the configuration step by step. Run the below plays with options ``--check
--diff`` first.

* Install packages ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage-hosts.ini -t fp_packages -e fp_install=true

* Create user ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_users -e fp_users=true

* Configure public keys ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_authorized_key -e fp_authorized_key=true

* Configure sudo ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_sudoers -e fp_sudoers=true

* Configure dhclient hooks::

   (env) > ansible-playbook pb-test-01.yml -i hosts -t fp_dhclient_hooks -e fp_dhclient=true

Put the extra variables into the file *extra-vars.yml*

.. literalinclude:: extra-vars.yml
    :language: yaml

Run the play

::

  (env) > ansible-playbook pb-test-01.yml \
          -i hosts -i iocage-hosts.ini \                                            
          -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \  
          -e @extra-vars.yml

.. literalinclude:: out/out-07.txt
    :language: bash

Optionally, disable the option `display_ok_hosts`_

::

  (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
          ansible-playbook pb-test-01.yml \
          -i hosts -i iocage-hosts.ini \                                            
          -t fp_packages,fp_users,fp_authorized_key,fp_sudoers,fp_dhclient_hooks \  
          -e @extra-vars.yml

.. literalinclude:: out/out-08.txt
    :language: bash


The above plays show that, depending on a use case, it's possible to:

* Use tags to select tasks groups from the role.
* Import selected tasks groups from the role.
* Create tasks using modules.

The first option is flexible in briefly selecting the functionality from the
command line. The import provides a faster execution at the cost of flexibility.


.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
.. _vbotka.freebsd_postinstall: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_postinstall/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/

.. _Ansible role FreeBSD postinstall: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _default variables: https://ansible-freebsd-postinstall.readthedocs.io/en/latest/guide-variables.html
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
