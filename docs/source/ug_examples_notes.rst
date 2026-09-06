.. note::

   * The examples include a ``batch.sh`` script that executes the
     commands and generates the output for each example.

   * Most playbooks executed by ``batch.sh`` are idempotent. If a
     playbook is run repeatedly, tasks may report a status of ``ok``
     instead of the expected ``changed``.

   * All examples include additional files that are not shown in the
     directory tree. Review these files for more details.

   * By default, examples that create jails use the iocage host
     configuration from :ref:`example_440`. The firewall runs on both
     the external interface and the ``vnet`` bridge of the iocage
     host. DHCP for the jails is enabled on the bridge, and SSH access
     from the local network to the jails is redirected. Examples that
     do not use this configuration are marked ``.deny`` and are
     excluded from ``batch.sh``. To run these examples, reconfigure
     the firewall as described in :ref:`example_370`.

   * Playbook filenames in the examples use hyphens (-) (e.g.,
     ``pb-iocage.yml``).

   * In accordance with Ansible collection naming conventions,
     playbook filenames in the collection use underscores (_) (e.g.,
     ``pb_iocage_template.yml``).

   * To avoid SSH host key verification failures with dynamic DHCP
     addresses, set ``host_key_checking = False`` in ``ansible.cfg``.
