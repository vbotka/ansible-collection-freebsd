.. _example_311:

311 Role vbotka.freebsd.packages
--------------------------------

.. contents:: Table of Contents
   :depth: 2

.. index:: single: role vbotka.freebsd.packages; Example 311
.. index:: single: audit ansible_client; Example 311
.. index:: single: display_skipped_hosts; Example 311


Use case
^^^^^^^^

Install packages in Ansible clients using the role
`vbotka.freebsd.packages`_. Audit installed packages.


Tree
^^^^

.. code:: bash

   shell> tree .
   .
   ├── ansible.cfg
   ├── group_vars
   │   └── all
   │       └── ansible-client.yml
   ├── hosts
   │   ├── 02_iocage.yml
   │   └── 99_constructed.yml
   ├── iocage-hosts.ini
   ├── pb-test-01.yml
   └── pb-test-02.yml


Synopsis
^^^^^^^^

* In the playbook pb-test-01.yml at the jails:

  * display variables
  * install packages
  * audit installed packages

* In the playbook pb-test-02.yml at an iocage host:

  * audit installed packages


Requirements
^^^^^^^^^^^^

* running jails at the iocage host.


Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module
  `community.general.pkgng`_ if the jail was created by *iocage*. Use JID
  instead.

* The play *pb-test-01.yml* runs at the jails. The inventory *iocage-hosts.ini*
  is needed when a task is delegated to an iocage host.

* The public key in *files/pk_admins.txt* is sanitized.

.. seealso::

   * role `vbotka.freebsd_packages`_

.. warning::

   * `vbotka.freebsd.packages`_ is the role **packages** in the collection `vbotka.freebsd`_
   * `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_

   Please make sure the versions are the same before you switch between them.


List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash


Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
    :language: ini


Inventory hosts/02_iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: ini


Inventory hosts/99_constructed.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/99_constructed.yml
    :language: ini


Variables group_vars/all/ansible-client.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
    :language: yaml


Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash


Playbook *pb-test-01.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
    :language: yaml


Playbook output. Display variables.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Limit the inventory to one jail *test_111* ::

    (env) > ansible-playbook pb-test-01.yml -i hosts -l test_111 \
                                            -t pkg_debug \
					    -e pkg_debug=true

.. literalinclude:: out/out-04.txt
    :language: yaml


Playbook output. Install packages.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory *iocage-hosts.ini* is needed to delegate the tasks *Install list pkg_list* ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage-hosts.ini

.. literalinclude:: out/out-05.txt
    :language: yaml

.. hint::

   Optionally, do not display OK hosts. See `display_ok_hosts`_


Playbook output. Install packages. Enable debug.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable debug and limit the inventory to one jail *test_111* ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage-hosts.ini -l test_111 \
                                           -e pkg_debug=true

.. literalinclude:: out/out-06.txt
    :language: yaml


Playbook output. Install packages. Enable cache.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Select the tag *pkg_install* skipping sanity tasks. Do not update FreeBSD
repository catalogue by setting *pkg_cached=true* ::

   (env) > ansible-playbook pb-test-01.yml -i hosts -i iocage-hosts.ini -l test_111 \
                                           -t pkg_install \
                                           -e pkg_debug=true -e pkg_cached=true

.. literalinclude:: out/out-07.txt
    :language: yaml


Playbook output. Audit installed packages.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are no installed packages with known vulnerabilities ::

   (env) > ansible-playbook pb-test-01.yml -i hosts \
                                           -t pkg_stat \
					   -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true

.. literalinclude:: out/out-08.txt
    :language: yaml


Playbook *pb-test-02.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
    :language: yaml


Playbook output. Audit installed packages at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are 9 packages with known vulnerabilities ::

   (env) > ansible-playbook pb-test-02.yml -i iocage-hosts.ini -l iocage_02 \
                                           -t pkg_stat \
					   -e pkg_stat=true -e pkg_audit_enable=true -e pkg_debug=true

.. literalinclude:: out/out-09.txt
    :language: yaml


.. _vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages
.. _vbotka.freebsd_packages: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_packages/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/

.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
