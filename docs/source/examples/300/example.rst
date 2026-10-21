.. _example_300:

300 Module vbotka.freebsd.service
---------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: module vbotka.freebsd.service; Example 300
   single: vbotka.freebsd.service; Example 300
   single: module community.general.ini; Example 300
   single: community.general.ini; Example 300

Use case
^^^^^^^^

Test the :ref:`module vbotka.freebsd.service <ug_module_service>`.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook ``pb-test.yml``, display:

    * ``sshd`` rcvar.
    * ``sshd`` status.
    * ``sshd`` synopsis.
    * Enabled services.

Requirements
^^^^^^^^^^^^

* :ref:`ug_module_service`

Notes
^^^^^

* TBD

.. seealso::

   * `man service`_

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Test module service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini pb-test.yml

.. literalinclude:: out/out-01.txt
   :language: yaml+jinja
   :force:
