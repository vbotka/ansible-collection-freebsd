.. _example_437:

437 Role vbotka.freebsd.haproxy (swarm)
---------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: swarms; Example 437
   single: swarms create from templates; Example 437
   single: pb_iocage_ansible_clients.yml; Example 437
   single: HAProxy; Example 437
   single: role vbotka.freebsd.haproxy; Example 437
   single: vbotka.freebsd.haproxy; Example 437

Use case
^^^^^^^^

Use the `iocage`_ template ``ansible-nginx`` to create jails in ``swarm``. Use
the role `vbotka.freebsd.nginx`_ to configure and run `Nginx`_ servers. Use the
role `vbotka.freebsd.haproxy`_ to configure and run `HAProxy`_ to loadbalance
the `Nginx`_ cluster.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   ├── all
  │   │   ├── project-hosts.yml
  │   │   └── swarms.yml
  │   └── nginx
  │       └── nginx.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── haproxy.yml
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

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`, create jails in a
    ``swarm`` from the templates.

  * Use the role `vbotka.freebsd.haproxy`_ to configure and run the `HAProxy`_
    loadbalancer.

* In the inventory group ``nginx``, use the role `vbotka.freebsd.nginx`_ to
  configure the Nginx cluster.

* Use the script ``test-haproxy.sh`` to test `HAProxy`_.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.haproxy`_
* Role `vbotka.freebsd.nginx`_
* Playbook :ref:`ug_pb-iocage-ansible-clients`
* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* :ref:`example_312`

Notes
^^^^^

* TBD.

.. note::

   | `vbotka.freebsd.haproxy`_ is the role **haproxy** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_haproxy`_ is the role **freebsd_haproxy** in the namespace `vbotka`_.
   | `vbotka.freebsd.nginx`_ is the role **nginx** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_nginx`_ is the role **freebsd_nginx** in the namespace `vbotka`_.

.. seealso::

   * TBD.

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

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/project-hosts.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/swarms.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/nginx/nginx.yml
   :language: yaml+jinja
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/haproxy.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/haproxy.yml
   :language: yaml+jinja
   :caption:

templates
^^^^^^^^^

.. literalinclude:: templates/index.html.j2
   :language: jinja
   :caption:

Playbook output - Create jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            -e iocage_jails_source=inventory \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05] iocage list -l

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06] iocage list -l

Playbook pb-nginx.yml
^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-nginx.yml
   :language: yaml+jinja

Playbook output - Configure Nginx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-nginx.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook pb-haproxy.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-haproxy.yml
   :language: yaml+jinja

Playbook output - Configure HAProxy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-haproxy.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Results
^^^^^^^

* Test the configuration:

  .. literalinclude:: out/out-07.txt
     :language: console
     :caption: [iocage_05] service haproxy configtest 2>&1

  .. literalinclude:: out/out-08.txt
     :language: console
     :caption: [iocage_06] service haproxy configtest 2>&1

  .. note::

     When the configuration syntax is valid, ``service haproxy configtest`` produces
     no output.

* Test that the server is running:

  .. literalinclude:: out/out-09.txt
     :language: console
     :caption: [iocage_05] service haproxy status 2>&1

  .. literalinclude:: out/out-10.txt
     :language: console
     :caption: [iocage_06] service haproxy status 2>&1

Script test-haproxy.sh
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: test-haproxy.sh
   :language: bash

Script output - Test HAProxy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-11.txt
   :language: console
   :caption: [iocage_05] test-haproxy.sh 172.16.95.1

.. literalinclude:: out/out-12.txt
   :language: console
   :caption: [iocage_06] test-haproxy.sh 172.16.99.1