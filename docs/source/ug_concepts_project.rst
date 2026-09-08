.. _ug_concepts_project:

Project
-------

.. index:: single: variable project; Project
.. index:: single: project; Project
.. index:: single: variable vmm; Project
.. index:: single: vmm; Project
.. index:: single: variable class; Project
.. index:: single: class; Project
.. index:: single: filter vbotka.freebsd.project; Project
.. index:: single: vbotka.freebsd.project; Project

.. contents::
   :local:
   :depth: 2

project dictionary
^^^^^^^^^^^^^^^^^^

The ``project`` variable is a dictionary of jails. The ``vmm`` attribute defines
the host on which each jail is running:

.. code-block:: yaml+jinja

   project:
     logserv-1:
       class: [logserv]
       vmm: iocage_01
     http-1:
       class: [http, logclient]
       vmm: iocage_02
     db-1:
       class: [db, logclient]
       vmm: iocage_02
     http-2:
       class: [http, logclient]
       vmm: iocage_04
     db-2:
       class: [db, logclient]
       vmm: iocage_04

vmm dictionary
^^^^^^^^^^^^^^

The ``vmm`` dictionary groups jails under the hosts running them. Defining:

.. code-block:: yaml+jinja

   vmm: "{{ (project | vbotka.freebsd.project).vmm }}"

produces:

.. code-block:: yaml+jinja

   vmm:
     iocage_01:
       logserv-1:
         class: [logserv]
         vmm: iocage_01
     iocage_02:
       db-1:
         class: [db, logclient]
         vmm: iocage_02
       http-1:
         class: [http, logclient]
         vmm: iocage_02
     iocage_04:
       db-2:
         class: [db, logclient]
         vmm: iocage_04
       http-2:
         class: [http, logclient]
         vmm: iocage_04

class dictionary
^^^^^^^^^^^^^^^^

The ``class`` dictionary maps classes to their member jails. Defining:

.. code-block:: yaml+jinja

   class: "{{ (project | vbotka.freebsd.project).class }}"

produces:

.. code-block:: yaml

   class:
     db: [db-1, db-2]
     http: [http-1, http-2]
     logclient: [http-1, db-1, http-2, db-2]
     logserv: [logserv-1]
