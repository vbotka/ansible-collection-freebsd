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
.. index:: single: ZFS; Example 501
.. index:: single: role vbotka.freebsd.zfs; Example 501
.. index:: single: vbotka.freebsd.zfs; Example 501

.. index:: single: community.general.zfs; Example 501
.. index:: single: community.general.zfs_facts; Example 501
.. index:: single: community.general.zpool; Example 501
.. index:: single: community.general.zpool_facts; Example 501
.. index:: single: module community.general.zfs; Example 501
.. index:: single: module community.general.zfs_facts; Example 501
.. index:: single: module community.general.zpool; Example 501
.. index:: single: module community.general.zpool_facts; Example 501

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
  │       ├── loader.yml
  │       ├── network.yml
  │       ├── pf.yml
  │       └── zfs.yml
  ├── iocage.ini
  ├── pb-loader.yml
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

* The role `vbotka.freebsd.postinstall`_ is used to configure:

  * ``sysctl.conf``
  * ``loader.conf``

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
  
.. literalinclude:: host_vars/iocage_04/loader.yml
   :language: yaml
   :caption:
  
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

.. literalinclude:: pb-loader.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-network.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-pf.yml
   :language: yaml
   :caption:

.. literalinclude:: pb-zfs.yml
   :language: yaml
   :caption:

Playbooks' outputs
^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-04.txt
   :caption: (env) > ansible-playbook pb-loader.yml -i iocage.ini
   :language: yaml
   :force:

.. literalinclude:: out/out-01.txt
   :caption: (env) > ansible-playbook pb-network.yml -i iocage.ini
   :language: yaml
   :force:

.. literalinclude:: out/out-02.txt
   :caption: (env) > ansible-playbook pb-pf.yml -i iocage.ini
   :language: yaml
   :force:

.. literalinclude:: out/out-03.txt
   :caption: (env) > ansible-playbook pb-zfs.yml -i iocage.ini
   :language: yaml
   :force:


.. _vbotka.freebsd.network: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network
.. _vbotka.freebsd.pf: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/pf
.. _vbotka.freebsd.zfs: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs
.. _vbotka.freebsd.postinstall: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/postinstall
