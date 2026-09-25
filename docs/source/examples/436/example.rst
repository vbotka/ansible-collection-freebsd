.. _example_436:

436 Role vbotka.freebsd.haproxy
-------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: project; Example 436

.. index:: single: HAProxy; Example 436
.. index:: single: role vbotka.freebsd.haproxy; Example 436
.. index:: single: vbotka.freebsd.haproxy; Example 436

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible-nginx`` to create jails in the
``project``. Use the role `vbotka.freebsd.nginx`_ to configure and run `Nginx`_
servers. Use the role `vbotka.freebsd.haproxy`_ to configure and run `HAProxy`_
to loadbalance the `Nginx`_ cluster.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── project-hosts.yml
  │   │   └── project.yml
  │   └── nginx
  │       └── nginx.yml
  ├── hosts
  │   └── 06_iocage2.yml
  ├── host_vars
  │   └── iocage_06
  │       └── haproxy.yml
  ├── iocage.ini
  ├── pb-haproxy.yml
  ├── pb-nginx.yml
  ├── templates
  │   └── index.html.j2
  └── test-haproxy.sh

Synopsis
^^^^^^^^

* On a managed node:

  * In the playbook :ref:`ug_pb-iocage-project-create-from-templates`, create
    ``project`` jails from the template.

  * Use the role `vbotka.freebsd.haproxy`_ to configure and run the `HAProxy`_
    loadbalancer.

* In the inventory group ``nginx``, use the role `vbotka.freebsd.nginx`_ to
  configure the Nginx cluster.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.haproxy`_
* Role `vbotka.freebsd.nginx`_
* Playbook :ref:`ug_pb-iocage-project-create-from-templates`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`

Notes
^^^^^

* TBD

.. note::

   | `vbotka.freebsd.haproxy`_ is the role **haproxy** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_haproxy`_ is the role **freebsd_haproxy** in the namespace `vbotka`_.
   | `vbotka.freebsd.nginx`_ is the role **nginx** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_nginx`_ is the role **freebsd_nginx** in the namespace `vbotka`_.

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
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/project.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/nginx/nginx.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_06/haproxy.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/index.html.j2
   :language: jinja
   :caption:

Playbook output - Create project jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts \
                            vbotka.freebsd.pb_iocage_project_create_from_templates.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-02.txt
   :language: bash

Jails
^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 sudo iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash

Playbook pb-nginx.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-nginx.yml
   :language: yaml+jinja

Playbook output - Configure Nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-nginx.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Playbook pb-haproxy.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-haproxy.yml
   :language: yaml+jinja

Playbook output - Configure HAProxy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -i hosts pb-haproxy.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Script test-haproxy.sh
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: test-haproxy.sh
   :language: bash

Script output - Test HAProxy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   shell> ssh admin@iocage_06 'bash -s' < test-haproxy.sh

.. literalinclude:: out/out-06.txt
   :language: console
   :force:
