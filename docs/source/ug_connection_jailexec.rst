.. _ug_connection_jailexec:

.. index:: single: connection vbotka.freebsd.jailexec; connection jailexec
.. index:: single: vbotka.freebsd.jailexec; connection jailexec
.. index:: single: jailexec; connection jailexec
.. index:: single: ansible_connection; connection jailexec
.. index:: single: ansible_jail_host; connection jailexec
.. index:: single: ansible_jail_name; connection jailexec
.. index:: single: ansible_jail_privilege_escalation; connection jailexec
.. index:: single: ansible_jail_user; connection jailexec
.. index:: single: ansible_ssh_user; connection jailexec
.. index:: single: option ansible_connection; connection jailexec
.. index:: single: option ansible_jail_host; connection jailexec
.. index:: single: option ansible_jail_name; connection jailexec
.. index:: single: option ansible_jail_privilege_escalation; connection jailexec
.. index:: single: option ansible_jail_user; connection jailexec
.. index:: single: option ansible_ssh_user; connection jailexec

connection vbotka.freebsd.jailexec
----------------------------------

The connection plugin ``vbotka.freebsd.jailexec`` connects to FreeBSD jails
without requiring SSH inside the jail. It uses the host-level ``jexec`` utility
to execute commands within target jails.

Execution Architecture
~~~~~~~~~~~~~~~~~~~~~~

When a task executes against a host configured with ``vbotka.freebsd.jailexec``,
the plugin performs the following pipeline:

1. Opens a transport connection (typically SSH) to the jail host specified by
   ``ansible_jail_host`` using ``ansible_ssh_user``.

2. Applies the privilege escalation specified by
   ``ansible_jail_privilege_escalation`` (such as ``sudo`` or ``doas``), since
   invoking ``jexec(8)`` requires root privileges on the FreeBSD host.

3. Spawns the command inside the jail identified by ``ansible_jail_name`` using
   ``jexec [-u <jail_user>] <jid_or_name> <command>``.

4. Transfers files and temporary script modules to and from the jail.

Configuration Options
~~~~~~~~~~~~~~~~~~~~~

The four plugin options can be set via ``ansible_jail_*`` variables. The
variable ``ansible_ssh_user`` is an option for the `ansible.builtin.ssh`_
connection plugin.

