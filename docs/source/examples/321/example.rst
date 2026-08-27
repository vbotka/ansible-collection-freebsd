.. _example_321:

321 Create package repository configuration
-------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkg repositories; Example 321
.. index:: single: signature_type; Example 321
.. index:: single: pubkey; Example 321
.. index:: single: mirror_type; Example 321
.. index:: single: role vbotka.freebsd.packages; Example 321
.. index:: single: vbotka.freebsd.packages; Example 321

Use case
^^^^^^^^

Use the role `vbotka.freebsd.packages`_ to create a package' repository configuration.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── build.example.com-sk.crt
  ├── host_vars
  │   └── iocage_04
  │       └── repos.yml
  ├── iocage.ini
  └── pb-repos.yml

Synopsis
^^^^^^^^

At the managed node ``iocage_04`` in the playbook ``pb-repos.yml`` create the package' repository
configuration.

Requirements
^^^^^^^^^^^^

TBD

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.packages`_ is the role **packages** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_packages`_ is the role **freebsd_packages** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `Poudriere - Configure clients`_
   * `man pkg`_
   * `man pkg.conf`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_04/repos.yml
   :language: yaml
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Create repo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
   :caption: shell> ansible-playbook pb.yml -i iocage.ini -t pkg_keys,pkg_conf
   :language: yaml
   :force:

Repository build.conf at iocage_04
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
   :caption:  /usr/local/etc/pkg/repos/build.conf
   :language: yaml

Configuration at iocage_04
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
   :caption:  [iocage_04]# pkg -vv
   :language: sh

Update repos at iocage_04
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
   :caption:  [iocage_04]# pkg update -f
   :language: console


.. _vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _vbotka.freebsd_packages: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_packages/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _Poudriere - Configure clients: https://ansible-freebsd-poudriere.readthedocs.io/en/latest/guide-build-clients.html
.. _man pkg: https://man.freebsd.org/cgi/man.cgi?pkg(8)
.. _man pkg.conf: https://man.freebsd.org/cgi/man.cgi?pkg.conf(5)
