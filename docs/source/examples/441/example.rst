.. _example_441:

441 Redirect SSH to jails
-------------------------

| This example extends :ref:`example_440`.
| This example extends :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: swarms; Example 441
   single: swarms create from templates; Example 441
   single: pb_iocage_ansible_clients.yml; Example 441
   single: option compose; Example 441
   single: compose; Example 441
   single: option defaultrouter; Example 441
   single: defaultrouter; Example 441
   single: variable iocage_tags; Example 441
   single: iocage_tags; Example 441
   single: option iocage --count; Example 441
   single: option iocage --short; Example 441
   single: option iocage --template; Example 441
   single: pf port redirection; Example 441
   single: port redirection; Example 441
   single: redirection of ports; Example 441

Use case
^^^^^^^^

Create multiple jails with auto ``UUID``. Use connection `ansible.builtin.ssh`_
(default).  In the inventory, `compose`_ the variables ``ansible_host`` and
``ansible_port`` to connect to the jails via `redirected SSH ports`_. See
:ref:`example_440` for how `Packet Filter (PF)`_ is configured.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── swarms.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  └── pb-test.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`:

    * Create jails.
    * Start jails.
    * Optionally, stop and destroy the jails.

  * Create a dynamic inventory to connect to the jails via `redirected SSH
    ports`_.

* On the created jails, in the playbook ``pb-test.yml``:

  * Display the connection variables.
  * Test the connection to the created jails.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-ansible-clients`
* :ref:`ug_inventory_iocage2`
* Template ``ansible-client`` created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* The only difference between this example and :ref:`example_442` is the
  following two lines in the inventory configuration file:

.. code-block:: yaml+jinja

   ansible_host: dict(iocage_properties.notes | regex_findall('(\w+)=([\w\-]+)')).vmm
   ansible_port: iocage_ip4 | split('.') | last | int - 100 + 2200

.. seealso::

   :ref:`example_050`

ansible.cfg
^^^^^^^^^^^

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

hosts
^^^^^

.. literalinclude:: hosts/05_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 5-6

.. note::

   * In :ref:`example_440`, the variables ``ssh_rdr_start=2200`` and
     ``start=100`` are used in the playbook ``pb-pf-setup.yml`` to
     calculate the ports to redirect SSH from, and to create the file
     ``pf-rdr-ssh.conf``.

   * For example, from the controller, the following command connects to the
     jail at ``<bsd_dhcpd_subnet>.106``::

       shell> ssh -p 2206 admin@iocage_06

   * See the variable ``bsd_dhcpd_subnet`` in :ref:`example_440`.

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/swarms.yml
   :language: yaml+jinja
   :caption:

.. hint::

   If the default value of the iocage `jail property`_ (``defaultrouter=auto``)
   does not work, set it explicitly. This may be needed if the jails are
   assigned IP addresses via DHCP on the bridge. In this case, the defaultrouter
   for the jails is the IP address of the bridge. `PF`_ must provide `NAT`_ and
   `redirection`_. See :ref:`example_440`.

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            -e iocage_jails_source=inventory \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. literalinclude:: out/out-04.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts --graph

Jails
^^^^^

.. literalinclude:: out/out-05.txt
   :language: bash
   :caption: [iocage_05]# iocage list -l

.. literalinclude:: out/out-06.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Test SSH redirection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

.. hint::

   The following play stops and destroys the jails in ``swarms``::

     (env) > ansible-playbook -i iocage.ini \
                              -t swarm_destroy -e swarm_destroy=true \
                              vbotka.freebsd.pb_iocage_ansible_clients.yml