.. list-table::
   :header-rows: 1
   :widths: 30 15 20 35

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
     - (required)
     - Hostname or IP of the FreeBSD host running the jail.

   * - ``ansible_jail_name``
     - string
     - ``inventory_hostname``
     - Target jail name or numeric JID (Jail ID). Overrides
       ``inventory_hostname``.

   * - ``ansible_jail_privilege_escalation``
     - string
     - ``doas``
     - Host-level wrapper to invoke ``jexec`` as root. Choices: ``doas``,
       ``sudo``, ``none``.

   * - ``ansible_jail_user``
     - string
     - ``root``
     - Target user inside the jail (resolved via ``jexec -U`` against the jail's
       user database).

   * - ``ansible_ssh_user``
     - string
     - (inherited)
     - User account for SSH login to ``ansible_jail_host`` (inherited from
       Ansible's built-in SSH connection plugin).

.. note::

   * **Jail Identification:** The plugin defaults ``ansible_jail_name`` to
     ``inventory_hostname`` if unset. However, ``jexec(8)`` requires a numeric
     Jail ID (``JID``) or a native FreeBSD jail name. Frameworks like
     ``iocage`` maintain internal aliases that might not match the system jail
     name known to the FreeBSD kernel. When managing ``iocage`` environments,
     explicitly set ``ansible_jail_name: iocage_jid``.

   * **Host vs. Jail Escalation:** ``ansible_jail_privilege_escalation``
     (``doas`` or ``sudo``) executes on the **jail host**, not inside the jail.
     Neither tool is needed inside the jail itself for privilege escalation;
     the plugin invokes ``jexec -U <ansible_jail_user>`` directly from the host
     as root. Set this to ``none`` if connecting to the jail host directly as
     ``root``.

   * **Inherited SSH Options:** Because ``jailexec`` subclasses the built-in
     ``ssh`` plugin, all standard SSH connection variables (such as
     ``ansible_ssh_user``, ``ansible_ssh_private_key_file``,
     ``ansible_ssh_common_args``, and ``ansible_port``) apply to the connection
     established with ``ansible_jail_host``.

.. seealso::

   :ref:`ug_qa_jexec_iocage_name`

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

   log_server_01 ansible_jail_name=1
   pkg_repo ansible_jail_name=2
   repos ansible_jail_name=3

   [vmm_iocage_06]
   log_server_01
   pkg_repo
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
     |  |--log_server_01
     |  |--pkg_repo
     |  |--repos

.. note::

   ``jexec`` does not work with iocage jail names. If you use the ``NAME``
   instead of the ``JID`` in ``hosts.ini``:

   .. code-block:: ini

      log_server_01 ansible_jail_name=log-server-01
      pkg_repo ansible_jail_name=pkg-repo
      repos ansible_jail_name=repos

   the inventory remains valid, but the playbook below will fail.

Dynamic Inventory
^^^^^^^^^^^^^^^^^

When used with the inventory plugin ``vbotka.freebsd.iocage2``, the connection
variables ``ansible_jail_host`` and ``ansible_jail_name`` are dynamically
composed in ``hosts.iocage2.yml``:

.. code-block:: yaml+jinja
   :emphasize-lines: 11-12

   plugin: vbotka.freebsd.iocage2
   host: iocage_06
   user: admin
   get_properties: true
   inventory_hostname_tag: alias

   compose:
     iocage_tags: dict(iocage_properties.notes | regex_findall('(\\w+)=([\\w\\-]+)'))
     ansible_connection: "'vbotka.freebsd.jailexec'"
     ansible_ssh_user: "'admin'"
     ansible_jail_host: dict(iocage_properties.notes | regex_findall('(\\w+)=([\\w\\-]+)')).vmm | d('none')
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
     |  |--pkg_repo
     |  |--log_server_01
     |  |--repos

.. note::

   The iocage tag ``vmm`` is used to define ``ansible_jail_host``, and the tag
   ``alias`` is used to define `inventory_hostname`_. For example, inspecting
   the jail notes shows:

   .. code-block:: console

      shell> ssh admin@iocage_06 iocage get notes log-server-01
      vmm=iocage_06 class=log-server alias=log_server_01

Playbook
^^^^^^^^

The playbook ``pb-test-connection.yml``:

.. code-block:: yaml+jinja

   - name: Test connection and get hostname
     hosts: all
     tasks:
       - command: hostname
         register:
           hostname: _task.result.stdout

       - debug:
           var: hostname

works with both inventory sources:

.. code-block:: console

   shell> ansible-playbook -i hosts.ini pb-test-connection.yml
   shell> ansible-playbook -i hosts.iocage2.yml pb-test-connection.yml

Execution output:

.. code-block:: text

   PLAY [Test connection and get hostname] ****************************************

   TASK [command] *****************************************************************
   changed: [log_server_01]
   changed: [pkg_repo]
   changed: [repos]

   TASK [debug] *******************************************************************
   ok: [pkg_repo] => 
       hostname: pkg-repo
   ok: [log_server_01] => 
       hostname: log-server-01
   ok: [repos] => 
       hostname: repos

   PLAY RECAP *********************************************************************
   log_server_01              : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   pkg_repo                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
   repos                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

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

     admin ALL=(ALL) NOPASSWD: ALL

* **Host unmanaged / restricted:** If you prefer least-privilege access
  restricted solely to jail execution, limit the rule to the ``jexec`` binary:

  .. code-block:: text

     admin ALL=(ALL) NOPASSWD: /usr/sbin/jexec

.. note::

   See :ref:`ag_setup_plugins`.

.. seealso::

   * `man jexec`_
   * `man jail`_

.. _man jexec: https://man.freebsd.org/cgi/man.cgi?query=jexec&sektion=8
.. _man jail: https://man.freebsd.org/cgi/man.cgi?query=jail&sektion=8

.. _ansible.builtin.ssh: https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/ssh_connection.html#parameter-remote_user
.. _inventory_hostname: https://docs.ansible.com/projects/ansible/latest/reference_appendices/special_variables.html#term-inventory_hostname
