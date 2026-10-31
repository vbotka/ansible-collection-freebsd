.. _ug_bp_connection_jailexec:

Connection jailexec
^^^^^^^^^^^^^^^^^^^

.. index::
   single: connection vbotka.freebsd.jailexec; Best practice - connection
   single: vbotka.freebsd.jailexec; Best practice - connection
   single: jailexec; Best practice - connection

Flow chart
""""""""""

.. code-block:: text

   +-----------------------+
   |  Ansible Controller   |
   +-----------------------+
               |
               | 1. Transport to host (SSH: admin@iocage_06)
               v
   +-------------------------------------------------------+
   | Jail Host (iocage_06)                                 |
   |                                                       |
   |   +-----------------------------------------------+   |
   |   | Privilege Escalation                          |   |
   |   |   sudo / doas jexec <JID_or_Name> <command>   |   |
   |   +-----------------------------------------------+   |
   |                           |                           |
   |                    Host Kernel (jexec)                |
   |                           |                           |
   |                           v                           |
   |   +-----------------------------------------------+   |
   |   | Target Jail (JID / Name)                      |   |
   |   |   - No SSH daemon required                    |   |
   |   |   - No forwarded ports / PF rules             |   |
   |   |   - Executes command directly in jail context |   |
   |   +-----------------------------------------------+   |
   +-------------------------------------------------------+

.. csv-table:: jailexec execution parameters
   :header: "Parameter", "Value / Source", "Description"
   :widths: 25, 30, 45

   "**Connection Plugin**", "``vbotka.freebsd.jailexec``", "Overrides default SSH transport"
   "**Jail Host**", "``ansible_jail_host`` (for example, ``iocage_06``)", "Parent system running the jail engine"
   "**Jail Target**", "``ansible_jail_name`` (for example, ``iocage_jid``)", "Numeric JID, UUID, or name passed to ``jexec``"
   "**Escalation Binary**", "``ansible_jail_privilege_escalation``", "Tool to execute ``jexec`` as root (for example, ``sudo``)"

When managing FreeBSD jails located on remote jail hosts, running an SSH daemon
inside every jail is not always desirable or necessary. The custom connection
plugin :ref:`connection vbotka.freebsd.jailexec <ug_connection_jailexec>`
allows Ansible to execute commands directly inside jails through the host system
via ``jexec(8)``.

Architecture and workflow
"""""""""""""""""""""""""

Instead of establishing an SSH connection directly into the jail network stack:

1. Ansible connects to the jail host using standard SSH (or another configured
   transport).
2. Commands and module payloads are delegated directly into the target jail
   using FreeBSD's native ``jexec`` utility on the host.
3. This eliminates the need for:

   * An active ``sshd`` service running inside each jail.
   * Jail-specific firewall rules or port redirection setups on the host.
   * Managing SSH authorized keys, host keys, and credentials inside each jail.

Dynamic inventory configuration
"""""""""""""""""""""""""""""""

As demonstrated in :ref:`example_442`, jails discovered by the
``vbotka.freebsd.iocage2`` inventory plugin can be configured dynamically to use
``jailexec`` using the ``ansible.builtin.constructed`` inventory plugin:

.. code-block:: yaml+jinja
   :caption: hosts/99_constructed.yml

   plugin: ansible.builtin.constructed
   strict: true
   compose:
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
     ansible_jail_name: iocage_jid
     ansible_jail_privilege_escalation: "'sudo'"

Configuration variables
"""""""""""""""""""""""

The plugin relies on the following composed host variables:

* **``ansible_connection``**: Set to ``vbotka.freebsd.jailexec`` to override the
  default SSH connection plugin.
* **``ansible_jail_host``**: Specifies the parent jail host. In the example
  above, this is parsed from the ``vmm`` attribute stored in the jail's
  ``iocage_properties.notes``.
* **``ansible_jail_name``**: The target jail identifier on the host. Using
  ``iocage_jid`` targets the jail by its numeric JID; the jail's UUID or name
  can also be used.
* **``ansible_jail_privilege_escalation``**: The command used to escalate
  privileges on the jail host to invoke ``jexec`` (typically ``sudo`` or
  ``doas``).

.. note::

   * The default privilege escalation tool for ``jailexec`` is ``doas``.
     Because FreeBSD does not include ``doas`` in base, set
     ``ansible_jail_privilege_escalation: "'sudo'"` when using ``sudo``.

Executing playbooks
"""""""""""""""""""

Once configured in the inventory, playbooks execute against the jails without any
special command-line flags or task modifications:

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

Ansible connects to the parent host, runs the tasks inside the jail via
``jexec``, and returns module results back to the controller.

.. seealso::

   * :ref:`example_442`
   * :ref:`ug_connection_jailexec`
   * :ref:`ug_inventory_iocage2`
   * :ref:`ug_bp_connection_ssh_rdr`
