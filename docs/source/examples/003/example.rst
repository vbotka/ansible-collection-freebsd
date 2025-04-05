.. _example_003:

003 Audit iocage host
---------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

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

  * Audit *iocage*

Requirements
^^^^^^^^^^^^

.. index:: single: role vbotka.freebsd.iocage; Example 003

* `role vbotka.freebsd.iocage`_
* root privilege on the *iocage* hosts
* `binary iocage`_ installed.

Notes
^^^^^

* Put ``-l iocage_01`` into the run-strings to run the play on the iocage host *iocage_01*
* Remove the limits ``-l iocage_0*`` to run the play on both iocage hosts.
* By default, *iocage* sanity is enabled ``freebsd_iocage_sanity: true``

.. seealso::

   * See the tasks *roles/iocage/tasks/sanity.yml*
   * See the default variables *roles/iocage/main/sanity.yml*


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

   By default, the activation testing is disabled ::

     freebsd_iocage_sanity_zfs_pool_active: false


Playbook *pb-iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
    :language: yaml

Playbook output - test sanity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash

Playbook output - test sanity quietly
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

.. seealso::

   * `ANSIBLE_DISPLAY_OK_HOSTS <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts>`_

   * `ANSIBLE_DISPLAY_SKIPPED_HOSTS <https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts>`_


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _binary iocage: https://github.com/iocage/iocage/
