.. _example_002:

002 Activate iocage
-------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: role vbotka.freebsd.iocage; Example 002
   single: iocage activate; Example 002
   single: activate iocage; Example 002

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to activate `iocage`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Use the playbook ``pb-iocage.yml`` and the `role vbotka.freebsd.iocage`_ to
    activate `iocage`_.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.iocage`_
* The `iocage`_ binary.
* Root privileges on the managed nodes.

Notes
^^^^^

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

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   * Activation is skipped if the directory ``freebsd_iocage_mount`` exists.

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

   (env) > ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_activate \
                            -e freebsd_iocage_activate=true \
                            -e freebsd_iocage_debug=true \
                            pb-iocage.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

.. note::

   This debug output shows the result of an already activated `iocage`_.
