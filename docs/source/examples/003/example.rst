.. _example_003:

003 Audit iocage host
---------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: role vbotka.freebsd.iocage; Example 003
   single: iocage audit; Example 003
   single: audit iocage; Example 003

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to audit the `iocage`_ configuration.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── iocage.yml
  ├── host_vars
  │   ├── iocage_05
  │   │   └── iocage.yml
  │   └── iocage_06
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* On a managed node, use the playbook ``pb-iocage.yml`` and the `role
  vbotka.freebsd.iocage`_ to audit the `iocage`_ configuration.

Requirements
^^^^^^^^^^^^

* `Role vbotka.freebsd.iocage`_
* Root privileges on the managed nodes.
* The `iocage`_ binary.

Notes
^^^^^

* By default, sanity testing is enabled: ``freebsd_iocage_sanity: true``.

.. important::

   See :ref:`example_501` for how to configure an iocage host.

.. seealso::

   * The tasks ``roles/iocage/tasks/sanity.yml``
   * The default variables ``roles/iocage/defaults/main/sanity.yml``

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml+jinja
   :caption:

.. note::

   By default, activation testing is disabled::

     freebsd_iocage_sanity_zfs_pool_active: false

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_05/iocage.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: host_vars/iocage_06/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Test sanity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_sanity \
                            pb-iocage.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook output - Test sanity quietly
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
           ANSIBLE_DISPLAY_SKIPPED_HOSTS=false \
           ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_sanity \
                            pb-iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. seealso::

   * `ANSIBLE_DISPLAY_OK_HOSTS`_
   * `ANSIBLE_DISPLAY_SKIPPED_HOSTS`_