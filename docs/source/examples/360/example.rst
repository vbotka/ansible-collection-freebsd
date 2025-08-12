.. _example_360:

360 Configure bridge
--------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: network; Example 360
.. index:: single: bridge; Example 360
.. index:: single: role vbotka.freebsd.network; Example 360
.. index:: single: vbotka.freebsd.network; Example 360

Use case
^^^^^^^^

Use the role `vbotka.freebsd.network`_ to configure bridges.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── iocage.yml
  ├── host_vars
  │   ├── iocage_03.yml
  │   └── iocage_04.yml
  ├── iocage.ini
  ├── pb-loader.yml
  └── pb-network.yml
  
Synopsis
^^^^^^^^

* Configure ``/boot/loader.conf``
* Configure bridges.

Requirements
^^^^^^^^^^^^

* root privilege in the managed nodes.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.network`_ is the role **network** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_network`_ is the role **freebsd_network** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_03.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_04.yml
   :language: yaml
   :caption:

Playbook pb-loader.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-loader.yml
   :language: yaml

Playbook output - Configure loader.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-loader.yml -i iocage.ini

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook pb-network.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-network.yml
   :language: yaml

Playbook output - Configure network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-network.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Result
^^^^^^

MACs are sanitized.

.. code-block:: console

   (env) > ssh admin@10.1.0.17 ifconfig bridge0

.. literalinclude:: out/out-03.txt
   :language: bash

.. code-block:: console

   (env) > ssh admin@10.1.0.29 ifconfig bridge0

.. literalinclude:: out/out-04.txt
   :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
.. _vbotka.freebsd_network: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_network/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/
