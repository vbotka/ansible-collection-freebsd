.. _example_527:

527 iocage template ansible-pkg-repo
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: pkg repo; Example 527
.. index:: single: template ansible-pkg-repo; Example 527
.. index:: single: role vbotka.freebsd.iocage_template; Example 527
.. index:: single: pb_iocage_project_create_from_templates; Example 527

.. index:: single: connection vbotka.freebsd.jailexec; Example 527
.. index:: single: vbotka.freebsd.jailexec; Example 527
.. index:: single: jailexec; Example 527

.. index:: single: inventory vbotka.freebsd.iocage2; Example 527

.. index:: single: filter vbotka.freebsd.dict_to_ast; Example 527
.. index:: single: vbotka.freebsd.dict_to_ast; Example 527
.. index:: single: dict_to_ast; Example 527

.. index:: single: filter vbotka.freebsd.ast_to_nginx; Example 527
.. index:: single: vbotka.freebsd.ast_to_nginx; Example 527
.. index:: single: ast_to_nginx; Example 527

.. index:: single: Nginx; Example 527

Use case
^^^^^^^^

Create a jail that serves pkg repo for other jails. Create `iocage`_ template
``ansible-pkg-repo`` and configure web server to publish the repo. Create a jail
from the template and fetch packages to the repo.

Tree
^^^^
::
   
  shell > tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── project-hosts.yml
  │   │   ├── project.yml
  │   │   └── template.yml
  │   └── fetch_pkg_repo
  │       └── pkg-repo.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       ├── local-pkg-conf.yml
  │       ├── nginx-pkg-repo.yml
  │       └── template.yml
  ├── iocage.ini
  ├── pb-iocage-template.yml
  ├── pb-pkg-repo.yml
  └── templates
      ├── local.conf.j2
      └── nginx-pkg-repo.conf.j2

Synopsis
^^^^^^^^

* At a managed node:

  * Use the role `vbotka.freebsd.iocage_template`_ to create the template
    ``ansible-pkg-repo``

  * In the playbook
    `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
    create a jail from the template.

* In the inventory group ``fetch_pkg_repo`` fetch the selected packages to the
  repo.

Requirements
^^^^^^^^^^^^

* role `vbotka.freebsd.iocage_template`_
* playbook `vbotka.freebsd.pb_iocage_project_create_from_templates.yml`_
* filter `vbotka.freebsd.dict_to_ast`_
* filter `vbotka.freebsd.ast_to_nginx`_
* `inventory plugin vbotka.freebsd.iocage2`_
* :ref:`ug_connection_jailexec`
* package repository created in :ref:`example_322`

.. seealso::

   Example :ref:`example_042`

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

.. literalinclude:: group_vars/all/template.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/fetch_pkg_repo/pkg-repo.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/local-pkg-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/nginx-pkg-repo.yml
   :language: yaml+jinja
   :caption:

.. important::

   This configuration is minimal and functional for an isolated lab or trusted
   internal LAN, but it poses several security risks in production or shared
   network environments.

.. literalinclude:: host_vars/iocage_06/template.yml
   :language: yaml
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/local.conf.j2
   :language: jinja
   :caption:

.. literalinclude:: templates/nginx-pkg-repo.conf.j2
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

Playbook pb-pkg-repo.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-pkg-repo.yml
   :language: yaml+jinja

Playbook output - Fetch packages to repo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-pkg-repo.yml

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:

List repo
^^^^^^^^^

.. code-block:: console

   shell > ssh admin@iocage_06 fetch -qo - http://172.16.99.23/

.. literalinclude:: out/out-07.txt
   :language: html
   :force:


.. _vbotka.freebsd.iocage_template: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage_template/
.. _vbotka.freebsd.pb_iocage_project_create_from_templates.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_project_create_from_plugins.yml/

.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
.. _vbotka.freebsd.dict_to_ast: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/dict_to_ast/
.. _vbotka.freebsd.ast_to_nginx: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/filter/ast_to_nginx/

.. _iocage: https://iocage.readthedocs.io/en/latest/

.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-syslogng-server: https://github.com/vbotka/ansible-conf-syslogng-server
.. _ansible-conf-syslogng-client: https://github.com/vbotka/ansible-conf-syslogng-client
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test
