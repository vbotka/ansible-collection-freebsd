.. _ug_qa_jexec_iocage_name:

.. index:: single: connection vbotka.freebsd.jailexec; Plugins
.. index:: single: vbotka.freebsd.jailexec; Plugins
.. index:: single: jailexec; Plugins

Why jexec does not work with iocage names?
------------------------------------------

The FreeBSD base command jexec expects either the numeric JID (Jail ID) or the
kernel-level jail name defined in the OS jail subsystem. iocage assigns an
internal name (often a UUID or a prefixed name such as ioc-pkg-repo) to the
FreeBSD kernel's jail subsystem, while mapping your friendly label (pkg-repo)
strictly within its own metadata and CLI.

To verify what the FreeBSD kernel actually names your jail, run:

.. code-block:: bash

   jls -v
   # or
   jls jid name
