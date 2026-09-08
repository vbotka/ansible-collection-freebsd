.. _example_209:

209 Create iocage pkglist file
------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkglist; Example 209
.. index:: single: pkgs.json; Example 209
.. index:: single: role vbotka.freebsd.iocage; Example 209
.. index:: single: template ansible-client-apache; Example 209
.. index:: single: ansible-client-apache; Example 209
.. index:: single: pb_iocage_template.yml; Example 209
.. index:: single: Apache HTTP Server; Example 209

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to create an `iocage`_ package list for
`Automatic Package Installation`_. Create an Ansible template for the `Apache HTTP
Server`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── files
  │   ├── pk_admins.txt
  │   └── pkgs.json
  ├── group_vars
  │   └── all
  │       ├── pkgdict_versions.yml
  │       ├── pkgdict.yml
  │       └── pkglist.yml
  ├── host_vars
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-pkglist.yml

Synopsis
^^^^^^^^

On a managed node:

* Use the `role vbotka.freebsd.iocage`_ to create the `iocage`_ package list
  ``files/pkgs.json`` for `Automatic Package Installation`_ of the `Apache HTTP
  Server`_.

* Use the playbook `vbotka.freebsd.pb_iocage_template.yml`_ to create the Ansible
  template ``ansible-client-apache``.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* Playbook `vbotka.freebsd.pb_iocage_template.yml`_

Notes
^^^^^

* Use the same ``pkgdict_*.yml`` variables in:

  * `role vbotka.freebsd.poudriere`_ to build packages
  * `role vbotka.freebsd.packages`_ to install packages
  * `role vbotka.freebsd.iocage`_ to install packages in jails

* The inventory ``iocage.ini`` is not needed to create the file
  ``pkgs.json``. It would be sufficient to run the play on ``localhost``. It
  is used here because normally the ``pkgs.json`` files, after being created,
  are used on the ``iocage`` managed nodes.

* This example covers the simplest case of creating a common ``pkgs.json`` file
  for all managed nodes in the group ``iocage``.

* See the tasks in ``playbooks/pb_iocage_template/pkglist.yml`` to see how the ``template``
  attribute ``pkglist`` is used.

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

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml
   :caption:

Playbook pb-pkglist.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkglist.yml
   :language: yaml

Playbook output - Create pkgs.json
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-pkglist.yml

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

   (env) > ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_template.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-03.txt
   :language: sh

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _role vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere/
.. _role vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/
.. _vbotka.freebsd.pb_iocage_template.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_template.yml

.. _man 8 iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage
.. _iocage: https://freebsd.github.io/iocage/index.html
.. _Automatic Package Installation: https://freebsd.github.io/iocage/advanced-use.html?highlight=pkglist#automatic-package-installation

.. _role vbotka.freebsd.postinstall defaults: https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main
.. _Apache HTTP Server: https://httpd.apache.org/