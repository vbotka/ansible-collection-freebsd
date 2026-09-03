.. _example_322:

322 Create local package repository
-----------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkg repo; Example 322
.. index:: single: role vbotka.freebsd.packages; Example 322
.. index:: single: vbotka.freebsd.packages; Example 322
.. index:: single: role vbotka.freebsd.nginx; Example 322
.. index:: single: vbotka.freebsd.nginx; Example 322

Use case
^^^^^^^^

Create local package repository and fetch packages. Configure a web server to
publish the repository.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project-hosts.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── fetch.yml
  │       ├── nginx.yml
  │       └── repos.yml
  ├── iocage.ini
  ├── pb-nginx.yml
  └── pb-packages.yml

Synopsis
^^^^^^^^

* At a managed node:

  - Use the role `vbotka.freebsd.packages`_ to configure a package repo and
    fetch packages.

  - Use the role `vbotka.freebsd.nginx`_ to publish the repo.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.nginx`_
* role `vbotka.freebsd.packages`_

Notes
^^^^^

TBD

.. note::

   TBD

.. seealso::

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

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/repos.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_06/fetch.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_06/nginx.yml
   :language: yaml+jinja
   :caption:

Playbook pb-packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-packages.yml
   :language: yaml

Playbook output - Create repo and fetch packages 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-playbook -i iocage.ini -t pkg_conf,pkg_fetch pb-packages.yml

.. literalinclude:: out/out-01.txt
   :language: yaml

Playbook pb-nginx.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-nginx.yml
   :language: yaml

Playbook output - Configure Nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ansible-playbook -i iocage.ini pb-nginx.yml

.. literalinclude:: out/out-02.txt
   :language: yaml

List repo
^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 fetch -qo - http://localhost

.. literalinclude:: out/out-04.txt
   :language: html


.. _vbotka.freebsd.nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/nginx/
.. _vbotka.freebsd.packages: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/packages/

.. _man pkg: https://man.freebsd.org/cgi/man.cgi?pkg(8)
.. _man pkg.conf: https://man.freebsd.org/cgi/man.cgi?pkg.conf(5)
