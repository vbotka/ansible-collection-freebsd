.. _ug_concepts_iocage_tags:

iocage tags
-----------

.. index:: single: variable iocage_tags; iocage tags
.. index:: single: iocage_tags; iocage tags
.. index:: single: tag; iocage tags

.. contents::
   :local:
   :depth: 2

An iocage tag is a key-value pair applied to a jail to store jail
metadata.  Each tag is a label consisting of a key and an optional
value. When processed by the inventory plugin, these tags are stored
in the ``iocage_tags`` dictionary.

The format for iocage tags used in this guide is ``tag1=val1 tag2=val2
...``.  See the regular expression pattern in the `Dictionary
iocage_tags`_ section below.

.. note::

   These tags are completely separate from `Ansible Tags`_. In this
   document, a bare reference to *tag* refers to an Ansible tag,
   whereas *iocage tag(s)* always references attributes stored in the
   ``iocage_tags`` dictionary.

Property notes
^^^^^^^^^^^^^^

The ``iocage`` property ``notes`` is used to store ``iocage tags``. As
described in `man iocage`_:

.. code-block:: text

   PROPERTIES
   ...
   notes="any string"
          Custom notes for miscellaneous tagging.
          Default: none
          Source: local

For example, define ``notes`` within the ``clones`` dictionary:

.. code-block:: yaml

   clones:
     test_111:
       clone_from: ansible_client
       properties:
         ip4_addr: 'em0|10.1.0.111/24'
         notes: "vmm={{ inventory_hostname }} swarm=sw_01"

or within the ``swarms`` dictionary:

.. code-block:: yaml

   swarms:
     sw_01:
       count: 3
       template: ansible_client
       properties:
         notes: "vmm={{ inventory_hostname }}"

When the playbook :ref:`ug_pb-iocage-ansible-client` provisions jails
on host ``iocage_02``:

.. code-block:: console
   :emphasize-lines: 1

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

it populates the ``notes`` property:

.. code-block:: console
   :emphasize-lines: 1,4,7

   [iocage_02]# iocage get notes afa9e515
   vmm=iocage_02 swarm=sw_01

   [iocage_02]# iocage get notes c1670497
   vmm=iocage_02 swarm=sw_01

   [iocage_02]# iocage get notes test_111
   vmm=iocage_02 swarm=sw_01

.. note::

   The tasks in ``pb-iocage-ansible-clients/swarm.yml`` create the
   iocage tag ``swarm`` automatically using keys from the ``swarms``
   dictionary.

.. seealso::

   Example :ref:`example_206`

Dictionary iocage_tags
^^^^^^^^^^^^^^^^^^^^^^

In the `inventory plugin vbotka.freebsd.iocage`_, enable the parameter
``get_properties``, compose the dictionary ``iocage_tags``, and use it
to generate ``keyed_groups``:

.. code-block:: yaml

   get_properties: true
   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
   keyed_groups:
     - prefix: swarm
       key: iocage_tags.swarm
     - prefix: vmm
       key: iocage_tags.vmm

The inventory plugin populates the ``iocage_tags`` variable for each host:

.. code-block:: yaml

   iocage_tags:
     swarm: sw_01
     vmm: iocage_02

which Ansible then uses to construct inventory groups:

.. code-block:: console
   :emphasize-lines: 1

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

   Search for ``iocage_tags`` in the Index to find related examples.
