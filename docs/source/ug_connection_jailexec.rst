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

Given the running jails:

.. code-block:: console

   shell> ssh admin@iocage_06 iocage list
   +-----+---------------+-------+--------------+--------------+
   | JID |     NAME      | STATE |   RELEASE    |     IP4      |
   +=====+===============+=======+==============+==============+
   | 1   | log-server-01 | up    | 15.1-RELEASE | 172.16.99.10 |
   +-----+---------------+-------+--------------+--------------+
   | 2   | pkg-repo      | up    | 15.1-RELEASE | 172.16.99.23 |
   +-----+---------------+-------+--------------+--------------+
   | 3   | repos         | up    | 15.1-RELEASE | 172.16.99.21 |
   +-----+---------------+-------+--------------+--------------+

Static Inventory
^^^^^^^^^^^^^^^^

The configuration stored in ``hosts.ini``:

.. code-block:: ini

   log-server-01 ansible_jail_name=1
   pkg-repo ansible_jail_name=2
   repos ansible_jail_name=3

   [vmm_iocage_06]
   log-server-01
   pkg-repo
   repos

   [vmm_iocage_06:vars]
   ansible_connection=vbotka.freebsd.jailexec
   ansible_ssh_user=admin
   ansible_jail_host=iocage_06
   ansible_jail_privilege_escalation=sudo

creates the following inventory:

.. code-block:: console

   shell> ansible-inventory -i hosts.ini --graph
   @all:
     |--@ungrouped:
     |--@vmm_iocage_06:
     |  |--log-server-01
     |  |--pkg-repo
     |  |--repos

Dynamic Inventory
^^^^^^^^^^^^^^^^^

When used with the inventory plugin ``vbotka.freebsd.iocage2``, the connection
variables ``ansible_jail_host`` and ``ansible_jail_name`` are dynamically
composed in ``hosts.iocage2.yml``:

.. code-block:: yaml+jinja
   :emphasize-lines: 10-11

   plugin: vbotka.freebsd.iocage2
   host: iocage_06
   user: admin
   get_properties: true

   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)'))
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_ssh_user: "'admin'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm | d('none')
     ansible_jail_name: iocage_jid
     ansible_jail_privilege_escalation: "'sudo'"

   keyed_groups:
     - prefix: vmm
       key: iocage_tags.vmm

This creates the corresponding inventory:

.. code-block:: console

   shell> ansible-inventory -i hosts.iocage2.yml --graph
   @all:
     |--@ungrouped:
     |--@vmm_iocage_06:
     |  |--pkg-repo
     |  |--log-server-01
     |  |--repos

.. note::

   The iocage tag ``vmm`` is used to define ``ansible_jail_host``. For example,
   inspecting the jail notes shows:

   .. code-block:: console

      shell> ssh admin@iocage_06 iocage get notes repos
      vmm=iocage_06 class=repos

Host-Level Options
~~~~~~~~~~~~~~~~~~

Because ``jexec`` is invoked via ``ansible_jail_privilege_escalation``, the
account defined in ``ansible_ssh_user`` requires elevated privileges on the jail
host.

Depending on host management policies, configure sudo permissions in
``/usr/local/etc/sudoers.d/admin``:

* **Host managed by Ansible (recommended):** If the FreeBSD host itself is
  already managed via Ansible, grant full passwordless privilege escalation:

  .. code-block:: text

     shell> cat /usr/local/etc/sudoers.d/admin
     admin ALL=(ALL) NOPASSWD: ALL

* **Host unmanaged / restricted:** If you prefer least-privilege access
  restricted solely to jail execution, limit the rule to the ``jexec`` binary:

  .. code-block:: text

     shell> cat /usr/local/etc/sudoers.d/admin
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
