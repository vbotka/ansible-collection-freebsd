.. _ug_bp_connection_ssh_rdr:

SSH via redirected ports
^^^^^^^^^^^^^^^^^^^^^^^^

.. index::
   single: pf port redirection; Best practice - connection
   single: port redirection; Best practice - connection
   single: redirection of ports; Best practice - connection

Flow chart
""""""""""

.. code-block:: text

   +-----------------------+
   |  Ansible Controller   |
   +-----------------------+
               |
               | Connect: ssh -p 2206 admin@172.16.95.1
               v
   +-------------------------------------------------------+
   | Jail Host (172.16.95.1)                               |
   |                                                       |
   |   +-----------------------------------------------+   |
   |   | Packet Filter (PF) NAT / RDR                  |   |
   |   |   rdr on bridge0: 172.16.95.1:2206            |   |
   |   |                -> 172.16.95.106:22            |   |
   |   +-----------------------------------------------+   |
   |                           |                           |
   |                    bridge0 (VNET)                     |
   |                           |                           |
   |                           v                           |
   |   +-----------------------------------------------+   |
   |   | Target Jail (172.16.95.106)                   |   |
   |   |   sshd listening on port 22                   |   |
   |   +-----------------------------------------------+   |
   +-------------------------------------------------------+

.. csv-table:: Port mapping formula
   :header: "Entity", "Address / Port", "Formula / Source"
   :widths: 25, 25, 50

   "**Ansible Target**", "``172.16.95.1:2206``", "Host IP + port offset (``2200 + 6``)"
   "**Jail DHCP Lease**", "``172.16.95.106:22``", "Host base IP + offset (``100 + 6``)"
   "**PF Rule**", "``port 2206 -> :22``", "``ansible_port - 2200 + 100``"

Connecting directly to `VNET`_ jails across isolated or bridged private networks
often requires routing or port `redirection`_ at the host firewall level. When
jails obtain dynamic IPv4 addresses from DHCP on a local bridge, Packet Filter
(`PF`_) on the host can redirect dedicated host TCP ports directly to the SSH
daemon inside each jail.

Firewall and port redirection layout
""""""""""""""""""""""""""""""""""""

In this pattern, demonstrated in :ref:`example_440`, the host runs DHCP server
(``isc-dhcpd``) and ``pf`` on a bridged interface (for example, ``bridge0``):

* A DHCP range is assigned to jails (for example, ``172.16.95.100`` to
  ``172.16.95.199``).
* Packet Filter (``pf``) redirects incoming host ports starting at an offset
  (for example, ``2200``) to port ``22`` of the corresponding jail IP address:

  .. code-block:: text

     rdr on bridge0 proto tcp from any to 172.16.95.1 port 2200 -> 172.16.95.100 port 22
     rdr on bridge0 proto tcp from any to 172.16.95.1 port 2201 -> 172.16.95.101 port 22
     ...
     rdr on bridge0 proto tcp from any to 172.16.95.1 port 2206 -> 172.16.95.106 port 22

Dynamic inventory configuration
"""""""""""""""""""""""""""""""

When jails are created dynamically (such as swarms created with auto ``UUID``
in :ref:`example_441`), Ansible cannot rely on static hostnames or IP addresses.
Instead, use the ``ansible.builtin.constructed`` inventory plugin to compose
``ansible_host`` and ``ansible_port`` dynamically from the facts discovered by
the :ref:`vbotka.freebsd.iocage2 inventory plugin <ug_inventory_iocage2>`:

.. code-block:: yaml+jinja
   :caption: hosts/99_constructed.yml

   plugin: ansible.builtin.constructed
   strict: true
   compose:
     ansible_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm
     ansible_port: iocage_ip4 | split('.') | last | int - 100 + 2200

* **ansible_host**: Extracted from the ``notes`` property of the jail (which
  stores the parent VM/host identifier ``vmm``).
* **ansible_port**: Calculated from the last octet of the jail's assigned
  DHCP IPv4 address (``iocage_ip4``), offset by ``- 100 + 2200``.

Connecting from the controller
""""""""""""""""""""""""""""""

With this mapping in place, connections to managed jails resolve directly through
the host IP and mapped port without requiring changes to the controller's SSH
configuration:

.. code-block:: console

   shell> ssh -p 2206 admin@iocage_06

In playbooks targeting these constructed groups, standard modules execute over
standard SSH transparently:

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. seealso::

   * :ref:`example_440`
   * :ref:`example_441`
   * :ref:`ug_inventory_iocage2`
