.. _ug_bp_connection_ssh_rdr:

SSH via redirected ports
^^^^^^^^^^^^^^^^^^^^^^^^

.. index::
   single: pf port redirection; Best practice - connection
   single: port redirection; Best practice - connection
   single: redirection of ports; Best practice - connection

Connecting directly to `VNET`_ jails across isolated or bridged private networks
often requires routing or port `redirection`_ at the host firewall level. `PF`_
(Packet Filter) on the host can redirect dedicated host TCP ports directly to
the SSH daemon inside each jail.

.. code-block:: text
   :caption: Redirection 172.16.95.1:2306 -> 172.16.95.106:22

   +-----------------------+
   |  Ansible Controller   |
   +-----------------------+
               |
               | Connect: ssh -p 2306 admin@172.16.95.1
               v
   +-------------------------------------------------------+
   | Jail Host (172.16.95.1)                               |
   |                                                       |
   |   +-----------------------------------------------+   |
   |   | Packet Filter (PF) NAT / RDR                  |   |
   |   |   rdr on bridge0: 172.16.95.1:2306            |   |
   |   |                -> 172.16.95.106:22            |   |
   |   +-----------------------------------------------+   |
   |                           |                           |
   |                    bridge0 (VNET)                     |
   |                           |                           |
   |                           v                           |
   |   +-----------------------------------------------+   |
   |   | Jail (172.16.95.106)                          |   |
   |   |   sshd listening on port 22                   |   |
   |   +-----------------------------------------------+   |
   +-------------------------------------------------------+


Firewall and port redirection layout
""""""""""""""""""""""""""""""""""""

`PF`_ redirects incoming host ports starting at an offset (e.g.,
``2200``) to port ``22``:

.. code-block:: text

   rdr on bridge0 proto tcp from any to 172.16.95.1 port 2301 -> 172.16.95.101 port 22
   rdr on bridge0 proto tcp from any to 172.16.95.1 port 2302 -> 172.16.95.102 port 22
   ...
   rdr on bridge0 proto tcp from any to 172.16.95.1 port 2306 -> 172.16.95.106 port 22

Dynamic inventory configuration
"""""""""""""""""""""""""""""""

When jails are created dynamically (such as jails created in
:ref:`example_441`), use the `ansible.builtin.constructed`_ inventory plugin to
compose `ansible_host`_ and `ansible_port`_ dynamically from the facts
discovered, e.g., by the :ref:`vbotka.freebsd.iocage2 <ug_inventory_iocage2>`
inventory plugin:

.. code-block:: yaml+jinja
   :caption: hosts/99_constructed.yml

   plugin: ansible.builtin.constructed
   strict: true
   compose:
     ansible_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm
     ansible_port: iocage_ip4 | split('.') | last | int + 2200

Connection plugin `ansible.builtin.ssh`_ options:

* `ansible_host`_: Extracted from the ``notes`` property of the jail (which
  stores the parent VM/host identifier ``vmm``).

* `ansible_port`_: Calculated from the last octet of the jail's IPv4 address
  (``iocage_ip4``), offset by ``2200``.

Connecting from the controller
""""""""""""""""""""""""""""""

With this mapping in place, connections to managed jails resolve directly
through the host IP and mapped port without requiring changes to the
controller's SSH configuration:

.. code-block:: console

   shell> ssh -p 2306 admin@iocage_06

In playbooks targeting these constructed groups, Ansible modules execute over
SSH transparently:

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. seealso::

   * :ref:`example_440`
   * :ref:`example_441`
