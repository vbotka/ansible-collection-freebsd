.. _example_320:

320 Install and audit packages
------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.packages; Example 320
.. index:: single: vbotka.freebsd.packages; Example 320
.. index:: single: audit ansible_client; Example 320
.. index:: single: display_skipped_hosts; Example 320

Use case
^^^^^^^^

Use the role `vbotka.freebsd.packages`_ to install packages in Ansible clients. Audit installed
packages.

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
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-pkg-update.yml
  ├── pb-test-01.yml
  └── pb-test-02.yml

Synopsis
^^^^^^^^

On the managed node ``iocage_02``:

* Playbook ``pb-pkg-update.yml``:

  * Upgrade the package ``ports-mgmt/pkg``
  * Update FreeBSD repository catalogue (default `cached`_ = false)

In all running jails:

* Playbook ``pb-test-01.yml``:

  * Display variables
  * Install packages
  * Audit installed packages

On the managed node ``iocage_02``:

* Playbook ``pb-test-02.yml``:

  * Audit installed packages

Requirements
^^^^^^^^^^^^

* Running jails on the iocage host

Notes
^^^^^

* Jail names do not work in the `name`_ parameter of the module `community.general.pkgng`_ if the
  jail was created by *iocage*. Use the JID instead::

    pkg_jail: "{{ iocage_jid }}"

  The play ``pb-test-01.yml`` runs inside the jails. The inventory ``iocage.ini`` is needed when a task
  is delegated to an iocage host::

    pkg_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_::

    pkg_use_globs: false

  to specify packages in `pkg-origin`_ format::

    pkg_list:
      - security/sudo
      - lang/python311
      - ports-mgmt/pkg

* The playbook ``pb-pkg-update.yml`` updates the repositories. Afterwards, use the `cached`_ local package
  database instead of fetching an updated one::

    pkg_cached: true

.. note::

   | `vbotka.freebsd.packages`_ is the role **packages** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_.
   | Please ensure the versions are identical before switching between them.

.. seealso::

   * Module `community.general.pkgng`_

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

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

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml
   :caption:

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

   (env) > ansible-inventory -i hosts -i iocage.ini --graph

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook pb-pkg-update.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkg-update.yml
   :language: yaml

Playbook output - Update repo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-pkg-update.yml -i iocage.ini -e debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to the jail ``test_111``:

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -l test_111 \
                                           -t pkg_debug \
                                           -e pkg_debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - Install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the ``Install list pkg_list`` task.

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

.. hint::

   Optionally, do not display ``OK`` hosts. See `display_ok_hosts`_.

Playbook output - Install packages with debug
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable debug and limit the inventory to the jail ``test_111``:

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -l test_111 \
                                           -e pkg_debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook output - Audit installed packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are no installed packages with known vulnerabilities:

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts \
                                           -t pkg_stat \
                                           -e pkg_stat=true -e pkg_audit_enable=true \
                                           -e pkg_debug=true

.. literalinclude:: out/out-07.txt
   :language: yaml
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
   :language: yaml

Playbook output - Audit installed packages at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are 9 packages with known vulnerabilities:

.. code-block:: console

   (env) > ansible-playbook pb-test-02.yml -i iocage.ini \
                                           -t pkg_stat \
                                           -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true

.. literalinclude:: out/out-08.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _vbotka.freebsd_packages: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_packages/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _cached: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-cached
.. _use_globs: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
.. _pkg-origin: https://man.freebsd.org/cgi/man.cgi?query=pkg-install