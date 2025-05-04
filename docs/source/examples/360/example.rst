.. _example_360:

360 Configure NICs
------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.network; Example 360
.. index:: single: vbotka.freebsd.network; Example 360
.. index:: single: network; Example 360

Use case
^^^^^^^^

Configure NICs using the role `vbotka.freebsd.network`_

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_02.yml
  │   └── iocage_03.yml
  ├── iocage-hosts.ini
  └── pb.yml

Synopsis
^^^^^^^^

* In the playbook *pb.yml* configure network of the iocage hosts.

Requirements
^^^^^^^^^^^^

* root privilege on the iocage hosts.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.network`_ is the role **network** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_network`_ is the role **freebsd_network** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_02.yml
    :language: yaml
    :caption:

.. literalinclude:: host_vars/iocage_03.yml
    :language: yaml
    :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
    :language: yaml

Playbook output - configure network
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i iocage-hosts.ini

.. literalinclude:: out/out-01.txt
    :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network
.. _vbotka.freebsd_network: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_network
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289
