.. _example_301:

301 Module vbotka.freebsd.ucl
-----------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: module vbotka.freebsd.ucl; Example 301
.. index:: single: vbotka.freebsd.ucl; Example 301
.. index:: single: uclcmd; Example 301
.. index:: single: UCL (Universal Configuration Language); Example 301

Use case
^^^^^^^^

Test the :ref:`ug_module_ucl`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  ├── pb-test-01.yml
  └── pb-test-02.yml

Synopsis
^^^^^^^^

On a managed node:

* Playbook ``pb-test-01.yml``: Get ``FreeBSD.url`` from ``/etc/pkg/FreeBSD.conf``.
* Playbook ``pb-test-02.yml``: Update ``FreeBSD.enabled`` in ``/etc/pkg/FreeBSD.conf``.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_ucl`
* Installed `uclcmd`_

Notes
^^^^^

* TBD

.. seealso::

   * `uclcmd Command line tool for working with UCL config files`_
   * `UCL (Universal Configuration Language)`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-test-01.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-01.yml
   :language: yaml+jinja

Playbook output - Get FreeBSD.url
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test-01.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:

Playbook pb-test-02.yml
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test-02.yml
   :language: yaml+jinja

Playbook output - Disable FreeBSD repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini --check --diff pb-test-02.yml

.. literalinclude:: out/out-02.txt
   :language: yaml+jinja
   :force:
