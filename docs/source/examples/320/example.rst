.. _example_320:

320 Install and audit packages
------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: role vbotka.freebsd.packages; Example 320
   single: vbotka.freebsd.packages; Example 320
   single: audit ansible client; Example 320
   single: display_skipped_hosts; Example 320

Use case
^^^^^^^^

Use the role `vbotka.freebsd.packages`_ to install packages in Ansible
clients. Audit installed packages.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── ansible-client.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-pkg-update.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-pkg-update.yml``:

    * Update FreeBSD repository catalogue (default `cached`_ = false).
    * Upgrade the package ``ports-mgmt/pkg``.

* In all running jails in the group ``state_up``:

  * In the playbook ``pb-test.yml``, test the role `vbotka.freebsd.packages`_:

    * Display variables.
    * Install packages.
    * Audit installed packages.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.packages`_
* Some running jails.

Notes
^^^^^

* Jail names created by ``iocage`` do not work in the `jail
  parameter`_ of the module `community.general.pkgng`_. Use the JID
  instead::

    pkg_jail: "{{ iocage_jid }}"

  The play ``pb-test.yml`` runs inside the jails. The inventory
  ``iocage.ini`` is needed when a task is delegated to an iocage
  host::

    pkg_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_::

    pkg_use_globs: false

  to specify packages in `pkg-origin`_ format::

    pkg_list:
      - security/sudo
      - lang/python312
      - ports-mgmt/pkg

* The playbook ``pb-pkg-update.yml`` updates the
  repositories. Afterwards, use the `cached`_ local package database
  instead of fetching an updated one::

    pkg_cached: true

.. note::

   | `vbotka.freebsd.packages`_ is the role **packages** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_.

.. seealso::

   * Module `community.general.pkgng`_
   * :ref:`ug_qa_jexec_iocage_name`

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts -i iocage.ini --graph

Jails
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

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

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml+jinja
   :caption:

Playbook pb-pkg-update.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkg-update.yml
   :language: yaml+jinja

Playbook output - Update repos and upgrade pkg
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -e debug=true pb-pkg-update.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to a single jail:

.. code-block:: console

   (env) > ansible-playbook -i hosts -l log_server_01 \
                            -t pkg_debug -e pkg_debug=true \
                            pb-test.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the ``Install list
pkg_list`` task.

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

.. hint::

   Optionally, do not display ``OK`` hosts. See `display_ok_hosts`_.

Playbook output - Audit packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -l log_server_01 \
                            -t pkg_stat \
                            -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true \
                            pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:
