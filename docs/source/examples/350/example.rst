.. _example_350:

350 Role vbotka.freebsd.rsnapshot
---------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.rsnapshot; Example 350
.. index:: single: vbotka.freebsd.rsnapshot; Example 350
.. index:: single: rsnapshot; Example 350
.. index:: single: module community.general.pkgng; Example 350
.. index:: single: community.general.pkgng; Example 350
.. index:: single: delegate_to; Example 350

Use case
^^^^^^^^

Create 3 jails (Ansible clients) at iocage host. Install and configure
`rsnapshot`_ in Ansible clients using the role `vbotka.freebsd.rsnapshot`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── ansible-client.yml
  │       ├── common.yml
  │       └── rsnapshot.yml
  ├── hosts
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage-hosts.ini
  ├── pb-install.yml
  └── pb.yml

Synopsis
^^^^^^^^

* In the playbook `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ create and start jails.
* In the playbook `vbotka.freebsd.pb_iocage_update_repos.yml`_ update repositories.
* In the playbook *pb-install.yml* install `rsnapshot`_ on running jails.
* In the playbook *pb.yml* configure `rsnapshot`_ on running jails.

Requirements
^^^^^^^^^^^^

* Templates created in :ref:`example_205`

Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module
  `community.general.pkgng`_ if the jail was created by *iocage*. Use JID
  instead ::

    freebsd_pkgng_jail: "{{ iocage_jid }}"

* The plays run at the jails. The inventory *iocage-hosts.ini* is needed when a
  task is delegated to an iocage host ::

    freebsd_pkgng_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_ ::

    freebsd_pkgng_use_globs: false

  to use the packages in the form `pkg-origin`_ ::

    rsnapshot_packages:
      - sysutils/rsnapshot

* The playbook `vbotka.freebsd.pb_iocage_update_repos.yml`_ updates the
  repositories. Then, use the `cached`_ local package base instead of fetching
  an updated one ::

    freebsd_pkgng_cached: true
    
.. seealso::

   * module `community.general.pkgng`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/common.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/rsnapshot.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage-hosts.ini -l iocage_02 \
                            -t swarm -e swarm=true

.. literalinclude:: out/out-11.txt
   :language: yaml
   :force:

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts -i iocage-hosts.ini --graph

.. literalinclude:: out/out-02.txt
   :language: bash
   :force:

Update repos
^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_update_repos.yml \
                           -i iocage-hosts.ini -l iocage_02

.. literalinclude:: out/out-12.txt
   :language: yaml
   :force:

Playbook pb-install.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-install.yml
   :language: yaml

Playbook output - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory *iocage-hosts.ini* is needed to delegate the tasks 'Manage FreeBSD
packages' to the iocage hosts.

.. code:: console

   (env) > ansible-playbook pb-install.yml -i hosts -i iocage-hosts.ini

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: bash

Playbook output - debug
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i hosts -t rsnapshot_debug -e rsnapshot_debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - configure rsnapshot
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i hosts

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

Results
^^^^^^^

TBD
     
.. _rsnapshot: https://rsnapshot.org/
.. _vbotka.freebsd.rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsanpshot/

.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml/
.. _vbotka.freebsd.pb_iocage_update_repos.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_update_repos.yml/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _cached: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-cached
.. _use_globs: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
.. _pkg-origin: https://man.freebsd.org/cgi/man.cgi?query=pkg-install
