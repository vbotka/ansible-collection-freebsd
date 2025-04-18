.. _example_315:

315 Role vbotka.freebsd.network
-------------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.network; Example 315
.. index:: single: vbotka.freebsd.network; Example 315
.. index:: single: network; Example 315

Use case
^^^^^^^^

Configure network using the role `vbotka.freebsd.network`_

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

.. code:: bash

   (env) > ansible-playbook pb.yml -i iocage-hosts.ini

.. literalinclude:: out/out-01.txt
    :language: bash

     
.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network/
