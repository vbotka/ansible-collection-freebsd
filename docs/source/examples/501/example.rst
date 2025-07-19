.. _example_501:

501 iocage host
---------------

.. contents::
   :local:
   :depth: 1

.. index:: single: network; Example 501
.. index:: single: role vbotka.freebsd.network; Example 501
.. index:: single: vbotka.freebsd.network; Example 501
.. index:: single: pf; Example 501
.. index:: single: role vbotka.freebsd.pf; Example 501
.. index:: single: vbotka.freebsd.pf; Example 501
.. index:: single: iocage ZFS; Example 501
.. index:: single: role vbotka.freebsd.zfs; Example 501
.. index:: single: vbotka.freebsd.zfs; Example 501

Use case
^^^^^^^^

Configure iocage host.

Tree
^^^^

::

  shell > tree .
  .
  ├── ansible.cfg
  ├── example.rst
  ├── host_vars
  │   └── iocage_04
  │       ├── network.yml
  │       ├── pf.yml
  │       └── zfs.yml
  ├── iocage.ini
  ├── pb-network.yml
  ├── pb-pf.yml
  └── pb-zfs.yml

Synopsis
^^^^^^^^

* At the iocage host ``iocage_04``

  * configure network
  * configure ``pf``
  * create ZFS pool ``iocage``

Requirements
^^^^^^^^^^^^

Roles:

* `vbotka.freebsd.network`_
* `vbotka.freebsd.pf`_
* `vbotka.freebsd.zfs`_
* `vbotka.freebsd.postinstall`_

Notes
^^^^^

* The role `vbotka.freebsd.postinstall`_ is used to configure ``sysctl``

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
  
.. literalinclude:: host_vars/iocage_04/network.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/pf.yml
   :language: yaml
   :caption:
  
.. literalinclude:: host_vars/iocage_04/zfs.yml
   :language: yaml
   :caption:

Playbooks
^^^^^^^^^

.. literalinclude:: pb-network.yml
   :language: yaml

.. literalinclude:: pb-pf.yml
   :language: yaml

.. literalinclude:: pb-zfs.yml
   :language: yaml

Playbook output - configure ZFS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-zfs.yml -i iocage.ini

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

Playbook output
^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage-hosts.ini -l iocage_04

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:


.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network
.. _vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf
.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
