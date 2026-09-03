.. _example_435:

435 Role vbotka.freebsd.nginx
-----------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: Nginx; Example 435
.. index:: single: role vbotka.freebsd.nginx; Example 435
.. index:: single: vbotka.freebsd.nginx; Example 435
.. index:: single: template ansible-nginx; Example 435
.. index:: single: ansible-nginx; Example 435

Use case
^^^^^^^^

Create `iocage`_ template ``ansible-nginx``. Create jails from the template.

Tree
^^^^

::

  shell> tree .
  ├── ansible.cfg
  ├── files
  │   └── index.html
  ├── group_vars
  │   ├── all
  │   │   ├── project-hosts.yml
  │   │   ├── project.yml
  │   │   └── templates.yml
  │   └── nginx
  │       └── nginx.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── pb-nginx.yml
  └── templates
      └── local.conf.j2

Synopsis
^^^^^^^^

* At a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the template
    ``ansible-nginx``

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_ create jails
    from the template.

* In the inventory group ``nginx`` use the role `vbotka.freebsd.nginx`_ to
  configure the Nginx servers.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* role `vbotka.freebsd.nginx`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* `inventory plugin vbotka.freebsd.iocage2`_
* :ref:`ug_connection_jailexec`

Notes
^^^^^

* TBD

.. seealso::

   * TBD

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/templates.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/nginx/nginx.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/local-pkg-conf.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_06/template.yml
   :language: yaml
   :caption:

files
^^^^^

.. literalinclude:: files/index.html
   :language: html
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
   :caption:

Playbook pb-iocage-template.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-template.yml
   :language: yaml+jinja

Playbook output - Create iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-iocage-template.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:
      
List templates
^^^^^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 sudo iocage list -lt

.. literalinclude:: out/out-02.txt
   :language: sh

Playbook output - Create project jails from iocage templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Inventory graph
^^^^^^^^^^^^^^^
.. code-block:: console

   shell > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: sh

List jails
^^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-05.txt
   :language: sh

Playbook pb-nginx.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-nginx.yml
   :language: yaml+jinja

Playbook output - Configure Nginx servers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-nginx.yml

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

Results
^^^^^^^

* Test the configuration

  .. code-block:: console

     [iocage_06]# iocage exec www-01 service nginx configtest
     Performing sanity check on nginx configuration:
     nginx: the configuration file /usr/local/etc/nginx/nginx.conf syntax is ok
     nginx: configuration file /usr/local/etc/nginx/nginx.conf test is successful


* Test the server is running

  .. code-block:: console
     
     [iocage_06]# iocage exec www-01 service nginx status
     nginx is running as pid 51207.

* Test the server is working. See the IP in the list of the jails.

  .. code-block:: console

    [iocage_06]#  lynx 172.16.99.116

    It works!

    
.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _vbotka.freebsd.nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/nginx/
.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
