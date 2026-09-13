.. _ug_qa_jexec_iocage_name:

.. index:: single: jexec; Q&A
.. index:: single: connection vbotka.freebsd.jailexec; Q&A
.. index:: single: vbotka.freebsd.jailexec; Q&A
.. index:: single: jailexec; Q&A
.. index:: single: jail name; Q&A

Why doesn't jexec work with iocage names?
-----------------------------------------

The FreeBSD base command ``jexec`` expects either the numeric JID (Jail ID) or
the kernel-level jail name registered in the OS jail subsystem. ``iocage``
assigns a prefixed internal name (such as ``ioc-pkg-repo``) or a UUID to the
FreeBSD kernel's jail subsystem, while mapping your friendly label
(e.g., ``pkg-repo``) strictly within its own metadata and CLI.

For example, consider the following jails created by ``iocage``:

.. code-block:: console

   # iocage list
   +-----+---------------+-------+--------------+--------------+
   | JID |     NAME      | STATE |   RELEASE    |     IP4      |
   +=====+===============+=======+==============+==============+
   | 1   | log-server-01 | up    | 15.1-RELEASE | 172.16.99.10 |
   +-----+---------------+-------+--------------+--------------+
   | 2   | pkg-repo      | up    | 15.1-RELEASE | 172.16.99.23 |
   +-----+---------------+-------+--------------+--------------+
   | 3   | repos         | up    | 15.1-RELEASE | 172.16.99.21 |
   +-----+---------------+-------+--------------+--------------+
   | 4   | repos-devel   | up    | 15.1-RELEASE | 172.16.99.22 |
   +-----+---------------+-------+--------------+--------------+

Inspect what the FreeBSD kernel actually names your jails:

.. code-block:: console

   # jls -v
   JID  Hostname                      Path
        Name                          State
        CPUSetID
        IP Address(es)
     1  log-server-01                 /zroot/iocage/jails/log-server-01/root
        ioc-log-server-01             ACTIVE
        3
     2  pkg-repo                      /zroot/iocage/jails/pkg-repo/root
        ioc-pkg-repo                  ACTIVE
        4
     3  repos                         /zroot/iocage/jails/repos/root
        ioc-repos                     ACTIVE
        5
     4  repos-devel                   /zroot/iocage/jails/repos-devel/root
        ioc-repos-devel               ACTIVE
        6

Both the JID and the kernel jail name work with ``jexec``:

.. code-block:: console

   # jexec 2 hostname
   pkg-repo
   # jexec ioc-pkg-repo hostname
   pkg-repo

However, the iocage short name fails:

.. code-block:: console

   # jexec pkg-repo hostname
   jexec: jail "pkg-repo" not found