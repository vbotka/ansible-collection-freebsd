iocage tags
-----------

.. index:: single: variable iocage_tags; iocage tags
.. index:: single: iocage_tags; iocage tags

An iocage tag is a key-value pair applied to a jail to hold metadata about that jail. Each tag is a
label consisting of a key and an optional value. The iocage tags are stored in the dictionary
*iocage_tags*.

.. note::

   The ``iocage tags`` are not related to `Ansible Tags`_ in any way. In this document, a ``tag``
   means an Ansible tag while ``iocage tag(s)`` always reference attribute(s) of the dictionary
   ``iocage_tags``.

property notes
""""""""""""""

We use the *iocage* property *notes* to store *iocage tags*. Quoting from `man iocage`_

.. code-block:: text

   notes="any string"
                 Custom notes for miscellaneous tagging.
                 Default: none
                 Source: local

For example, put the *notes* into the dictionary *clones*

.. code-block:: yaml

   clones:
     test_111:
       clone_from: ansible_client
       properties:
         ip4_addr: 'em0|10.1.0.111/24'
         notes: "vmm={{ inventory_hostname }} swarm=sw_01"


, or into the dictionary *swarms*

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible_client
       properties:
         notes: "vmm={{ inventory_hostname }}"

Then, the playbook :ref:`ug_pb-iocage-ansible-client` creates jails, for example, on the host
*iocage_02*

.. code-block:: sh

   [iocage_02]# iocage list -l
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | JID |   NAME   | BOOT | STATE | TYPE |     RELEASE     |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
   +=====+==========+======+=======+======+=================+====================+=====+================+==========+
   | 149 | afa9e515 | off  | up    | jail | 14.1-RELEASE-p6 | epair0b|10.1.0.122 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 148 | c1670497 | off  | up    | jail | 14.1-RELEASE-p6 | epair0b|10.1.0.135 | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+
   | 147 | test_111 | off  | up    | jail | 14.1-RELEASE-p6 | em0|10.1.0.111/24  | -   | ansible_client | no       |
   +-----+----------+------+-------+------+-----------------+--------------------+-----+----------------+----------+


with *notes*

.. code-block:: sh
		
   [iocage_02]# iocage get notes afa9e515
   vmm=iocage_02 swarm=sw_01
   [iocage_02]# iocage get notes c1670497
   vmm=iocage_02 swarm=sw_01
   [iocage_02]# iocage get notes test_111
   vmm=iocage_02 swarm=sw_01

.. note::

   The tasks *pb-iocage-ansible-clients/swarm.yml* create the iocage tag *swarm* automatically from
   the dictionary *swarms* keys.
   
.. seealso::

   The example :ref:`example_206`

dictionary iocage_tags
""""""""""""""""""""""

In the `inventory plugin vbotka.freebsd.iocage`_ enable the option *get_properties*, *compose*
the dictionary *iocage_tags*, and use it to create *keyed_groups*

.. code-block:: yaml

   get_properties: True
   compose:
     iocage_tags: dict(iocage_properties.notes | split | map('split', '='))
   keyed_groups:
     - prefix: swarm
       key: iocage_tags.swarm
     - prefix: vmm
       key: iocage_tags.vmm

Then, this plugin creates the dictionary *iocage_tags* in each jail

.. code-block:: yaml

   iocage_tags:
     swarm: sw_01
     vmm: iocage_02

and use it to create the groups

.. code-block:: sh

   (env) > ansible-inventory -i hosts --graph
   @all:
     |--@ungrouped:
     |--@swarm_sw_01:
     |  |--afa9e515
     |  |--c1670497
     |  |--test_111
     |--@vmm_iocage_02:
     |  |--afa9e515
     |  |--c1670497
     |  |--test_111

.. hint::

   Take a look at Index and search ``iocage_tags`` to see what examples are available.


.. _Ansible Tags: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html
.. _man iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
