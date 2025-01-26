.. _example_002:

002 Activate iocage
-------------------

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree
   .
   ├── ansible.cfg
   ├── host_vars
   │   ├── iocage_01
   │   │   └── iocage.yml
   │   └── iocage_02
   │       └── iocage.yml
   ├── iocage-hosts.ini
   └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the iocage host *iocage_02*
  
  In the playbook *pb-iocage.yml*, use the role *vbotka.freebsd.iocage* to:

  * activate *iocage*

Requirements
^^^^^^^^^^^^

.. index:: single: role vbotka.freebsd.iocage; Example 002

* `role vbotka.freebsd.iocage`_
* root privilege on the *iocage* hosts
* Binary *iocage*

Notes
^^^^^

* Put ``-l iocage_01`` into the run-strings to run the play on the iocage host *iocage_01*
* Remove the limits ``-l iocage_0*`` to run the play on both iocage hosts.
* By default, *iocage* activation is disabled ``freebsd_iocage_activate: false``

.. seealso::

   * `Activate iocage <https://iocage.readthedocs.io/en/latest/basic-use.html#activate-iocage>`_

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars/iocage_01/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

.. note::

   * The activation will be skipped if the directory *freebsd_iocage_mount* exists.

   * The variable *freebsd_iocage_mount* is declared in *defaults/main/main.yml* ::

       freebsd_iocage_mount: "{{ freebsd_iocage_pool_mount }}/iocage"


Playbook *pb-iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
    :language: yaml

Playbook output - display debug
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

.. note:: This *debug* shows the *result* of already activated *iocage*.

.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
