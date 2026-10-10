.. _ug_pb-iocage-project-destroy:

pb_iocage_project_destroy
-------------------------

.. contents::
   :local:
   :depth: 3

.. index::
   single: pb_iocage_project_destroy.yml; pb_iocage_project_destroy
   single: project destroy; pb_iocage_project_destroy

Synopsis
^^^^^^^^

This playbook destroys a project.

.. hint::

   Search ``pb_iocage_project_destroy.yml`` in :ref:`genindex` for available examples.

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

.. seealso::

   * :ref:`example_207`
