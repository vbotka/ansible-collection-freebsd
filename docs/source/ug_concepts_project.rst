.. _ug_concepts_project:

Project
-------

.. index:: single: variable project; project
.. index:: single: project; project
.. index:: single: variable vmm; project
.. index:: single: vmm; project
.. index:: single: variable class; project
.. index:: single: class; project

.. contents::
   :local:
   :depth: 2

Dictionary project
^^^^^^^^^^^^^^^^^^

The ``project`` variable is a dictionary of jails. The ``vmm`` attribute stores
the host on which the jail is running.

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

Dictionary vmm
^^^^^^^^^^^^^^

Declare ``vmm`` as a dictionary of hosts running the jails.

.. code-block:: yaml

   vmm_groups: "{{ dict(project | dict2items | groupby('value.vmm')) }}"
   vmm: "{{ dict(vmm_groups.keys() | zip(vmm_groups.values() | map('items2dict'))) }}"

gives

.. code-block:: yaml

   vmm:
     iocage_01:
       logserv_1:
         class:
         - logserv
         vmm: iocage_01
     iocage_02:
       db_1:
         class:
         - db
         - logclient
         vmm: iocage_02
       http_1:
         class:
         - http
         - logclient
         vmm: iocage_02
     iocage_04:
       db_2:
         class:
         - db
         - logclient
         vmm: iocage_04
       http_2:
         class:
         - http
         - logclient
         vmm: iocage_04

Dictionary class
^^^^^^^^^^^^^^^^

Declare ``class`` as a dictionary mapping classes to their members.

.. code-block:: yaml
   
   class_list: "{{ project | dict2items }}"
   class_keys: "{{ class_list | map(attribute='value.class') | flatten | unique | sort }}"
   class: |
     {% filter from_yaml %}
     {% for k in class_keys %}
     {{ k }}: {{ class_list | selectattr('value.class', 'contains', k) | map(attribute='key') }}
     {% endfor %}
     {% endfilter %}

gives

.. code-block:: yaml

   class:
     db:
     - db_1
     - db_2
     http:
     - http_1
     - http_2
     logclient:
     - http_1
     - db_1
     - http_2
     - db_2
     logserv:
     - logserv_1
