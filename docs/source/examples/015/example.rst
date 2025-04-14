.. _example_015:

015 Multiple inventory cache
----------------------------

Extending example 014.

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: inventory vbotka.freebsd.iocage; Example 015
.. index:: single: option compose; Example 015
.. index:: single: compose; Example 015
.. index:: single: option keyed_groups; Example 015
.. index:: single: keyed_groups; Example 015
.. index:: single: option cache; Example 015
.. index:: single: cache; Example 015
.. index:: single: option cache_plugin; Example 015
.. index:: single: cache_plugin; Example 015
.. index:: single: option cache_prefix; Example 015
.. index:: single: cache_prefix; Example 015
.. index:: single: variable iocage_ip4_dict; Example 015
.. index:: single: iocage_ip4_dict; Example 015

Use case
^^^^^^^^

Enabled cache in multiple inventory files.

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

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory *hosts/01_iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
   :language: yaml

.. note::

   * The inventory files in hosts are evaluated in alphabetical order.
   * The jail ansible_client from iocage_02 overrides the one from iocage_01
	       
Cache
^^^^^

Look at the cache ::

  shell> cat /var/tmp/inventory_cache/iocage_01_vbotka.freebsd.iocage_a5393s_cbc1a

.. literalinclude:: out/out-02.txt
   :language: json

::

  shell> cat /var/tmp/inventory_cache/iocage_02_vbotka.freebsd.iocage_a5393s_8ea2a

.. literalinclude:: out/out-03.txt
   :language: json


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
