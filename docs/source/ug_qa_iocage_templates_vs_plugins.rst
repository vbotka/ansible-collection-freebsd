.. _ug_qa_iocage_templates_vs_plugins:

.. index:: single, iocage_plugins; Q&A
.. index:: single, iocage_templates; Q&A

What are the advantages of iocage templates over plugins?
---------------------------------------------------------

When architecting FreeBSD jail infrastructure using ``iocage``, provisioning can
generally follow two patterns: building customized **templates** or deploying
turnkey **plugins**.

While plugins target fast, single-app appliances, templates provide
deterministic local provisioning, instantaneous ZFS cloning, and complete
architectural control.

Advantages of Templates
^^^^^^^^^^^^^^^^^^^^^^^

Immunity to Upstream Bitrot
"""""""""""""""""""""""""""

Plugins rely on remote JSON manifests, external artifact repositories, and live
FreeBSD package mirrors at deployment time. If upstream ports change, download
URLs break, or the manifest maintainer abandons the repository, provisioning
fails.

Templates exist entirely within the local ZFS pool as snapshots. Once generated,
deployment repeatability is guaranteed and completely decoupled from external
network availability.

Instantaneous ZFS CoW Cloning
"""""""""""""""""""""""""""""

Instantiating a jail from a template:

.. code-block:: console

   # iocage create -t <template_name> -n <jail_name>

leverages native ZFS Copy-on-Write (CoW) snapshots. Clones are generated in
sub-second intervals and consume zero initial disk space beyond metadata. In
contrast, plugins must download, unpack, and install packages sequentially on
every run.

Full Architectural and Security Control
"""""""""""""""""""""""""""""""""""""""

Plugins execute predefined post-install scripts that enforce opinionated
filesystem layouts, UID/GID assignments, and startup flags.

Templates allow full administrative ownership over the base image:

* Custom OS hardening and baseline firewall/PF configurations
* Preconfigured local package repository mirrors (e.g., Poudriere)
* Predictable VNET configurations and network interface naming
* Customized system initialization services and rc.conf defaults

Infrastructure-as-Code Integration
""""""""""""""""""""""""""""""""""

Templates fit naturally into automated configuration management workflows. An
orchestrator can provision a standard jail, execute configuration plays, convert
it to a template (``set template=yes``), and stamp out fleet instances. Plugins
function largely as black boxes, making automated lifecycle management brittle.

Feature Comparison
^^^^^^^^^^^^^^^^^^

.. list-table:: Architectural Differences
   :widths: 25 35 40
   :header-rows: 1

   * - Attribute
     - iocage Template
     - iocage Plugin
   * - **Provisioning Primitive**
     - Local ZFS snapshot clone
     - Remote JSON manifest + fetch script
   * - **Deployment Time**
     - Sub-second (instantaneous CoW)
     - Minutes (network fetch + pkg install)
   * - **External Dependencies**
     - None (fully local to ZFS pool)
     - Git repositories, manifest hosts, pkg mirrors
   * - **Maintenance Model**
     - Handled via internal IaC pipelines
     - Dependent on upstream maintainer updates
   * - **Rootfs Customization**
     - Total control over base image
     - Constrained by plugin script assumptions
