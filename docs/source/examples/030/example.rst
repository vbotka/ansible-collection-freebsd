.. _example_030:

030 Create custom facts
-----------------------

Extending :ref:`example_020`.

.. contents::
   :local:
   :depth: 1

.. index:: single: custom facts; Example 030
.. index:: single: filter vbotka.freebsd.iocage; Example 030
.. index:: single: role vbotka.freebsd.iocage; Example 030

Use case
^^^^^^^^

Create custom facts to provide a dictionary of iocage dataset
lists. Use the :ref:`ug_filter_iocage` to parse them.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  ├── pb-iocage.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On two managed nodes:

  * iocage_02
  * iocage_04

  In the playbook ``pb-iocage.yml``, use the `role
  vbotka.freebsd.iocage`_ to:

  * Create custom fact scripts

  In the playbook ``pb-test.yml``:

  * Get the custom facts
  * Use the :ref:`ug_filter_iocage` to parse the custom facts
  * Create the inventory group ``test`` and compose variables
  * Display the hosts and composed variables in the group ``test``
  * Display all groups

Requirements
^^^^^^^^^^^^

* `role vbotka.freebsd.iocage`_
* :ref:`ug_filter_iocage`
* Root privileges on the managed nodes
* Jails created in previous examples

Notes
^^^^^

* See `Adding custom facts`_.

Jails at iocage_02
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Jails at iocage_04
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_04]# iocage list -l

.. literalinclude:: out/out-02.txt
   :language: bash

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-iocage.yml
^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage.yml
   :language: yaml+jinja

Playbook output - Display versions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_debug \
                            -e freebsd_iocage_debug=true \
                            pb-iocage.yml \
           | grep version

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja

Playbook output - Create custom fact scripts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t freebsd_iocage_facts \
                            -e freebsd_iocage_facts=true \
                            pb-iocage.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Display custom fact script
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# cat /etc/ansible/facts.d/iocage.fact

.. literalinclude:: out/out-05.txt
   :language: python

.. hint::

   Install ``lang/python``:

   "This is a meta port to the Python interpreter and provides
   symbolic links to bin/python, bin/pydoc, bin/idle and so on to allow
   compatibility with version agnostic python scripts."

   -- FreeBSD Ports Description (lang/python)

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display custom facts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:
