.. _example_209:

209 Create iocage pkglist file
------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkglist; Example 209
.. index:: single: pkgs.json; Example 209
.. index:: single: role vbotka.freebsd.iocage; Example 209

.. index:: single: ansible_client_apache; Example 209
.. index:: single: template ansible_client_apache; Example 209
.. index:: single: playbook pb_iocage_template.yml; Example 209

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to create `iocage`_ list of packages for `Automatic Package
Installation`_. Create Ansible template for Apache web server.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── group_vars
  │   └── all
  │       ├── pkgdict.yml
  │       ├── pkgdict_versions.yml
  │       └── pkglist.yml
  ├── host_vars
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-pkglist.yml

Synopsis
^^^^^^^^

At the control node use:

* `role vbotka.freebsd.iocage`_:

  * to create `iocage`_ list of packages ``files/pkgs.json`` for `Automatic Package Installation`_
    of the Apache web server.

* playbook `vbotka.freebsd.pb_iocage_template.yml`_:

  * to create Ansible template ``ansible_client_apache``.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* playbook `vbotka.freebsd.pb_iocage_template.yml`_

Notes
^^^^^

* Use the same ``pkgdict_*.yml`` variables in:

  * `role vbotka.freebsd.poudriere`_ to build packages
  * `role vbotka.freebsd.packages`_ to install packages
  * `role vbotka.freebsd.iocage`_ to install packages in jails.

* The inventory ``iocage.ini`` is not needed to create the file ``pkgs.json``. It would be
  sufficient to run the play at the ``localhost``. It is used here because normally the files
  ``pkgs.json``, after being created, are used in the ``iocage`` managed nodes.

* This example covers the simplest case of creating the common file ``pkgs.json`` for all managed
  nodes in the group ``iocage``.

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

.. literalinclude:: group_vars/all/pkgdict.yml
   :language: yaml
   :caption:

.. literalinclude:: group_vars/all/pkgdict_versions.yml
   :language: yaml
   :caption:

Playbook pb-pkglist.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkglist.yml
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

Playbook output - Create template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_template.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _role vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/
.. _role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _vbotka.freebsd.pb_iocage_template.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_template.yml

.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage
.. _iocage: https://iocage.readthedocs.io/en/latest/index.html
.. _Automatic Package Installation: https://iocage.readthedocs.io/en/latest/advanced-use.html?highlight=pkglist#automatic-package-installation

.. _role vbotka.freebsd.postinstall defaults: https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main
