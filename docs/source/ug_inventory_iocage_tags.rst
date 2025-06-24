Tags
^^^^

Quoting `man iocage`_:

.. code-block:: text

   PROPERTIES
   ...
   notes="any string"
         Custom notes for miscellaneous tagging.
         Default: none
         Source: local

We will use the format ``notes="tag1=value1 tag2=value2 ..."``.

.. note:: The iocage tags have nothing to do with the `Ansible tags`_.

As root at the iocage host, set the jails' ``notes``. For example,

.. code-block:: console
   :emphasize-lines: 1,3,5

   shell> iocage set notes="vmm=iocage_02 project=foo" srv_1
   notes: none -> vmm=iocage_02 project=foo
   shell> iocage set notes="vmm=iocage_02 project=foo" srv_2
   notes: none -> vmm=iocage_02 project=foo
   shell> iocage set notes="vmm=iocage_02 project=bar" srv_3
   notes: none -> vmm=iocage_02 project=bar

Update the inventory configuration ``hosts/02_iocage.yml``. Compose the dictionary ``iocage_tags``
and create groups. The properties are required. Enable the parameter ``get_properties``

.. code-block:: yaml+jinja
   :emphasize-lines: 4,9

   plugin: vbotka.freebsd.iocage
   host: 10.1.0.73
   user: admin
   get_properties: true
   hooks_results:
     - /var/db/dhclient-hook.address.epair0b
   compose:
     ansible_host: (iocage_hooks.0 == '-') | ternary(iocage_ip4, iocage_hooks.0)
     iocage_tags: dict(iocage_properties.notes | split | map('split', '='))
   keyed_groups:
     - prefix: vmm
       key: iocage_tags.vmm
     - prefix: project
       key: iocage_tags.project

Display tags and groups. Create the playbook ``pb-test-groups.yml``

.. code-block:: yaml+jinja

   - hosts: all
     remote_user: admin

     vars:

       ansible_python_interpreter: auto_silent

     tasks:

       - debug:
           var: iocage_tags

       - debug:
           msg: |
             {% for group in groups %}
             {{ group }}: {{ groups[group] }}
             {% endfor %}
         run_once: true

Run the playbook

.. code-block:: console

   (env) > ansible-playbook -i hosts/02_iocage.yml pb-test-groups.yml

.. code-block:: yaml
   :force:

   PLAY [all] **********************************************************************************************************

   TASK [debug] ********************************************************************************************************
   ok: [srv_1] =>
       iocage_tags:
           project: foo
           vmm: iocage_02
   ok: [srv_2] =>
       iocage_tags:
           project: foo
           vmm: iocage_02
   ok: [srv_3] =>
       iocage_tags:
           project: bar
           vmm: iocage_02

   TASK [debug] ********************************************************************************************************
   ok: [srv_1] =>
       msg: |-
           all: ['srv_1', 'srv_2', 'srv_3']
           ungrouped: []
           vmm_iocage_02: ['srv_1', 'srv_2', 'srv_3']
           project_foo: ['srv_1', 'srv_2']
           project_bar: ['srv_3']

   PLAY RECAP **********************************************************************************************************
   srv_1                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_2                      : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
   srv_3                      : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


.. _man iocage: https://man.freebsd.org/cgi/man.cgi?query=iocage>
.. _Ansible tags: https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html
