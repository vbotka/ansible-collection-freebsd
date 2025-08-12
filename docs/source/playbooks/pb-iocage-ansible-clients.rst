pb_iocage_ansible_clients
-------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: playbook pb_iocage_ansible_clients.yml; pb_iocage_ansible_clients

Synopsis
^^^^^^^^

This playbook creates jails from the template ``ansible_client``

Examples
^^^^^^^^

clones
""""""

Use the dictionary ``clones``. For example,

.. code-block:: yaml

   clones:
     test_111:
       clone_from: ansible_client
       properties:
         ip4_addr: 'em0|10.1.0.111/24'
     test_112:
       clone_from: ansible_client
       properties:
         ip4_addr: 'em0|10.1.0.112/24'
     test_113:
       clone_from: ansible_client
       properties:
         ip4_addr: 'em0|10.1.0.113/24'

Use the playbook tag ``clone`` to execute selected tasks

.. code-block:: console

   (env) > ansible-playbook pb-iocage_ansible_clients.yml -t clone -e clone=true

creates the clones

.. code-block:: console

   shell> iocage list -l
   +-----+----------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
   | JID |   NAME   | BOOT | STATE | TYPE |     RELEASE     |        IP4        | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+==========+======+=======+======+=================+===================+=====+================+==========+
   | 170 | test_111 | off  | up    | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
   | 171 | test_112 | off  | up    | jail | 14.1-RELEASE-p6 | em0|10.1.0.112/24 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+-------------------+-----+----------------+----------+
   | 172 | test_113 | off  | up    | jail | 14.1-RELEASE-p6 | em0|10.1.0.113/24 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+-------------------+-----+----------------+----------+

swarms
""""""
  
Use the dictionary ``swarms``. For example,

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible_client

Use the playbook tag ``swarm`` to execute selected tasks

.. code-block:: console

   (env) > ansible-playbook pb_iocage_ansible_clients.yml -t swarm -e swarm=true

creates 3 jails from the template ``ansible_client``. The names are generated automatically 

.. code-block:: console

   shell> iocage list -l
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID |   NAME   | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+==========+======+=======+======+=================+====================+=====+================+==========+
   | 64  | 08daa493 | off  | up    | jail | 14.1-RELEASE-p6 | epair0b|10.1.0.114 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 65  | 2746353a | off  | up    | jail | 14.1-RELEASE-p6 | epair0b|10.1.0.187 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 66  | 83707231 | off  | up    | jail | 14.1-RELEASE-p6 | epair0b|10.1.0.233 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+

Default properties
""""""""""""""""""

The dictionary ``properties`` keeps the default properties for both options. For example,

.. code-block:: yaml

   properties:
     vnet: 1
     defaultrouter: 10.1.0.10
     notes: "vmm={{ inventory_hostname }}"

, or

.. code-block:: yaml

   properties:
     bpf: 1
     dhcp: 1
     vnet: 1
     notes: "vmm={{ inventory_hostname }}"

.. seealso::

   :ref:`ug_bp_iocage_tags`

.. hint::

   Take a look at Index and search ``playbook pb_iocage_ansible_client.yml`` to see what examples
   are available.

Workflow
^^^^^^^^

TBD
