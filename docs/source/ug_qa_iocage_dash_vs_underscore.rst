.. _ug_qa_iocage_dash_vs_underscore:

Should I use dashes or underscores in iocage jail names?
--------------------------------------------------------

In FreeBSD iocage, there is no strict technical restriction forcing you to
choose between dashes (``-``) or underscores (``_``) for jail names, but dashes (``-``)
are widely considered the standard best practice.

.. list-table:: Comparison: Dash (``-``) vs. Underscore (``_``)
   :widths: 25 35 40
   :header-rows: 1

   * - Feature
     - Dash (``-``)
     - Underscore (``_``)
   * - DNS & Hostname Compliance
     - Fully compliant (RFC 1035 / RFC 1123)
     - Non-compliant (invalid in standard hostnames)
   * - Command-Line Usability
     - Easier to type (no Shift key required on standard layouts)
     - Slightly slower to type (requires Shift)
   * - Visual Separation
     - Compact and clean
     - Distinct, but visually heavier
   * - Typical Use Case
     - Standard jails, network services, public-facing hosts
     - 1:1 mapping with underscore-named datasets, databases, or Ansible groups

Key Considerations
^^^^^^^^^^^^^^^^^^

1. **RFC Compliance and DNS Interoperability** (The Deciding Factor):
   The primary reason to use dashes is network standard compliance.

   * **The Rule**: According to internet standards (`RFC 1035`_ and `RFC 1123`_), valid
     characters for hostnames and domain labels are strictly letters (``a-z``, ``A-Z``),
     digits (``0-9``), and hyphens (``-``). Underscores are not permitted in hostnames.
   * **The Impact**: By default, an iocage jail's name often mirrors its internal
     hostname or ZFS dataset name. Using an underscore (e.g., ``jail_name``) can cause
     strict DNS resolvers, mail transfer agents (MTAs), web servers, or TLS certificate
     authorities to reject hostnames associated with the jail.

2. **FreeBSD Conventions**:
   FreeBSD conventions favor hyphens when naming network-facing entities or composite
   identifiers (such as ``epair`` interfaces created for `VNET`_ jails).

3. **When Underscores Might Be Used**:
   Some administrators use underscores when a jail's identity maps directly to an existing
   entity that relies on underscores, such as a database schema, an Ansible group, or a
   predefined ZFS dataset (e.g., ``db_01``). However, even in these cases, keeping the jail
   and hostname dash-separated remains safer for network resolution.

Best Practice
^^^^^^^^^^^^^

To maintain full RFC compliance and avoid network-layer issues, use dashes (``-``)
for iocage jail names (e.g., ``db-01``, ``web-01``).

If automating FreeBSD with Ansible, remember that Ansible variables and group names
strongly prefer underscores. You can keep your jail names dash-compliant while mapping
them to underscore-friendly aliases in your inventory. See
:ref:`ug_qa_ansible_dash_vs_underscore`.

.. seealso::

   * `RFC 1035`_ (Domain Implementation and Specification)
   * `RFC 1123`_ (Requirements for Internet Hosts - Application and Support)
   * :ref:`ug_qa_ansible_dash_vs_underscore`
