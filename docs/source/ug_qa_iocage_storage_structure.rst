.. _ug_qa_iocage_storage_structure:

.. index::
   single: iocage storage structure; Q&A
   single: iocage jails; Q&A
   single: base jails; Q&A
   single: thick jails; Q&A
   single: thin jails; Q&A

What is the iocage storage structure?
-------------------------------------

.. code-block:: text

   <zpool>/iocage/
   ├── download/
   │   └── <RELEASE>/               # Cached raw distribution archives (base.txz, doc.txz, etc.)
   ├── releases/
   │   └── <RELEASE>/
   │       └── root/                # Extracted, pristine base release filesystem (source for clones)
   ├── templates/
   │   └── <template-name>/
   │       ├── config.json          # Template configuration metadata
   │       └── root/                # Frozen, customized filesystem used for fast cloning
   ├── jails/
   │   └── <jail-name-or-uuid>/
   │       ├── config.json          # Jail properties, network setup, and runtime flags
   │       ├── fstab                # Jail-specific mounts (nullfs, devfs rulesets)
   │       └── root/                # The active jail's root filesystem (clone or standalone)
   ├── plugins/
   │   └── <plugin-name>/
   │       └── ...                  # Artifact packages, plugin manifests, and metadata
   └── log/                         # Runtime logs and operational history

Dataset Roles & Breakdown
^^^^^^^^^^^^^^^^^^^^^^^^^

download/
"""""""""

Stores compressed tarballs (base.txz, kernel.txz, etc.) retrieved during *iocage
fetch*. These files are cached locally to avoid re-downloading installation
archives if a release dataset needs re-extraction.

releases/
"""""""""

Contains the fully extracted, pristine FreeBSD userland for every downloaded
version.

The nested ``releases/<RELEASE>/root/`` dataset is snapshotted immediately upon
extraction (@snapshot or @basejail).

It remains read-only during normal operations and serves as the baseline origin
for all cloned jails and basejails.

jails/
""""""

Contains individual jail instances. Every jail occupies its own dataset
containing:

* **root/**: The jail's filesystem. In standard (thin/cloned) jails, this is a ZFS
  clone of a release snapshot or a template snapshot. In thick jails (-T), this
  is a fully independent, copied filesystem.

* **config.json**: The canonical configuration file storing all jail parameters
  (e.g., ip4_addr, vnet, mac_address, resource limits).

* **fstab**: Standard FreeBSD fstab entries mounted inside the jail's path upon
  start (e.g., host-shared storage or nullfs mounts).

templates/
""""""""""

Stores golden images used to stamp out pre-configured instances.  Structurally
identical to a jail inside jails/, but marked with ``template=yes``.

Prevented from booting directly. When a jail is created from a template (*iocage
create -t <template>*), iocage snapshots ``templates/<template>/root`` and
provisions a new clone in ``jails/<jail>/root``.

plugins/
""""""""

Houses pre-packaged, containerized applications. It keeps plugin metadata,
post-install artifact lists, and repository definitions alongside the underlying
jail deployment.

Storage Mechanics: Clones vs. Thick Jails
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Thin / Cloned Jails (Default)
"""""""""""""""""""""""""""""

Created with *iocage create -r <RELEASE> -n <name>*. The ``root/`` dataset is
created as a ZFS clone linked directly to
``<zpool>/iocage/releases/<RELEASE>/root@<snap>``. This uses negligible disk
space upon creation and enables rapid instantiation.

Thick Jails
"""""""""""

Created with *iocage create -T -r <RELEASE> -n <name>*. The files are copied
into an independent dataset with no snapshot lineage to the release, allowing
the release dataset to be destroyed or upgraded without dependency issues.

Base Jails
""""""""""

Use nullfs mounts (iocage/releases/<RELEASE>/root mounted read-only into /bin,
/lib, /usr, etc.) over a thin writable jail root.
