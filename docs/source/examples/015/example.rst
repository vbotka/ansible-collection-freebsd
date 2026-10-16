.. _example_015:

015 Multiple inventory caches
-----------------------------

This example extends :ref:`example_014`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: cache; Example 015
   single: inventory cache; Example 015
   single: cache_plugin; Example 015
   single: cache_prefix; Example 015
   single: compose; Example 015
   single: inventory vbotka.freebsd.iocage; Example 015
   single: iocage_ip4_dict; Example 015
   single: option cache; Example 015
   single: option cache_plugin; Example 015
   single: option cache_prefix; Example 015
   single: option compose; Example 015
   single: variable iocage_ip4_dict; Example 015

Use case
^^^^^^^^

Enable caching across multiple inventory files.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage.yml
  │   └── 06_iocage.yml
  ├── pb-cache-dump.yml
  └── pb-vars-ip4.yml

Synopsis
^^^^^^^^

* On managed nodes:

  * Fetch dynamic inventory using the :ref:`inventory
    vbotka.freebsd.iocage <ug_inventory_iocage>`.

  * Configure and test ``cache``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage`
* Jails created in :ref:`example_013`.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4-8

.. literalinclude:: hosts/06_iocage.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4-8

.. important::

   * Set a unique ``cache_prefix``.

   * Using a common ``cache_prefix`` causes the cache files to overwrite each
     other.

Playbook pb-vars-ip4.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
   :language: yaml+jinja

Playbook output - Display iocage_ip4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-vars-ip4.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja

.. note::

   * The inventory files in the directory ``hosts`` are evaluated in
     alphabetical order.

   * The jail ``ansible-test`` from ``06_iocage.yml`` overrides the one from
     ``05_iocage.yml``.

Cache
^^^^^

Use the playbook below to inspect the cache:

.. literalinclude:: pb-cache-dump.yml
   :language: yaml+jinja
   :caption:

For example:

.. code-block:: console

   (env) > ansible-playbook \
           -e cache_file=/var/tmp/inventory_cache/iocage_05_s1_vbotka.freebsd.iocage_k9573e1 \
           pb-cache-dump.yml

.. literalinclude:: out/out-02.txt
   :language: yaml

.. code-block:: console

   (env) > ansible-playbook \
           -e cache_file=/var/tmp/inventory_cache/iocage_06_s1_vbotka.freebsd.iocage_k8aa36d \
           pb-cache-dump.yml

.. literalinclude:: out/out-03.txt
   :language: yaml
