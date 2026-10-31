.. _example_442:

442 Connection jailexec instead of SSH
--------------------------------------

This example extends :ref:`example_441`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: jailexec; Example 442
   single: vbotka.freebsd.jailexec; Example 442
   single: connection vbotka.freebsd.jailexec; Example 442
   single: option compose; Example 442
   single: compose; Example 442
   single: variable iocage_tags; Example 442
   single: iocage_tags; Example 442

Use case
^^^^^^^^

Use :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>` instead
of the default `ansible.builtin.ssh`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * Create a dynamic inventory to connect to the jails via
    :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>`.

* On the created jails, in the playbook ``pb-test.yml``:

  * Display the configuration variables.
  * Test the connection to the jails.

Requirements
^^^^^^^^^^^^

* :ref:`ug_inventory_iocage2`
* :ref:`ug_connection_jailexec`
* Root privileges on the managed nodes.

Notes
^^^^^

* The only difference between this example and :ref:`example_441` is the
  following four lines in the inventory configuration file:

.. code-block:: yaml+jinja

   ansible_connection: "'vbotka.freebsd.jailexec'"
   ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
   ansible_jail_name: iocage_jid
   ansible_jail_privilege_escalation: "'sudo'"

.. seealso::

   Example :ref:`example_050`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-8

.. note::

   * The default for ``ansible_jail_privilege_escalation`` is ``doas``.

   * In FreeBSD, ``doas`` is not installed by default.

   * See :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>`

Graph
^^^^^

.. literalinclude:: out/out-01.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Test jailexec
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:
