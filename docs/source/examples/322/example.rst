.. _example_322:

322 Create local package repository
-----------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: pkg repo; Example 322
   single: role vbotka.freebsd.packages; Example 322
   single: vbotka.freebsd.packages; Example 322
   single: role vbotka.freebsd.nginx; Example 322
   single: vbotka.freebsd.nginx; Example 322
   single: filter vbotka.freebsd.to_ucl; Example 322
   single: vbotka.freebsd.to_ucl; Example 322
   single: to_ucl; Example 322

Use case
^^^^^^^^

Fetch packages and create a local package repository. Configure a web server to
publish the repository.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       ├── fetch.yml
  │       ├── nginx.yml
  │       ├── project-hosts.yml
  │       └── repos.yml
  ├── iocage.ini
  ├── pb-nginx.yml
  └── pb-packages.yml

Synopsis
^^^^^^^^

* On a managed node:

  * Fetch packages and configure a package repository. Use the role
    `vbotka.freebsd.packages`_.

  * Install and configure Nginx to publish the repository. Use the role
    `vbotka.freebsd.nginx`_.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.packages`_
* `Role vbotka.freebsd.nginx`_

Notes
^^^^^

* TBD

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
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/repos.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/fetch.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/nginx.yml
   :language: yaml+jinja
   :caption:

Playbook pb-packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-packages.yml
   :language: yaml+jinja

Playbook output - Create repo and fetch packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t pkg_fetch,pkg_conf pb-packages.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

Playbook pb-nginx.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-nginx.yml
   :language: yaml+jinja

Playbook output - Configure Nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-nginx.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja

List repo
^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_05 fetch -qo - http://localhost

.. literalinclude:: out/out-04.txt
   :language: html

.. code-block:: console

   shell> ssh admin@iocage_06 fetch -qo - http://localhost

.. literalinclude:: out/out-06.txt
   :language: html