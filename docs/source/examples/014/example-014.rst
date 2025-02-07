.. _example_014:

014 Inventory cache.
--------------------

Extending example 010.

.. contents:: Table of Contents
   :depth: 2

Synopsis
^^^^^^^^

.. index:: single: cache; Example 014
.. index:: single: cache_plugin; Example 014

Enable and test inventory cache.

Playbook *pb-vars-ip4.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

| It takes 4s in this case to create the dynamic inventory and construct the variables.
| (The cache is disabled in *iocage.yml*. *cache=False*)

.. literalinclude:: out/out-01.txt
    :language: bash

Inventory *iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^

Enable cache

.. literalinclude:: iocage.yml
    :language: yaml
    :emphasize-lines: 7-11

.. seealso::

   * `Inventory plugins`_
   * `Enabling inventory cache plugins`_

.. hint::

   If you do not configure *cache_plugin* Ansible falls back to
   caching inventory with the fact cache plugin you configured. For
   example, ::

     shell> grep fact_caching ansible.cfg
     fact_caching = ansible.builtin.jsonfile
     fact_caching_connection = /var/tmp/ansible_cache
     fact_caching_timeout = 3600
     fact_caching_prefix = ''

		      
Playbook output
^^^^^^^^^^^^^^^

If the cache is enabled the inventory and variables are provided by
the cache immediately

.. literalinclude:: out/out-02.txt
    :language: bash


Cache
^^^^^

.. index:: single: variable iocage_ip4_dict; Example 014
.. index:: single: iocage_ip4_dict; Example 014

Take a look at the cache ::

  shell> cat /var/tmp/inventory_cache/iocage_vbotka.freebsd.iocage_a5393s_6a9dd

.. literalinclude:: out/out-03.txt
    :language: json


.. _Enabling inventory cache plugins: https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins
.. _Inventory plugins: https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins
