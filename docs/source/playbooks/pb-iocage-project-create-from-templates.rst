pb_iocage_project_create_from_templates
---------------------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: pb_iocage_project_create_from_templates.yml; pb_iocage_project_create_from_templates
.. index:: single: project create from templates; pb_iocage_project_create_from_templates

Synopsis
^^^^^^^^

This playbook creates jails in a project from templates.

.. hint::

   Look at the ``Index`` and search the playbook
   ``pb_iocage_project_create_from_templates.yml`` to see what examples are
   available.

Example
^^^^^^^

Define the project hosts and their assigned templates in the ``project``
dictionary:

.. code-block:: yaml+jinja

   project:
     log-server-01:
       notes: alias=log_server_01
       vmm: iocage_06
       template: ansible-init
       class: [log-server]
       custom_facts: class.fact.j2
       ai_vars_templates:
         - project-hosts.yml
       properties:
         defaultrouter: "{{ project_hosts[inventory_hostname]['defaultrouter'] }}"
         ip4_addr: "vnet0|{{ project_hosts[inventory_hostname]['log_server'] }}/24"
         vnet: 1
         boot: 1
     www-01:
       notes: alias=www_01
       vmm: iocage_06
       template: ansible-init
       class: [log-client]
       custom_facts: class.fact.j2
       ai_vars_templates:
         - project-hosts.yml
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1
         boot: 1
     www-02:
       notes: alias=www_02
       vmm: iocage_06
       template: ansible-init
       class: [log-client]
       custom_facts: class.fact.j2
       ai_vars_templates:
         - project-hosts.yml
       properties:
         bpf: 1
         dhcp: 1
         vnet: 1
         boot: 1

Execute the playbook:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_project_create_from_templates.yml
