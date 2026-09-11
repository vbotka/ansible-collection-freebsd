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
.. index:: single: filter vbotka.freebsd.to_ucl; Example 322
.. index:: single: vbotka.freebsd.to_ucl; Example 322
.. index:: single: to_ucl; Example 322

Use case
^^^^^^^^

Create a local package repository and fetch packages. Configure a web server to
publish the repository.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── project-hosts.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── fetch.yml
  │       ├── nginx.yml
  │       └── repos.yml
  ├── iocage.ini
  ├── pb-nginx.yml
  └── pb-packages.yml

Synopsis
^^^^^^^^

* On a managed node:

  * Use the role `vbotka.freebsd.packages`_ to configure a package repository and
    fetch packages.
  * Use the role `vbotka.freebsd.nginx`_ to publish the repository.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.nginx`_
* Role `vbotka.freebsd.packages`_
* Filter `vbotka.freebsd.to_ucl`_

Notes
^^^^^

* TBD

.. seealso::

   * `man pkg`_
   * `man pkg.conf`_
   * Example :ref:`example_043`

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

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/repos.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/fetch.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/nginx.yml
   :language: yaml+jinja
   :caption:

Playbook pb-packages.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-packages.yml
   :language: yaml+jinja

Playbook output - Create repo and fetch packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -t pkg_conf,pkg_fetch pb-packages.yml

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

   shell> ssh admin@iocage_06 fetch -qo - http://localhost

.. literalinclude:: out/out-04.txt
   :language: html
