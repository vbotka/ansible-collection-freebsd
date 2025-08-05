.. _example_015:

015 Multiple inventory cache
----------------------------

Extending example :ref:`example_014`.

.. contents::
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
  │   ├── 02_iocage.yml
  │   └── 04_iocage.yml
  └── pb-vars-ip4.yml

Synopsis
^^^^^^^^

At two managed nodes:

* get the dynamic inventory by the `inventory plugin vbotka.freebsd.iocage`_
* configure and test ``cache``

Requirements
^^^^^^^^^^^^

* `inventory plugin vbotka.freebsd.iocage`_
* jails created in :ref:`example_010`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory hosts
^^^^^^^^^^^^^^^

Set unique ``cache_prefix``

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 7-11

.. literalinclude:: hosts/04_iocage.yml
   :language: yaml
   :caption:
   :emphasize-lines: 5-9

.. warning:: Common ``cache_prefix`` would make the cache files to override each other repeatedly.

Playbook pb-vars-ip4.yml
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-vars-ip4.yml
   :language: yaml

Playbook output - display iocage_ip4
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-vars-ip4.yml -i hosts

.. literalinclude:: out/out-01.txt
   :language: yaml

.. note::

   * The inventory files in ``hosts`` are evaluated in alphabetical order.
   * The jail ``ansible_client`` from ``iocage_04`` overrides the one from ``iocage_02``

Cache
^^^^^

Look at the cache

.. code-block:: console

   shell> cat /var/tmp/inventory_cache/iocage_02_vbotka.freebsd.iocage_a5393s_8ea2a

.. literalinclude:: out/out-02.txt
   :language: json

.. code-block:: console

   shell> cat cat /var/tmp/inventory_cache/iocage_04_vbotka.freebsd.iocage_a5393s_d0c35

.. literalinclude:: out/out-03.txt
   :language: json


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage/
