.. _example_209:

209 Create iocage pkglist file
------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkglist; Example 209
.. index:: single: pkgs.json; Example 209
.. index:: single: role vbotka.freebsd.iocage; Example 209

Use case
^^^^^^^^

Use `role vbotka.freebsd.iocage`_ to create `iocage`_ list of packages for `Automatic Package
Installation`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   └── pkgs.json
  ├── group_vars
  │   └── all
  │       ├── pkgdict_amd64.yml
  │       ├── pkgdict_versions.yml
  │       └── pkglist.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

At the control node use:

* `role vbotka.freebsd.iocage`_:

  * to create `iocage`_ list of packages for `Automatic Package Installation`_.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_

Notes
^^^^^

* Use the same ``pkgdict_*.yml`` variables in:

  * `role vbotka.freebsd.poudriere`_ to build packages
  * `role vbotka.freebsd.packages`_ to install packages
  * `role vbotka.freebsd.iocage`_ to install packages in jails.

* The inventory ``iocage.ini`` is not needed in this example. It would be sufficient to run the play
  at the ``localhost``. It is used here because normally the files ``pkgs.json``, after being
  created, are used in the ``iocage`` hosts.

* The playbook in this example covers the simplest case of creating the common file ``pkgs.json``
  for all managed nodes in the group ``iocage``.

* See the tasks ``playbooks/pb_iocage_template/pkglist.yml`` how the ``template`` attribute
  ``pkglist`` is used.

.. seealso::

   * `man 8 iocage`_
   * ``pkgdict_*.yaml`` variables in the `role vbotka.freebsd.postinstall defaults`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/pkglist.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/pkgdict_amd64.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/pkgdict_versions.yml
   :language: yaml
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - Create pkgs.json
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Result
^^^^^^

.. literalinclude:: files/pkgs.json
   :language: json
   :caption:


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _role vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/
.. _role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/

.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage
.. _iocage: https://iocage.readthedocs.io/en/latest/index.html
.. _Automatic Package Installation: https://iocage.readthedocs.io/en/latest/advanced-use.html?highlight=pkglist#automatic-package-installation

.. _role vbotka.freebsd.postinstall defaults: https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main
