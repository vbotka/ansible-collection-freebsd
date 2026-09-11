.. _example_003:

003 Audit iocage host
---------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.iocage; Example 003
.. index:: single: iocage audit; Example 003
.. index:: single: audit iocage; Example 003

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to audit the `iocage`_ configuration.

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

  In the playbook ``pb-iocage.yml``, use the `role vbotka.freebsd.iocage`_ to:

  * Audit the `iocage`_ configuration

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* Root privileges on the managed nodes
* The `iocage`_ binary

Notes
^^^^^

* Put ``-l iocage_02`` into the command arguments to run the play on the iocage host ``iocage_02``.
* Remove the limits ``-l iocage_0*`` to run the play on all managed nodes.
* By default, sanity testing is enabled: ``freebsd_iocage_sanity: true``.

.. seealso::

   * :ref:`example_501`
   * The tasks ``roles/iocage/tasks/sanity.yml``
   * The default variables ``roles/iocage/main/sanity.yml``

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

   By default, activation testing is disabled::

     freebsd_iocage_sanity_zfs_pool_active: false

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Test sanity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini -l iocage_04 \
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
           ansible-playbook -i iocage.ini -l iocage_04 \
                            -t freebsd_iocage_sanity \
			     pb-iocage.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. seealso::

   * `ANSIBLE_DISPLAY_OK_HOSTS`_
   * `ANSIBLE_DISPLAY_SKIPPED_HOSTS`_
