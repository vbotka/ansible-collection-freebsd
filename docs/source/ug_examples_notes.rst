.. note::

   * The examples that create jails use the iocage host setting created in the example
     :ref:`example_440` by default. The firewall is on both the external interface and the ``vnet``
     bridge of the iocage host. DHCP for the jails is on the bridge, and SSH access from the local
     network to the jails is redirected. Examples that do not use this setting are marked ``.deny``,
     meaning they are excluded from ``batch.sh``. To run these examples, the firewall must be
     reconfigured; see :ref:`example_370`.

   * All examples include additional files that are not displayed in the file tree. Review these
     files for more details.

   * The examples include a ``batch.sh`` script that executes the commands and generates the output
     for each example.

   * Most playbooks in ``batch.sh`` are idempotent. If a playbook is run repeatedly, the output may
     display a status of ``ok`` instead of the expected ``changed``.

   * The playbooks in the examples use dashes (``-``) in their filenames (e.g. ``pb-iocage.yml``).

   * Due to Ansible collection naming conventions, the playbooks in the collection use underscores
     (``_``) in their filenames (e.g. ``pb_iocage_template.yml``).

   * To avoid connection errors in examples where DHCP is used, ``host_key_checking = false`` can be
     configured in ``ansible.cfg``.
