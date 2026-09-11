.. _example_001:

001 Install iocage
------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.iocage; Example 001
.. index:: single: iocage install; Example 001

Use case
^^^^^^^^

Use the `role vbotka.freebsd.iocage`_ to install the `iocage`_ package.

Tree
^^^^

::

  shell> tree
  .
  ├── ansible.cfg
  ├── iocage.ini
  └── pb-iocage.yml

Synopsis
^^^^^^^^

* On the managed node ``iocage_04``:

  In the playbook ``pb-iocage.yml``, use the `role
  vbotka.freebsd.iocage`_ to:

  * Display variables
  * Install the `iocage`_ package

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* Root privileges on the managed nodes

Notes
^^^^^

* Put ``-l iocage_02`` into the command arguments to limit the play to
  the managed node ``iocage_02``.

* Remove the limits ``-l iocage_0*`` to run the play on all managed
  nodes.

* By default, ``iocage`` installation is enabled:
  ``freebsd_iocage_install: true``.

* By default, ``debug`` is disabled: ``freebsd_iocage_debug: false``.

.. seealso::

   * `Patterns. Targeting hosts and groups.`_
   * `Variable precedence. Where should I put a variable?`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

.. seealso::

   * `How to build your inventory`_
   * `Connection methods and details`_
   * `Understanding privilege escalation`_
   * `Setting the Python interpreter`_

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

.. seealso::

   `Ansible playbooks`_

Playbook output - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 \
                                          -t freebsd_iocage_debug \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

.. seealso::

   * `ansible-playbook`_

Playbook output - Install iocage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-iocage.yml -i iocage.ini -l iocage_04 \
                                          -t freebsd_iocage_pkg \
                                          -e freebsd_iocage_debug=true

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:

.. note::

   This ``debug`` output shows the ``result`` of an already installed package.
