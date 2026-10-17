.. _example_014:

014 Inventory cache
-------------------

This example extends :ref:`example_013`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: cache; Example 014
   single: inventory cache; Example 014
   single: cache_plugin; Example 014
   single: cache_prefix; Example 014
   single: compose; Example 014
   single: community.general.timestamp; Example 014
   single: inventory vbotka.freebsd.iocage; Example 014
   single: iocage_ip4_dict; Example 014
   single: keyed_groups; Example 014
   single: option cache; Example 014
   single: option cache_plugin; Example 014
   single: option cache_prefix; Example 014
   single: option compose; Example 014
   single: option keyed_groups; Example 014
   single: variable iocage_ip4_dict; Example 014

Use case
^^^^^^^^

Enable and test the inventory cache.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.yml
  ├── pb-cache-dump.yml
  └── pb-vars-ip4.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Fetch inventory using the :ref:`inventory vbotka.freebsd.iocage <ug_inventory_iocage>`.

  * Configure and test ``cache``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Jails created in :ref:`example_013`.

.. seealso::

   * `Inventory plugins`_
   * `Enabling inventory cache plugins`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

Enable cache.

.. literalinclude:: iocage.yml
   :language: yaml+jinja
   :emphasize-lines: 5-9

.. hint::

   If you do not configure ``cache_plugin``, Ansible falls back to
   caching inventory with the configured `fact cache plugin`_. For
   example:

   .. code-block:: ini

      shell> grep fact_caching ansible.cfg
      fact_caching = ansible.builtin.jsonfile
      fact_caching_connection = /var/tmp/ansible_cache
      fact_caching_timeout = 3600
      fact_caching_prefix = ''

Playbook pb-vars-ip4.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
   :language: yaml+jinja
   :caption:

Playbook output - Cache timing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > date +%r; \
           ANSIBLE_STDOUT_CALLBACK=community.general.timestamp \
           ansible-playbook -i iocage.yml pb-vars-ip4.yml
   (env) > sleep 1
   (env) > date +%r; \
           ANSIBLE_STDOUT_CALLBACK=community.general.timestamp \
           ansible-playbook -i iocage.yml pb-vars-ip4.yml

.. literalinclude:: out/out-01.txt
   :language: yaml

.. literalinclude:: out/out-02.txt
   :language: yaml

.. important::

   See: :ref:`ug_qa_cache_fact_vs_inventory`

Cache
^^^^^

Use the below playbook to inspect the cache:

.. literalinclude:: pb-cache-dump.yml
   :language: yaml+jinja
   :caption:

For example:

.. code-block:: console

   (env) > ansible-playbook \
           -e cache_file=/var/tmp/inventory_cache/iocage_05_s1_vbotka.freebsd.iocage_ka06f2d \
           pb-cache-dump.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
