.. _example_360:

360 Configure bridge
--------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: network; Example 360
   single: bridge; Example 360
   single: role vbotka.freebsd.network; Example 360
   single: vbotka.freebsd.network; Example 360

Use case
^^^^^^^^

Use the roles `vbotka.freebsd.postinstall`_ and `vbotka.freebsd.network`_ to
configure bridges.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_05
  │   │   ├── loader.yml
  │   │   └── network.yml
  │   └── iocage_06
  │       ├── loader.yml
  │       └── network.yml
  ├── iocage.ini
  ├── pb-loader.yml
  └── pb-network.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-loader.yml``, configure kernel parameters.

  * In the playbook ``pb-network.yml``, configure network parameters.

Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.network`_
* Role `vbotka.freebsd.postinstall`_
* Root privileges on the managed nodes.

Notes
^^^^^

* TBD.

.. note::

   | `vbotka.freebsd.network`_ is the role **network** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_network`_ is the role **freebsd_network** in the namespace `vbotka`_.

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/loader.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_05/network.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/loader.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/network.yml
   :language: yaml+jinja
   :caption:

Playbook pb-loader.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-loader.yml
   :language: yaml+jinja

Playbook output - Configure loader.conf
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-loader.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook pb-network.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-network.yml
   :language: yaml+jinja

Playbook output - Configure network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-network.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

Result
^^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_05]# ifconfig bridge0

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: [iocage_06]# ifconfig bridge0

.. note::

   * MAC addresses are sanitized.