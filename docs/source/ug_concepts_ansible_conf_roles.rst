.. _ug_concepts_ansible_conf_roles:

Repository ansible-conf-roles
-----------------------------

.. index:: single: ansible-conf-roles; Concepts
.. index:: single: pb-roles.yml; Concepts
.. index:: single: ai_conf_roles; Concepts

.. contents::
   :local:
   :depth: 2

Overview
^^^^^^^^

The `ansible-conf-roles`_ repository provides an optional second-stage Ansible
configuration and playbook. This repository can be defined in ``ai_db_host``
and/or ``ai_db_class`` and invoked by the ``pb-init.yml`` playbook from
`ansible-conf-init`_.

A minimal subset of the Ansible collection ``vbotka.freebsd`` is bundled in the
``collections/ansible_collections/vbotka/freebsd/`` directory.

Playbook pb-roles.yml workflow
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figure:: figures/pb-roles.svg
   :alt: Playbook pb-roles.yml Workflow
   :scale: 120
   :align: center
   :width: 80%

|

Variables
"""""""""

The playbook iterates through the directory defined by ``ai_vars`` and
dynamically loads all ``.yml`` and ``.yaml`` variable files (populating
dictionaries like ``ai_conf_roles``). It outputs debug information showing the
current execution parameters. For example:

.. code-block:: yaml+jinja

   ai_conf_roles:
     vbotka.freebsd.packages: [conf, pkg-install]
     vbotka.freebsd.postinstall: [syslogd, syslog-ng]

Dynamic Role and Task Execution
"""""""""""""""""""""""""""""""

The playbook converts the ``ai_conf_roles`` dictionary into a flat list of
role-to-task pairs using the filter expression ``dict2items |
subelements('value')``, then iterates over every role/task combination:

.. code-block:: yaml+jinja

   - ansible.builtin.include_role:
       name: "{{ oitem.0.key }}"
       tasks_from: "{{ oitem.1 }}"
     loop: "{{ ai_conf_roles | dict2items | subelements('value') }}"
     loop_control:
       loop_var: oitem

.. note::

   Use the task file ``main`` to include the complete role.

.. seealso::

   * Example :ref:`example_528`
   * Repository `ansible-conf-roles`_


.. _ansible-conf-init: https://github.com/vbotka/ansible-conf-init
.. _ansible-conf-roles: https://github.com/vbotka/ansible-conf-roles
