.. _example_002:

002 Activate iocage
-------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.iocage; Example 002
.. index:: single: iocage activate; Example 002
.. index:: single: activate iocage; Example 002

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
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the managed node ``iocage_04``:

  In the playbook ``pb-iocage.yml``, use the `role
  vbotka.freebsd.iocage`_ to:

  * Activate `iocage`_

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* Root privileges on the managed nodes
* The `iocage`_ binary

Notes
^^^^^

* Put ``-l iocage_02`` into the command arguments to run the play on
  the managed node ``iocage_02``.

* Remove the limits ``-l iocage_0*`` to run the play on all managed
  nodes.

* By default, ``iocage`` activation is disabled:
  ``freebsd_iocage_activate: false``.

.. seealso::

   * `Activate iocage`_

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

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   * Activation will be skipped if the directory
     ``freebsd_iocage_mount`` exists.

   * The variable ``freebsd_iocage_mount`` is declared in
     ``defaults/main/main.yml``::

       freebsd_iocage_mount: "{{ freebsd_iocage_pool_mount }}/iocage"

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Activate iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 \
                                          -t freebsd_iocage_activate \
                                          -e freebsd_iocage_activate=true \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

.. note::

   This ``debug`` output shows the ``result`` of an already activated `iocage`_.
