.. _ug_bp_usecases:

Use cases
---------

.. contents::
   :local:
   :depth: 2

Dynamic inventory
^^^^^^^^^^^^^^^^^

A common use case involves managing environments where the operator lacks
``root`` access on the ``iocage`` host. Unprivileged access on the host is
sufficient to execute ``iocage list`` commands and generate the ``dynamic
inventory``, allowing the user to manage individual jail guests without
escalated root privileges (see :ref:`example_010`).

However, if your setup relies on dynamically assigned ``DHCP`` addresses,
``root`` access on the host is required to inspect and discover those IPs. For
these scenarios, configure the ``sudo`` and ``sudo_preserve_env`` options within
the ``iocage`` inventory plugin to handle host privilege escalation securely.

If the ``root`` is not granted, configure ``hooks`` and use the
``hooks_results`` option.
