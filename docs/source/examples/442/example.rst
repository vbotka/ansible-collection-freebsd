.. _example_442:

442 Connection jailexec instead of ssh
--------------------------------------

| Extending example :ref:`example_441`.

.. contents::
   :local:
   :depth: 1

.. index:: single: jailexec; Example 442
.. index:: single: vbotka.freebsd.jailexec; Example 442
.. index:: single: connection vbotka.freebsd.jailexec; Example 442

.. index:: single: option compose; Example 442
.. index:: single: compose; Example 442

.. index:: single: variable iocage_tags; Example 442
.. index:: single: iocage_tags; Example 442

Use case
^^^^^^^^

Use the :ref:`ug_connection_jailexec` instead of the default ``ansible.builtin.ssh``.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 06_iocage.yml
  │   └── 99_constructed.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* Create dynamic inventory to connect the jails by :ref:`ug_connection_jailexec`

* At all created jails, in the playbook ``pb-test.yml``:

  * connect to the jails
  * display basic configuration of the jails.

Requirements
^^^^^^^^^^^^

* :ref:`ug_connection_jailexec`
* `inventory plugin vbotka.freebsd.iocage2`_
* root privilege in the managed nodes

Notes
^^^^^

The only difference between this example and the example :ref:`example_441` are
the following three lines in the inventory configuration file

.. code-block:: yaml

   ansible_connection: "'vbotka.freebsd.jailexec'"
   ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none'
   ansible_jail_privilege_escalation: "'sudo'"

.. seealso::

   example :ref:`example_050`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Jails at iocage_06
^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_06]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml
   :caption:
   :emphasize-lines: 7-9

.. note::

   * The default value of the option ``ansible_jail_privilege_escalation`` is ``doas``
   * See :ref:`ug_connection_jailexec`
   * In FreeBSD, ``doas`` is not installed by default.
		  
.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-02.txt
   :language: bash

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml

Playbook output - Test jailexec connection plugin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-test.yml -i hosts

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:


.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2/
