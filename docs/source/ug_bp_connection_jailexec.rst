.. _ug_bp_connection_jailexec:

Connection jailexec
^^^^^^^^^^^^^^^^^^^

.. index::
   single: connection vbotka.freebsd.jailexec; Best practice - connection
   single: vbotka.freebsd.jailexec; Best practice - connection
   single: jailexec; Best practice - connection

When managing FreeBSD jails located on remote jail hosts, running an SSH daemon
inside every jail is not always desirable or necessary. The custom connection
plugin :ref:`vbotka.freebsd.jailexec <ug_connection_jailexec>`
allows Ansible to execute commands directly inside jails through the host system
via ``jexec(8)``.

.. code-block:: text
   :caption: Connection plugin vbotka.freebsd.jailexec

   +-----------------------+
   |  Ansible Controller   |
   +-----------------------+
               |
               | Transport to host (SSH: admin@iocage_06)
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
   |   | Jail (JID / Name)                             |   |
   |   |   - No SSH daemon required                    |   |
   |   |   - No forwarded ports / PF rules             |   |
   |   |   - Executes command directly in jail context |   |
   |   +-----------------------------------------------+   |
   +-------------------------------------------------------+

.. csv-table:: Connection plugin vbotka.freebsd.jailexec options
   :header: "", "Option", "Description"
   :widths: 25, 30, 45

   "**Connection Plugin**", "``vbotka.freebsd.jailexec``", "Overrides default SSH transport"
   "**Jail Host**", "``ansible_jail_host`` (e.g., ``iocage_06``)", "Parent system running the jail"
   "**Jail**", "``ansible_jail_name`` (e.g., ``iocage_jid``)", "JID, UUID, or NAME"
   "**Escalation Binary**", "``ansible_jail_privilege_escalation``", "Tool to execute ``jexec`` as root (e.g., ``sudo``)"

.. important::

   See :ref:`ug_qa_jexec_iocage_name`

Architecture and workflow
"""""""""""""""""""""""""

Instead of establishing an SSH connection directly into the jail:

1. Ansible connects to the jail host using standard SSH (or another configured
   transport).

2. Commands and module payloads are delegated directly into the target jail
   using FreeBSD's native `jexec`_ utility on the host.

3. This eliminates the need for:

   * An active ``sshd`` service running inside each jail.
   * Jail-specific firewall rules or port redirection setups on the host.
   * Managing SSH authorized keys, host keys, and credentials inside each jail.

Dynamic inventory configuration
"""""""""""""""""""""""""""""""

As demonstrated in :ref:`example_442`, jails discovered by the
:ref:`vbotka.freebsd.iocage2 <ug_inventory_iocage2>` inventory plugin, can be
configured dynamically to use :ref:`vbotka.freebsd.jailexec
<ug_connection_jailexec>` connection plugin using the
`ansible.builtin.constructed`_ inventory plugin:

.. code-block:: yaml+jinja
   :caption: hosts/99_constructed.yml

   plugin: ansible.builtin.constructed
   compose:
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm
     ansible_jail_name: iocage_jid
     ansible_jail_privilege_escalation: "'sudo'"

The connection is configured by the following composed host variables:

* **ansible_connection**: Set to :ref:`vbotka.freebsd.jailexec <ug_connection_jailexec>`
  to override the default `ansible.builtin.ssh`_ connection plugin.

* **ansible_jail_host**: Specifies the parent jail host. In the example above, this is parsed
  from the ``vmm`` attribute stored in the jail `iocage properties`_ notes (see `iocage notes`_).

* **ansible_jail_name**: The target jail identifier on the host. Using
  ``iocage_jid`` targets the jail by its ``JID``.

* **ansible_jail_privilege_escalation**: The command used to escalate privileges
  on the jail host to invoke `jexec`_, typically ``sudo`` or ``doas`` (default).

Executing playbooks
"""""""""""""""""""

Once configured in the inventory, playbooks execute against the jails without any
special command-line flags or task modifications:

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

Ansible connects to the parent host, runs the tasks inside the jail via
`jexec`_, and returns module results back to the controller.

.. seealso::

   * :ref:`example_442`
   * :ref:`ug_connection_jailexec`
   * :ref:`ug_inventory_iocage2`
   * :ref:`ug_bp_connection_ssh_rdr`
