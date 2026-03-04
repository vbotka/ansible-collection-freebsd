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
  │   ├── iocage_02
  │   │   └── iocage.yml
  │   └── iocage_04
  │       └── iocage.yml
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* At the managed node ``iocage_04``
  
  In the playbook ``pb-iocage.yml``, use the role ``vbotka.freebsd.iocage`` to:

  * audit the `iocage`_ configuration.

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* root privilege in the managed nodes
* binary `iocage`_.

Notes
^^^^^

* Put ``-l iocage_02`` into the run-strings to run the play on the iocage host ``iocage_02``
* Remove the limits ``-l iocage_0*`` to run the play on all managed nodes.
* By default, sanity testing is enabled ``freebsd_iocage_sanity: true``

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
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_04/iocage.yml
   :language: yaml
   :caption:

.. note::

   By default, the activation testing is disabled ::

     freebsd_iocage_sanity_zfs_pool_active: false

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml

Playbook output - Test sanity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 \
                                          -t freebsd_iocage_sanity

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:

Playbook output - Test sanity quietly
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
           ANSIBLE_DISPLAY_SKIPPED_HOSTS=false \
           ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 \
                                          -t freebsd_iocage_sanity

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:

.. seealso::

   * `ANSIBLE_DISPLAY_OK_HOSTS`_
   * `ANSIBLE_DISPLAY_SKIPPED_HOSTS`_


.. _role vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/iocage/
.. _iocage: https://github.com/iocage/iocage/
.. _ANSIBLE_DISPLAY_OK_HOSTS: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _ANSIBLE_DISPLAY_SKIPPED_HOSTS: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
