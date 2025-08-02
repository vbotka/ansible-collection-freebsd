.. _example_014:

014 Inventory cache
-------------------

Extending example :ref:`example_010`.

.. contents::
   :local:
   :depth: 1

.. index:: single: cache; Example 014
.. index:: single: cache_plugin; Example 014
.. index:: single: cache_prefix; Example 014
.. index:: single: compose; Example 014
.. index:: single: community.general.timestamp; Example 014
.. index:: single: inventory vbotka.freebsd.iocage; Example 014
.. index:: single: iocage_ip4_dict; Example 014
.. index:: single: keyed_groups; Example 014
.. index:: single: option cache; Example 014
.. index:: single: option cache_plugin; Example 014
.. index:: single: option cache_prefix; Example 014
.. index:: single: option compose; Example 014
.. index:: single: option keyed_groups; Example 014
.. index:: single: variable iocage_ip4_dict; Example 014
.. index:: single: option --flush-cache; Example 014

Use case
^^^^^^^^

Enable and test inventory cache.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.yml
  └── pb-vars-ip4.yml

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

.. seealso::

   * `Inventory plugins`_
   * `Enabling inventory cache plugins`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.yml
^^^^^^^^^^^^^^^^^^^^

Enable cache

.. literalinclude:: iocage.yml
   :language: yaml
   :emphasize-lines: 7-11

.. hint::

   If you do not configure ``cache_plugin``, Ansible falls back to caching inventory with the `fact
   cache plugin`_ you configured. For example,

   .. code-block:: ini

      shell> grep fact_caching ansible.cfg
      fact_caching = ansible.builtin.jsonfile
      fact_caching_connection = /var/tmp/ansible_cache
      fact_caching_timeout = 3600
      fact_caching_prefix = ''

Playbook pb-vars-ip4.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
   :language: yaml

Playbook output - cache disabled
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| It takes 4s to create the dynamic inventory and construct the variables if ``cache`` is disabled.
| (The ``cache`` is disabled in ``iocage.yml``. ``cache=False``)

.. code-block:: console

   (env) > date +%r; \
           ANSIBLE_STDOUT_CALLBACK=community.general.timestamp \
           ansible-playbook pb-vars-ip4.yml -i iocage.yml -l test_113

.. literalinclude:: out/out-01.txt
   :language: bash
   :emphasize-lines: 1,3

Playbook output - cache enabled
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the ``cache`` is enabled, the inventory and variables are provided by the cache immediately

.. code-block:: console

   (env) > date +%r; \
           ANSIBLE_STDOUT_CALLBACK=community.general.timestamp \
           ansible-playbook pb-vars-ip4.yml -i iocage.yml -l test_113

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:
   :emphasize-lines: 1,3

.. hint::

   Use the option `--flush-cache`_ to clear the cache.

Cache
^^^^^

Look at the cache

.. code-block:: console

   shell> cat /var/tmp/inventory_cache/iocage_vbotka.freebsd.iocage_a5393s_6a9dd

.. literalinclude:: out/out-03.txt
   :language: json


.. _Enabling inventory cache plugins: https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-inventory-cache-plugins
.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
.. _Inventory plugins: https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins
.. _fact cache plugin: https://docs.ansible.com/ansible/latest/plugins/cache.html#enabling-fact-cache-plugins

.. _--flush-cache: https://docs.ansible.com/ansible/latest/cli/ansible-playbook.html#cmdoption-ansible-playbook-flush-cache
