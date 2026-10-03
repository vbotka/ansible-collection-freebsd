.. _ug_filter_combine_properties:

.. index::
   single: filter vbotka.freebsd.combine_properties; Filter combine_properties
   single: vbotka.freebsd.combine_properties; Filter combine_properties
   single: combine_properties; Filter combine_properties
   single: project; Filter combine_properties
   single: swarms; Filter combine_properties
   single: property notes; Filter combine_properties

Filter vbotka.freebsd.combine_properties
----------------------------------------

.. contents::
   :local:
   :depth: 2

Synopsis
^^^^^^^^

The ``combine_properties`` filter merges default jail properties with
specification-specific properties in a ``dict2items`` loop. It produces a
space-delimited ``key=value`` string ending with a consolidated ``notes="..."``
attribute containing dynamic host and class metadata.


Parameters
^^^^^^^^^^

.. list-table::
   :widths: 20 15 15 50
   :header-rows: 1

   * - Parameter
     - Type
     - Default
     - Comments
   * - **_input**
     - dictionary
     -
     - Dictionary of default properties.
   * - **host**
     - string
     -
     - Target inventory hostname (e.g. ``inventory_hostname``) used for ``vmm=<host>``.
   * - **spec**
     - raw
     -
     - Current element from a ``dict2items`` loop (containing ``key`` and ``value``).
   * - **notes**
     - list / elements=string
     - ``['vmm', 'class']``
     - List of metadata keys to append to the ``notes="..."`` attribute.

.. hint::

   View the documentation from the command line:

   .. code:: console

      shell> ansible-doc -t filter vbotka.freebsd.combine_properties


Transformations
^^^^^^^^^^^^^^^

When evaluated in a ``dict2items`` loop, the filter applies the following rules:

* **Properties:** Items in ``item.value.properties`` take precedence over and
  override matching keys in ``_input``.
* **Notes:** Pre-existing ``notes`` definitions in ``item.value.notes``,
  ``item.value.properties.notes``, and ``_input.notes`` are stripped from the
  main key-value assignments and merged first.
* **Attributes:** Selected metadata keys are evaluated and appended in order:

  * ``vmm``: Evaluates to ``vmm=<host>``.
  * ``class``: Joined as comma-delimited values from ``item.value.class`` (e.g., ``class=log-client,nginx``).
  * ``swarm``: Resolves from ``item.value.swarm``, falling back to the item key (``item.key``).
  * *Arbitrary keys:* Resolved directly from ``item.value[key]``.


Examples
^^^^^^^^

Playbook with Jails and Swarms
""""""""""""""""""""""""""""""

.. code-block:: yaml

   - name: Test filter vbotka.freebsd.combine_properties
     hosts: iocage_06

     vars:

       properties:
         bpf: 1
         dhcp: 1
         vnet: 1

       jails:
         www-02:
           class: [log-client, nginx]
           notes: alias=www_02
           properties:
             boot: 1

       swarms:
         swarm_01:
           swarm: production
           count: 3
           class: [monitor, web]
           properties:
             boot: 1
         devel:
           count: 2
           class: [monitor, web]
           properties:
             boot: 1

       j: "{{ properties
              | vbotka.freebsd.combine_properties(inventory_hostname, item) }}"
       s: "{{ properties
              | vbotka.freebsd.combine_properties(inventory_hostname, item, notes=['vmm', 'class', 'swarm']) }}"

     tasks:

       - name: Combine jail properties (default notes: vmm, class)
         ansible.builtin.debug:
           msg: "{{ j | to_yaml }}"
         loop: "{{ jails | dict2items }}"
         loop_control:
           label: "{{ item.key }}"

       - name: Combine swarm properties with custom notes attribute
         ansible.builtin.debug:
           msg: "{{ s | to_yaml }}"
         loop: "{{ swarms | dict2items }}"
         loop_control:
           label: "{{ item.key }}"

Output
""""""

.. code-block:: text

   TASK [Combine jail properties (default notes: vmm, class)] *********************
   ok: [iocage_06] => (item=www-02) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 boot=1 notes="alias=www_02 vmm=iocage_06 class=log-client,nginx"

   TASK [Combine swarm properties with custom notes attribute] ********************
   ok: [iocage_06] => (item=swarm_01) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 boot=1 notes="vmm=iocage_06 class=monitor,web swarm=production"
   ok: [iocage_06] => (item=devel) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 boot=1 notes="vmm=iocage_06 class=monitor,web swarm=devel"


Multi-Host Mapping with Project Filter
""""""""""""""""""""""""""""""""""""""

.. code-block:: yaml

   - name: Combine jail properties distributed by project mapping
     hosts: iocage

     vars:

       properties:
         bpf: 1
         dhcp: 1
         vnet: 1

       project:
         logserv_1:
           class: [log-server]
           vmm: iocage_01
         http_1:
           class: [log-client, http]
           vmm: iocage_02
         db_1:
           class: [log-client, db]
           vmm: iocage_02
         http_2:
           class: [log-client, http]
           vmm: iocage_04
         db_2:
           class: [log-client, db]
           vmm: iocage_04

       vmm: "{{ (project | vbotka.freebsd.project).vmm }}"
       _properties: "{{ properties
                        | vbotka.freebsd.combine_properties(inventory_hostname, item) }}"

     tasks:

       - name: Combine jail properties per host
         ansible.builtin.debug:
           msg: "{{ _properties | to_yaml }}"
         loop: "{{ vmm[inventory_hostname] | d({}) | dict2items }}"
         loop_control:
           label: "{{ item.key }}"

Output
""""""

.. code-block:: text

   TASK [Combine jail properties per host] ****************************************
   ok: [iocage_01] => (item=logserv_1) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_01 class=log-server"
   ok: [iocage_02] => (item=http_1) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_02 class=log-client,http"
   ok: [iocage_02] => (item=db_1) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_02 class=log-client,db"
   ok: [iocage_04] => (item=http_2) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_04 class=log-client,http"
   ok: [iocage_04] => (item=db_2) =>
     msg: |-
       bpf=1 dhcp=1 vnet=1 notes="vmm=iocage_04 class=log-client,db"


Return Value
^^^^^^^^^^^^

.. list-table::
   :widths: 20 15 65
   :header-rows: 1

   * - Key
     - Type
     - Description
   * - **_value**
     - string
     - Space-delimited string of property assignments ending with ``notes="..."``.


.. seealso::

   * Ansible Galaxy `filter combine_properties`_
