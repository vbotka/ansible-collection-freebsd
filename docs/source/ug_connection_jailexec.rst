.. _ug_connection_jailexec:

.. index:: single: connection vbotka.freebsd.jailexec; Plugins

connection vbotka.freebsd.jailexec
----------------------------------

The connection plugin ``vbotka.freebsd.jailexec`` connects to FreeBSD jails
without requiring SSH inside the jail. It uses the host-level ``jexec`` utility
to execute commands within target jails.

Execution Architecture
~~~~~~~~~~~~~~~~~~~~~~

When a task executes against a host configured with ``vbotka.freebsd.jailexec``,
the plugin performs the following pipeline:

1. Opens a transport connection (typically SSH) to the physical host specified
   by ``ansible_jail_host`` using ``ansible_ssh_user``.

2. Applies the privilege escalation wrapper specified by
   ``ansible_jail_privilege_escalation`` (such as ``sudo`` or ``doas``), since
   invoking ``jexec(8)`` requires root privileges on the FreeBSD host.

3. Spawns the command inside the jail identified by ``ansible_jail_name`` using
   ``jexec [-u <jail_user>] <jid_or_name> <command>``.

4. Transfers files and temporary script modules to and from the jail using
   host-level filesystem paths or piped streams.

Configuration Options
~~~~~~~~~~~~~~~~~~~~~

The plugin options can be set via inventory variables, group variables, host
variables, or dynamically via inventory plugins.

.. list-table::
   :header-rows: 1
   :widths: 30 20 15 35

   * - Variable
     - Type
     - Default
     - Description
   * - ``ansible_connection``
     - string
     - (required)
     - Must be set to ``vbotka.freebsd.jailexec``.
   * - ``ansible_jail_host``
     - string
     - ``localhost``
     - Hostname or IP of the FreeBSD host running the jail. If set to ``localhost``, commands run locally on the host.
   * - ``ansible_jail_name``
     - string / integer
     - ``inventory_hostname``
     - Name or numeric JID (Jail ID) of the target jail.
   * - ``ansible_jail_privilege_escalation``
     - string
     - ``none``
     - Privilege escalation command used on the host to execute ``jexec`` (e.g., ``sudo``, ``doas``).
   * - ``ansible_jail_user``
     - string
     - ``root``
     - User account inside the jail used to execute the commands.
   * - ``ansible_ssh_user``
     - string
     - current user
     - User account for the initial SSH connection to ``ansible_jail_host``.

Usage Examples
~~~~~~~~~~~~~~

Static Inventory Example (host_vars)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To manage a jail named ``web_prod`` running on a remote host ``freebsd-node-01``:

.. code-block:: yaml

   # host_vars/web_prod.yml
   ansible_connection: vbotka.freebsd.jailexec
   ansible_jail_host: freebsd-node-01.example.org
   ansible_ssh_user: admin
   ansible_jail_privilege_escalation: sudo
   ansible_jail_name: web_prod
   ansible_jail_user: root
   ansible_python_interpreter: /usr/local/bin/python3

Dynamic Inventory Example (vbotka.freebsd.iocage2)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When paired with ``vbotka.freebsd.iocage2``, the connection variables are
composed automatically from the metadata and running state of each iocage jail:

.. code-block:: yaml+jinja
   :emphasize-lines: 12-16

   plugin: vbotka.freebsd.iocage2
   host: iocage_06
   user: admin
   sudo: true
   get_properties: true
   inventory_hostname_tag: alias

   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
     iocage_classes: iocage_properties.notes | regex_findall('(?<=class=)[\w\-]+|(?<=,)[\w\-]+')
     # connection plugin vbotka.freebsd.jailexec
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_ssh_user: "'admin'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
     ansible_jail_name: iocage_jid
     ansible_jail_privilege_escalation: "'sudo'"
     # ansible options
     ansible_python_interpreter: "'auto_silent'"

   groups:
     log_servers: iocage_classes is contains('log-server')
     log_clients: iocage_classes is contains('log-client')

   keyed_groups:
     - prefix: state
       key: iocage_state
     - prefix: vmm
       key: iocage_tags.vmm

Host-Level Prerequisites
~~~~~~~~~~~~~~~~~~~~~~~~

Because ``jexec`` is invoked via ``ansible_jail_privilege_escalation``, the
account defined in ``ansible_ssh_user`` requires elevated privileges on the jail
host.

Depending on host management policies, configure sudo permissions in
``/usr/local/etc/sudoers.d/admin``:

* **Host managed by Ansible (recommended):** If the FreeBSD host itself is
  already managed via Ansible, grant full passwordless privilege escalation:

  .. code-block:: text

     # cat /usr/local/etc/sudoers.d/admin
     admin ALL=(ALL) NOPASSWD: ALL

* **Host unmanaged / restricted:** If you prefer least-privilege access
  restricted solely to jail execution, limit the rule to the ``jexec`` binary:

  .. code-block:: text

     # cat /usr/local/etc/sudoers.d/admin
     admin ALL=(ALL) NOPASSWD: /usr/sbin/jexec

.. glossary::

   ``ansible_ssh_user``
     User account for SSH login to the jail host.

   ``ansible_jail_host``
     FreeBSD host running the target jails.

   ``ansible_jail_name``
     JID or name of the jail to connect to. When using dynamic inventories,
     passing ``iocage_jid`` ensures operations target the currently active
     runtime instance.

   ``ansible_jail_privilege_escalation``
     Privilege escalation method used on the host to execute ``jexec`` (for
     example, ``sudo`` or ``doas``).

   ``ansible_jail_user``
     The user account inside the target jail that executes the module or command.

.. note::

   See :ref:`ag_setup_plugins`.

.. seealso::

   * `man jexec`_
   * `man jail`_

.. _man jexec: https://man.freebsd.org/cgi/man.cgi?query=jexec&sektion=8
.. _man jail: https://man.freebsd.org/cgi/man.cgi?query=jail&sektion=8
