pb_iocage_ansible_clients
-------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: playbook pb_iocage_ansible_clients.yml; pb_iocage_ansible_clients

.. index:: single: clones; pb_iocage_ansible_clients
.. index:: single: swarms; pb_iocage_ansible_clients
.. index:: single: clone_host_hostname; pb_iocage_ansible_clients

.. index:: single: mount; pb_iocage_ansible_clients
.. index:: single: fstab; pb_iocage_ansible_clients
.. index:: single: host_hostname; pb_iocage_ansible_clients
.. index:: single: allow_mount; pb_iocage_ansible_clients
.. index:: single: allow_mount_zfs; pb_iocage_ansible_clients
.. index:: single: jail_zfs; pb_iocage_ansible_clients

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

   (env) > ansible-playbook pb_iocage_ansible_clients.yml -t clone -e clone=true

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

clone_host_hostname
"""""""""""""""""""

Use the dictionary ``clone_host_hostname``. The keys are used to create hostnames. Create ``fstab``
entries. See the ``iocage`` property ``host_hostname``. For example,

.. code-block:: yaml

   clones_host_hostname:
     www-5:
       template: ansible_client_apache
       fstab:
         - spec: /usr/local/poudriere
           file: /usr/local/poudriere
           type: nullfs
           options: ro 0 0

Use the playbook tag ``clone_host_hostname`` to execute selected tasks

.. code-block:: console

   (env) > ansible-playbook pb_iocage_ansible_clients.yml \
                            -t clone_host_hostname -e clone_host_hostname=true

default properties
""""""""""""""""""

The dictionary ``properties`` keeps the default properties. For example,

.. code-block:: yaml

   properties:
     notes: "vmm={{ inventory_hostname }}"
     vnet: 1
     defaultrouter: 10.1.0.10

, get the DHCP address

.. code-block:: yaml

   properties:
     notes: "vmm={{ inventory_hostname }}"
     bpf: 1
     dhcp: 1
     vnet: 1

, or mount datasets

.. code-block:: yaml

   properties:
     notes: "vmm={{ inventory_hostname }}"
     bpf: 1
     dhcp: 1
     vnet: 1
     allow_mount: 1
     allow_mount_zfs: 1
     jail_zfs: 1

.. seealso::

   :ref:`ug_bp_iocage_tags`

.. hint::

   Look at the ``Index`` and search the playbook ``pb_iocage_ansible_client.yml`` to see what
   examples are available.

Workflow
^^^^^^^^

TBD
