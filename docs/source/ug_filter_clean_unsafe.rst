.. _ug_filter_clean_unsafe:

.. index:: single: filter vbotka.freebsd.clean_unsafe; Plugins
.. index:: single: clean_unsafe; Plugins

Filter vbotka.freebsd.clean_unsafe
----------------------------------

.. contents::
   :local:
   :depth: 2

Synopsis
^^^^^^^^

The ``clean_unsafe`` filter recursively traverses data structures (dictionaries,
lists, sets, and tuples) and unwraps internal ``__ansible_unsafe`` metadata
objects, restoring them to native Python types.

Starting with modern Ansible core releases, registered task projections, command
evaluations, and exported inventories (such as ``ansible-inventory --export``)
frequently wrap strings in ``AnsibleUnsafeText`` objects to mitigate template
injection vulnerabilities. When serialized via ``to_yaml``, dumped through
representation formatters, or processed by strict deserialization engines (like
the ``tagless`` profile in ``from_json``), these objects manifest as unwanted
``__ansible_unsafe`` mapping keys or trigger deserialization failures.

The ``clean_unsafe`` filter sanitizes these data trees in place, producing clean
native data structures suitable for YAML/JSON serialization and downstream
filtering.


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
     - any
     -
     - Data structure (mapping, sequence, or scalar) containing wrapped
       ``__ansible_unsafe`` objects or ``AnsibleUnsafe`` types.

.. hint::

   View the documentation from the command line:

   .. code:: console

      shell> ansible-doc -t filter vbotka.freebsd.clean_unsafe

Transformations
^^^^^^^^^^^^^^^

The filter evaluates elements recursively based on their container type:

Mappings & Dictionaries

   * **Wrapper Dictionaries:** Any single-key dictionary matching
     ``{"__ansible_unsafe": <value>}`` is unpacked, and its underlying value is
     recursively evaluated and returned in place of the dictionary.

   * **Nested Mappings:** Standard dictionaries have all keys preserved while
     each corresponding value is recursively cleaned.

Sequences & Sets

   * **Lists, Tuples, and Sets:** Iterated recursively, returning corresponding
     clean sequences with all nested unsafe wrappers stripped.

Scalars & Unsafe Primitives

   * **AnsibleUnsafe Instances:** Primitive objects inheriting from Ansible's
     internal ``AnsibleUnsafe`` hierarchy (such as ``AnsibleUnsafeText``) are
     cast to standard Python primitives (e.g., native ``str``).

   * **Native Primitives:** Standard integers, floats, booleans, and untagged
     strings pass through unmodified.

Examples
^^^^^^^^

Input Raw Inventory Data
""""""""""""""""""""""""

.. code-block:: yaml

   # Raw hostvars resulting from ansible-inventory --export:
   jail_inventory_vars:
     log-server-01:
       iocage_basejail:
         __ansible_unsafe: 'no'
       iocage_boot:
         __ansible_unsafe: 'on'
       iocage_hooks:
         - __ansible_unsafe: '-'
       iocage_ip4:
         __ansible_unsafe: 172.16.99.10
       iocage_ip4_dict:
         ip4:
           - ifc:
               __ansible_unsafe: vnet0
             ip:
               __ansible_unsafe: 172.16.99.10
             mask:
               __ansible_unsafe: '24'
         msg:
           __ansible_unsafe: ''
       iocage_jid:
         __ansible_unsafe: '1'
       iocage_state:
         __ansible_unsafe: up

Ansible Task Pipeline
"""""""""""""""""""""

.. code-block:: yaml

   - name: Query iocage2 inventory plugin
     delegate_to: localhost
     changed_when: false
     register:
       iocage_jails: _task.result.stdout | from_yaml
     ansible.builtin.command:
       cmd: "ansible-inventory -i hosts --list --export"

   - name: Sanitize and display cleaned hostvars
     ansible.builtin.debug:
       msg: "{{ iocage_jails._meta.hostvars | vbotka.freebsd.clean_unsafe | to_nice_yaml }}"

Cleaned Output
""""""""""""""

.. code-block:: yaml

   log-server-01:
     iocage_basejail: 'no'
     iocage_boot: 'on'
     iocage_hooks:
       - '-'
     iocage_ip4: 172.16.99.10
     iocage_ip4_dict:
       ip4:
         - ifc: vnet0
           ip: 172.16.99.10
           mask: '24'
       msg: ''
     iocage_jid: '1'
     iocage_state: up

Return Value
^^^^^^^^^^^^

.. list-table::
   :widths: 20 15 65
   :header-rows: 1

   * - Key
     - Type
     - Description
   * - **_value**
     - any
     - The sanitized data structure with all ``__ansible_unsafe`` wrappers and
       types converted to pure native Python objects.

.. seealso::

   `ansible-inventory --list JSON output shows unsafe values as dictionaries with __ansible_unsafe key #82999`_


.. _ansible-inventory --list JSON output shows unsafe values as dictionaries with __ansible_unsafe key #82999: https://github.com/ansible/ansible/issues/82999
