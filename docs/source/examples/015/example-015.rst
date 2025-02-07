.. _example_015:

015 Multiple inventory cache.
-----------------------------

Extending example 014.

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── hosts
   │   ├── 01_iocage.yml
   │   └── 02_iocage.yml
   └── pb-vars-ip4.yml

Synopsis
^^^^^^^^

Cache enabled in multiple inventory files.

Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. index:: single: cache; Example 015
.. index:: single: cache_prefix; Example 015

Set unique *cache_prefix*

.. literalinclude:: hosts/01_iocage.yml
    :language: yaml
    :emphasize-lines: 7-11

Inventory *hosts/02_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Set unique *cache_prefix*

.. literalinclude:: hosts/02_iocage.yml
    :language: yaml
    :emphasize-lines: 7-11

.. warning:: Common *cache_prefix* would make the cache files to override each other repeatedly.

Playbook *pb-vars-ip4.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

.. note::

   * The inventory files in hosts are evaluated in alphabetical order.
   * The jail ansible_client from iocage_02 overrides the one from iocage_01
	       
Cache
^^^^^

.. index:: single: variable iocage_ip4_dict; Example 015
.. index:: single: iocage_ip4_dict; Example 015

Take a look at the cache ::

  shell> cat /var/tmp/inventory_cache/iocage_01_vbotka.freebsd.iocage_a5393s_7eb74

.. literalinclude:: out/out-02.txt
    :language: json

::

  shell> cat /var/tmp/inventory_cache/iocage_02_vbotka.freebsd.iocage_a5393s_5a95f

.. literalinclude:: out/out-03.txt
    :language: json
