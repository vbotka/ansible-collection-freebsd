.. _example_002:

002 Activate iocage
-------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.iocage; Example 002
.. index:: single: iocage activate; Example 002

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to activate `iocage`_.

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
  
  In the playbook *pb-iocage.yml*, use the `role vbotka.freebsd.iocage`_ to:

  * activate `iocage`_.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* root privilege on the *iocage* hosts
* binary `iocage`_.

Notes
^^^^^

* Put ``-l iocage_01`` into the run-strings to run the play on the iocage host *iocage_01*
* Remove the limits ``-l iocage_0*`` to run the play on both iocage hosts.
* By default, *iocage* activation is disabled ``freebsd_iocage_activate: false``

.. seealso::

   * `Activate iocage`_

Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
   :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

.. note::

   * The activation will be skipped if the directory *freebsd_iocage_mount* exists.
   * The variable *freebsd_iocage_mount* is declared in *defaults/main/main.yml* ::

       freebsd_iocage_mount: "{{ freebsd_iocage_pool_mount }}/iocage"


Playbook *pb-iocage.yml*
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml

Playbook output - display result
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   (env) > ansible-playbook pb-iocage.yml -i iocage-hosts.ini \
                                          -l iocage_02 \
                                          -t freebsd_iocage_activate \
                                          -e freebsd_iocage_activate=true \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml

.. note:: This *debug* shows the *result* of already activated *iocage*.


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _iocage: https://iocage.readthedocs.io/en/latest/index.html
.. _iocage - A FreeBSD Jail Manager: https://iocage.readthedocs.io/en/latest/index.html
.. _Activate iocage: https://iocage.readthedocs.io/en/latest/basic-use.html#activate-iocage
