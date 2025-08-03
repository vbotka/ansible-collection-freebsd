.. _example_320:

320 Role vbotka.freebsd.packages
--------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.packages; Example 320
.. index:: single: vbotka.freebsd.packages; Example 320
.. index:: single: audit ansible_client; Example 320
.. index:: single: display_skipped_hosts; Example 320

Use case
^^^^^^^^

Install packages in Ansible clients using the role `vbotka.freebsd.packages`_. Audit installed
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

At the iocage host:

* playbook ``pb-pkg-update.yml``:

  * upgrade the package ``ports-mgmt/pkg``
  * update FreeBSD repository catalogue (default `cached`_ = false).

At all running jails:
    
* playbook ``pb-test-01.yml``:

  * display variables
  * install packages
  * audit installed packages.

At the iocage host:

* playbook ``pb-test-02.yml``:

  * audit installed packages.

Requirements
^^^^^^^^^^^^

* Running jails at the iocage host.

Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module `community.general.pkgng`_ if the
  jail was created by *iocage*. Use JID instead ::

    pkg_jail: "{{ iocage_jid }}"

  The play ``pb-test-01.yml`` runs in the jails. The inventory ``iocage.ini`` is needed when a task
  is delegated to an iocage host ::

    pkg_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_ ::

    pkg_use_globs: false

  to use the packages in the form `pkg-origin`_ ::

    pkg_list:
      - security/sudo
      - lang/python311
      - ports-mgmt/pkg

* The playbook ``pb-pkg-update.yml`` updates the repositories. Then, use the `cached`_ local package
  base instead of fetching an updated one ::

    pkg_cached: true

.. note::

   | `vbotka.freebsd.packages`_ is the role **packages** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * module `community.general.pkgng`_

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-pkg-update.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkg-update.yml
   :language: yaml

Playbook output - upgrade package ports-mgmt/pkg
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to one host ``iocage_02``

.. code-block:: console

   (env) > ansible-playbook pb-pkg-update.yml -i iocage.ini -l iocage_02 -e debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
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

Playbook output - display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to one jail ``test_111``

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -l test_111 \
                                           -t pkg_debug \
                                           -e pkg_debug=true

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:

Playbook output - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the tasks ``Install list pkg_list``

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:

.. hint::

   Optionally, do not display ``OK`` hosts. See `display_ok_hosts`_

Playbook output - install packages and enable debug
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable debug and limit the inventory to one jail ``test_111``

.. code-block:: console

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage.ini -l test_111 \
                                           -e pkg_debug=true

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Playbook output - audit installed packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are no installed packages with known vulnerabilities

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

Playbook output - audit installed packages at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are 9 packages with known vulnerabilities

.. code-block:: console

   (env) > ansible-playbook pb-test-02.yml -i iocage.ini -l iocage_02 \
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
