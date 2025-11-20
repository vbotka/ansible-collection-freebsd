pb_iocage_project_create
------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: playbook pb_iocage_project_create.yml; pb_iocage_project_create
.. index:: single: project create; pb_iocage_project_create

Synopsis
^^^^^^^^

This playbook creates jails in a ``project``.

.. hint::

   Look at the ``Index`` and search ``playbook pb_iocage_project_create.yml`` what examples are available.

Example
^^^^^^^

.. code-block:: yaml

   project:
     logserv_1:
       class: [logserv]
       vmm: iocage_01
     http_1:
       class: [http, logclient]
       vmm: iocage_02
     db_1:
       class: [db, logclient]
       vmm: iocage_02
     http_2:
       class: [http, logclient]
       vmm: iocage_04
     db_2:
       class: [db, logclient]
       vmm: iocage_04
