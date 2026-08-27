.. _ug_inventory_iocage2:
.. index:: single: inventory vbotka.freebsd.iocage2; Plugins

Inventory vbotka.freebsd.iocage2
--------------------------------

This chapter highlights the core operational, performance, and architectural differences between the
`inventory plugin vbotka.freebsd.iocage`_ and the `inventory plugin vbotka.freebsd.iocage2`_.

Overview
^^^^^^^^

While ``vbotka.freebsd.iocage`` relies on executing the high-level `iocage`_ command-line utility via
shell subprocesses, ``vbotka.freebsd.iocage2`` communicates directly with the underlying FreeBSD
system using native Python bindings (`filesystems/py-libzfs`_ and `sysutils/py-iocage`_).

Comparison Matrix
^^^^^^^^^^^^^^^^^

+------------------+------------------------------------+------------------------------------+
| Feature / Aspect | vbotka.freebsd.iocage              | vbotka.freebsd.iocage2             |
+==================+====================================+====================================+
| Primary Backend  | iocage CLI binary                  | libzfs & iocage_lib Python API     |
+------------------+------------------------------------+------------------------------------+
| Execution Method | Executes multiple CLI subprocesses | Inlined base64 engine on target    |
+------------------+------------------------------------+------------------------------------+
| Performance      | Slower (per-query CLI calls)       | Fast (direct ZFS memory objects)   |
+------------------+------------------------------------+------------------------------------+
| DHCP / Hooks     | Reads hook files post-discovery    | Maps DHCP interface & IP into dict |
+------------------+------------------------------------+------------------------------------+

Key Differences
^^^^^^^^^^^^^^^

Direct libzfs Integration
"""""""""""""""""""""""""

`vbotka.freebsd.iocage2` queries ZFS pool structures directly via ``libzfs.ZFS()``.  It traverses
``<pool>/iocage/jails`` child datasets in memory, eliminating shell execution overhead and
preventing stdout string-parsing errors over SSH.

Template Discovery
""""""""""""""""""

`vbotka.freebsd.iocage2` implements a multi-tier resolution strategy:

* Checks the ``source_template`` property.
* Checks ``cloned_from`` and ``template`` properties.
* Inspects the underlying ZFS dataset ``origin`` snapshot path (e.g. ``<pool>/iocage/templates/<template_name>@snap``).

Interface Extraction for DHCP Jails
"""""""""""""""""""""""""""""""""""

When a jail uses DHCP (``ip4_addr: none`` or ``ip4_addr: DHCP``), `vbotka.freebsd.iocage2`
automatically inspects `hooks_results` (e.g. ``/var/db/dhclient-hook.address.epair0b``).

* Extracts the interface name directly from the hook filename (``epair0b``).
* Populates ``iocage_ip4`` and ``iocage_ip4_dict`` dynamically so ``compose: ansible_host:
  iocage_ip4`` works seamlessly.

.. note::

   Target FreeBSD hosts require:

   * `filesystems/py-libzfs`_
   * `sysutils/py-iocage`_

.. seealso::

   * `inventory plugin vbotka.freebsd.iocage`_
   * `inventory plugin vbotka.freebsd.iocage2`_
   * `filesystems/py-libzfs`_
   * `sysutils/py-iocage`_


.. _inventory plugin vbotka.freebsd.iocage: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage
.. _inventory plugin vbotka.freebsd.iocage2: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/inventory/iocage2
.. _iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage&sektion=8
.. _filesystems/py-libzfs: https://www.freshports.org/filesystems/py-libzfs/
.. _sysutils/py-iocage: https://www.freshports.org/sysutils/py-iocage
