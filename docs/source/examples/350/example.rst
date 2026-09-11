.. _example_350:

350 Role vbotka.freebsd.rsnapshot
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: swarms; Example 350

.. index:: single: rsnapshot; Example 350
.. index:: single: role vbotka.freebsd.rsnapshot; Example 350
.. index:: single: vbotka.freebsd.rsnapshot; Example 350

.. index:: single: module community.general.pkgng; Example 350
.. index:: single: community.general.pkgng; Example 350
.. index:: single: delegate_to; Example 350

Use case
^^^^^^^^

Use the role `vbotka.freebsd.rsnapshot`_ to install and configure
`rsnapshot`_.

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
  │   ├── 04_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-install.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

In the playbooks:

* `vbotka.freebsd.pb_iocage_ansible_clients.yml`_: Create and start jails.
* ``pb-install.yml``: Install `rsnapshot`_ in running jails.
* ``pb-test.yml``: Configure `rsnapshot`_ in running jails.

Requirements
^^^^^^^^^^^^

* Templates created in :ref:`example_202`

Notes
^^^^^

* Jail names do not work in the `name`_ parameter of the module
  `community.general.pkgng`_ if the jail was created by
  ``iocage``. Use the JID instead::

    jail: "{{ iocage_jid }}"

* The plays run inside the jails. The inventory ``iocage.ini`` is
  needed when a task is delegated to an iocage host::

    delegate_to: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_::

    freebsd_pkgng_use_globs: false

  to specify packages in `pkg-origin`_ format::

    rsnapshot_packages:
      - sysutils/rsnapshot

ansible.cfg
^^^^^^^^^^^

Do not display skipped hosts. See the `display_skipped_hosts`_ option.

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/rsnapshot.yml
   :language: yaml+jinja
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts -i iocage.ini --graph

.. literalinclude:: out/out-03.txt
   :language: bash
   :force:

Playbook pb-install.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-install.yml
   :language: yaml+jinja

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed when a task is delegated to an
iocage host:

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-install.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts \
                            -t rsnapshot_debug -e rsnapshot_debug=true \
                            pb-test.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Configure rsnapshot
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Results
^^^^^^^

* TBD
