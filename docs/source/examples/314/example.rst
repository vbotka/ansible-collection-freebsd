.. _example_314:

314 Role vbotka.freebsd.rsnapshot
---------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.rsnapshot; Example 314
.. index:: single: vbotka.freebsd.rsnapshot; Example 314
.. index:: single: rsnapshot; Example 314

Use case
^^^^^^^^

Install and configure `rsnapshot`_ in Ansible clients using the role `vbotka.freebsd.rsnapshot`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── common.yml
  │       └── rsnapshot.yml
  ├── hosts
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage-hosts.ini
  └── pb.yml

Synopsis
^^^^^^^^

* In the playbook *pb-install.yml* install `rsnapshot`_ on running jails.
* In the playbook *pb.yml* configure `rsnapshot`_ on running jails.

Requirements
^^^^^^^^^^^^

* Running jails at the iocage host.
* Updated FreeBSD repository catalogue. See the playbook *pb-pkg-update.yml* in
  :ref:`example_311`

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

* The playbook *pb-pkg-update.yml* in :ref:`example_311` updates the
  repositories. Then, use the `cached`_ local package base instead of fetching
  an updated one ::

    freebsd_pkgn_cached: true
    
.. seealso::

   * module `community.general.pkgng`_

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
    :language: ini

Configuration group_vars/all/
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
    :language: yaml
    :caption:

.. literalinclude:: group_vars/all/rsnapshot.yml
    :language: yaml
    :caption:

Inventory hosts/
^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :caption:
.. literalinclude:: hosts/99_constructed.yml
    :language: yaml
    :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Playbook pb-install.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-install.yml
    :language: yaml

Playbook output - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory *iocage-hosts.ini* is needed to delegate the tasks 'Manage FreeBSD
packages' to the iocage hosts.

.. code:: bash

   (env) > ansible-playbook pb-install.yml -i hosts -i iocage-hosts.ini

.. literalinclude:: out/out-07.txt
    :language: yaml

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
    :language: yaml

Playbook output - debug
^^^^^^^^^^^^^^^^^^^^^^^

Enable debug and limit the inventory to one jail *test_111*.

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -l test_111 -t rsnapshot_debug -e rsnapshot_debug=true

.. literalinclude:: out/out-06.txt
    :language: yaml

Results
^^^^^^^

     
.. _rsnapshot: https://rsnapshot.org/
.. _vbotka.freebsd.rsnapshot: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/rsanpshot/
.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _cached: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-cached
.. _use_globs: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
.. _pkg-origin: https://man.freebsd.org/cgi/man.cgi?query=pkg-install
