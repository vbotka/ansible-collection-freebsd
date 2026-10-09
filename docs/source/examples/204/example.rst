.. _example_204:

204 Clone DHCP jails with auto UUID and iocage_tags v2
------------------------------------------------------

This example extends :ref:`example_203`.

.. contents::
   :local:
   :depth: 1

.. index::
   single: swarms; Example 204
   single: template ansible-client; Example 204
   single: ansible-client; Example 204
   single: DHCP; Example 204
   single: property notes; Example 204
   single: notes; Example 204
   single: filter vbotka.freebsd.iocage; Example 204
   single: inventory vbotka.freebsd.iocage; Example 204
   single: module ansible.builtin.command; Example 204
   single: pb-iocage-ansible-clients-v2.yml; Example 204
   single: option get_properties; Example 204
   single: get_properties; Example 204
   single: option hooks_results; Example 204
   single: hooks_results; Example 204
   single: option compose; Example 204
   single: compose; Example 204
   single: option groups; Example 204
   single: option iocage --count; Example 204
   single: option iocage --short; Example 204
   single: option iocage --template; Example 204
   single: variable iocage_jails; Example 204
   single: iocage_jails; Example 204
   single: variable iocage_hooks; Example 204
   single: iocage_hooks; Example 204
   single: variable iocage_properties; Example 204
   single: iocage_properties; Example 204
   single: variable iocage_tags; Example 204
   single: iocage_tags; Example 204

Use case
^^^^^^^^

Instead of using the :ref:`module vbotka.freebsd.iocage <ug_module_iocage>`,
create the variable ``iocage_jails`` using the :ref:`filter
vbotka.freebsd.iocage <ug_filter_iocage>`:

.. literalinclude:: pb-iocage-ansible-clients-v2/iocage_jails.yml
   :language: yaml+jinja
   :caption:

**Test filter vbotka.freebsd.iocage**

Given the input ``vars/iocage_datasets.yml``:

.. literalinclude:: vars/iocage_datasets.yml
   :language: yaml+jinja

The playbook ``pb-test-filter.yml``:

.. literalinclude:: pb-test-filter.yml
   :language: yaml+jinja

outputs:

.. literalinclude:: out/out-pb-test-filter.txt
   :language: yaml+jinja
   :force:

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── group_vars
  │   └── all
  │       └── iocage.yml
  ├── hosts
  │   ├── 05_iocage2.yml
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-iocage-ansible-clients-v2
  │   ├── iocage_jails.yml
  │   ├── swarm_destroy.yml
  │   └── swarm.yml
  ├── pb-iocage-ansible-clients-v2.yml
  ├── pb-test.yml
  ├── pb-test-filter.yml
  └── vars
      └── iocage_datasets.yml

Synopsis
^^^^^^^^

* On a managed node:

  In the playbook ``pb-iocage-ansible-clients-v2.yml``, use:

  * The module ``ansible.builtin.command`` to:

    * Create the variable ``iocage_jails``.
    * Create jails.
    * Start jails.
    * Optionally, stop and destroy the jails.

* On all created jails:

  In the playbook ``pb-test.yml``:

  * Display selected variables.

Requirements
^^^^^^^^^^^^

* :ref:`ug_filter_iocage`
* :ref:`ug_inventory_iocage2`
* Templates created in :ref:`example_202`
* Root privileges on the managed nodes.

Notes
^^^^^

* This example doesn't need the filters:

  * :ref:`project <ug_filter_project>`
  * :ref:`combine_properties <ug_filter_combine_properties>`

  The variables are created from Jinja expressions.

.. seealso::

   * `binary iocage`_

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
   :emphasize-lines: 4

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:
   :emphasize-lines: 4

.. note::

   The option ``get_properties: True`` is needed to get the dictionary
   ``iocage_properties``.

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/iocage.yml
   :language: yaml+jinja
   :caption:

Playbook pb-iocage-ansible-clients-v2.yml
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-ansible-clients-v2.yml
   :language: yaml+jinja

Playbook output - Create swarms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            -e debug=true \
                            pb-iocage-ansible-clients-v2.yml

.. literalinclude:: out/out-03.txt
   :language: yaml+jinja
   :force:

Graph
^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts --graph

.. literalinclude:: out/out-04.txt
   :language: console

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

Playbook output - Display test vars
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

.. hint::

   The command below stops and destroys the jails in ``swarms``::

     ansible-playbook -i iocage.ini \
                      -t swarm_destroy -e swarm_destroy=true \
                      pb-iocage-ansible-clients-v2.yml