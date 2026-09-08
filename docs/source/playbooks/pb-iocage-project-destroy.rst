pb_iocage_project_destroy
-------------------------

.. contents::
   :local:
   :depth: 3

.. index:: single: pb_iocage_project_destroy.yml; pb_iocage_project_destroy
.. index:: single: project destroy; pb_iocage_project_destroy

Synopsis
^^^^^^^^

This playbook destroys a project.

.. hint::

   Look at the ``Index`` and search the playbook
   ``pb_iocage_project_destroy.yml`` to see what examples are available.

Example
^^^^^^^

Define the hosts to destroy in the ``project`` dictionary:

.. code-block:: yaml

   project:
     logserv_1:
       class: [logserv]
       vmm: iocage_01
     http_1:
       class: [http, logclient]
       vmm: iocage_02

Execute the playbook:

.. code-block:: console

   (env) > ansible-playbook pb_iocage_project_destroy.yml