.. _ug_qa_jid_persistent:

.. index:: single: JID; Q&A
.. index:: single: UUID; Q&A

Is it possible to set the jail ID (JID) in iocage?
--------------------------------------------------

**No, it is not possible to set or persist the jail ID (JID) when creating a  jail with iocage.**

FreeBSD and ``iocage`` handle jail identification according to the following
mechanics:

Dynamic Allocation by the Kernel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* **Lifecycle:** A FreeBSD jail does not possess a JID while stopped. A JID is a
  dynamic runtime identifier allocated by the FreeBSD kernel when a jail is
  brought up (analogous to a process ID / PID).

* **Reboots & Restarts:** Every time a jail restarts or the host reboots, the
  kernel assigns the next available sequential integer. Because JIDs change
  between runs, they are never treated as persistent configuration parameters in
  ``iocage``.

jail(8) vs. iocage
^^^^^^^^^^^^^^^^^^

* At the base FreeBSD system level, ``jail(8)`` technically supports passing an
  explicit ``jid^<number>`` parameter during creation via ``jail -c jid^X ...``
  or inside ``/etc/jail.conf`` (provided that integer is not already in use).

* However, ``iocage`` abstracts this away entirely. It does **not** expose a
  ``jid`` property in ``iocage create`` or ``iocage set``. The JID only appears
  as a transient, read-only runtime attribute in ``iocage list`` and ``jls``
  while the jail's state is ``UP``.

Persistent Targeting
^^^^^^^^^^^^^^^^^^^^

If automation or referencing requires a stable identifier across reboots, use
one of the persistent identifiers managed by ``iocage``:

* **name:** The human-readable string passed via ``iocage create -n
  <name>`` (e.g., ``webserver01``).

* **uuid:** The unique UUID generated for the jail.

Commands such as ``jexec``, ``jail``, and base utilities accept the jail
**name** anywhere a JID is expected, avoiding reliance on runtime JIDs:

.. code-block:: sh

   jexec webserver01 /bin/sh
