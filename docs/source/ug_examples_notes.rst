.. note::

   * The examples include a ``batch.sh`` script that executes the commands and
     generates the output for each example.

   * Most playbooks executed by ``batch.sh`` are idempotent. When a playbook
     is run repeatedly, tasks may report a status of ``ok`` rather than
     ``changed``.

   * All examples include additional files that are omitted from the directory
     tree. Review these files for further details.

   * By default, examples that provision jails use the iocage host configuration
     described in :ref:`example_440`. The firewall filters traffic on both the
     external interface and the VNET bridge interface on the iocage host. DHCP
     is enabled on the bridge for the jails, and SSH traffic from the local
     network is forwarded to them. Examples that do not use this configuration
     contain a ``.deny`` marker file and are excluded from ``batch.sh``. To run
     those examples, reconfigure the firewall as documented in :ref:`example_370`.

   * To avoid connecting directly to a jail via SSH, the examples use the
     dynamic inventory ``vbotka.freebsd.iocage2`` and the connection plugin
     ``vbotka.freebsd.jailexec``, as described in :ref:`connection
     vbotka.freebsd.jailexec <ug_connection_jailexec>`.

   * Playbook filenames in standalone examples use hyphens (``-``), such as
     ``pb-iocage.yml``.

   * Following Ansible collection conventions, playbook filenames within the
     collection use underscores (``_``), such as ``pb_iocage_template.yml``.

   * To avoid SSH host key verification failures caused by dynamic DHCP leases,
     set ``host_key_checking = false`` in ``ansible.cfg``.