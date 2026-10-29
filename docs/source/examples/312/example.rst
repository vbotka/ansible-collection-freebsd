.. _example_312:

312 Create haproxy user, group, and login class
-----------------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: postinstall; Example 312
   single: vbotka.freebsd.postinstall; Example 312
   single: role vbotka.freebsd.postinstall; Example 312
   single: module vbotka.freebsd.cgetent; Example 312
   single: vbotka.freebsd.cgetent; Example 312
   single: cgetent; Example 312

Use case
^^^^^^^^

Create ``haproxy`` user and group. Add ``haproxy`` class into the file
``/etc/login.conf``. Use the role `vbotka.freebsd.postinstall`_ and:ref:`module
vbotka.freebsd.cgetent <ug_module_cgetent>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── iocage
  │       └── haproxy.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Use the role `vbotka.freebsd.postinstall`_ and
    :ref:`module vbotka.freebsd.cgetent <ug_module_cgetent>` to:

    * Add ``haproxy`` group.
    * Add ``haproxy`` user.
    * Add ``haproxy`` login class.


Requirements
^^^^^^^^^^^^

* Role `vbotka.freebsd.postinstall`_
* :ref:`ug_module_cgetent`

Notes
^^^^^

* TBD.

.. note::

   | `vbotka.freebsd.postinstall`_ is the role **postinstall** in the `collection vbotka.freebsd`_.
   | `vbotka.freebsd_postinstall`_ is the role **freebsd_postinstall** in the namespace `vbotka`_.

.. seealso::

   * `Ansible role FreeBSD postinstall`_

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

.. literalinclude:: group_vars/iocage/haproxy.yml
   :language: yaml+jinja
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Create haproxy user, group, and login class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:
