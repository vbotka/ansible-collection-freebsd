.. _qg:

Quick start guide
#################

For users who want to try the role quickly, this guide provides an example of
how to install and configure `lighttpd`_ on a single FreeBSD host. The procedure
is generic and can be easily modified to install and configure other
applications on other systems. See examples in the directory *contrib*. The
control node of this example is Linux, and the user running the playbook on the
controller is a member of the group *adm*.

.. contents:: Table of Contents
   :local:

Install the role, collections, and linter
*****************************************

* Install the role ``vbotka.config_light`` ::

    shell> ansible-galaxy role install vbotka.config_light


* Install the collections if necessary ::

    shell> ansible-galaxy collection install ansible.posix
    shell> ansible-galaxy collection install community.general
    shell> ansible-galaxy collection install vbotka.freebsd


* Install ``yamllint`` to use the default validation of the created handlers and
  assembled data. See the variables *cl_assemble_validate* and
  *cl_handlers_validate* in *defaults/main.yml*. Optionally, use
  ``ansible-lint`` or disable the validation by clearing the variables ::

    cl_assemble_validate: ''
    cl_handlers_validate: ''

Create project
**************

* Create a project

.. code-block:: bash

    shell> tree .
    .
    ├── conf-light
    │   ├── files.d
    │   │   ├── lighttpd-index.yml
    │   │   ├── lighttpd-lighttpdconf.yml
    │   │   └── lighttpd-rcconf.yml
    │   ├── handlers.d
    │   │   └── lighttpd-freebsd.yml
    │   ├── packages.d
    │   │   └── lighttpd.yml
    │   ├── services.d
    │   │   └── lighttpd.yml
    │   └── states.d
    │       └── lighttpd-server-document-root.yml
    ├── group_vars
    │   └── all
    │       ├── cl-common.yml
    │       ├── cl-lighttpd.yml
    │       └── common.yml
    └── pb.yml

* Create the playbook ``pb.yml`` for single host *srv.example.com* (**1**) and
  the role *vbotka.config_light* (**10**)

.. code-block:: yaml
   :caption: pb.yml
   :linenos:
   :emphasize-lines: 1,10

   - hosts: srv.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: true
     become_user: root
     become_method: sudo

     roles:
       - vbotka.config_light

Configure role
**************

* Create common variables

.. code-block:: yaml
   :caption: group_vars/all/common.yml
   :linenos:

   freebsd_install_method: packages
   freebsd_pkgng_use_globs: false


* Configure the role. To speed up the execution, set the control-flow variables
  (**1-3**) to *false* and disable some steps. Enable these steps selectively
  when needed. The configuration data will be stored in the directory
  *conf-light* (**8**) in the current directory of the playbook. Set the
  ownership and permissions of the directories on the control node so that the
  user who is running the playbook will be able to both read and write the
  files, and create the directories *cl_dird*, *cl_dira*, and *"{{ role_path
  }}/handlers"*

.. code-block:: yaml
   :caption: host_vars/srv.example.com/cl-common.yml
   :emphasize-lines: 1-3,8
   :linenos:

   cl_sanity: false
   cl_setup: false
   cl_install: false
   cl_backup: true
   
   cl_dird_group: adm
   cl_dird_dmode: "0770"
   cl_dird: "{{ playbook_dir }}/conf-light"
   
   cl_dira_group: adm
   cl_dira_dmode: "0770"
   cl_dira_fmode: "0660"
   
   cl_handlers_dir_group: adm

.. note::

   * The configuration data will be assembled into the directory ``cl_dira``
   * The default value of ``cl_dira`` is ``"{{ cl_dird }}/assemble"``

Configure lighttpd
******************

* Configure the application. Start the server (**1**), run the server at boot
  (**2**), and configure two files (**4,17**)

.. code-block:: yaml
   :caption: host_vars/srv.example.com/cl-lighttpd.yml
   :emphasize-lines: 1,2,4,17
   :linenos:

   cl_service_lighttpd_enable: true
   cl_service_lighttpd_state: start

   # /usr/local/etc/lighttpd/lighttpd.conf
   cl_lighttpd_server_port: '80'
   cl_lighttpd_server_useipv6: disable
   cl_lighttpd_server_username: www
   cl_lighttpd_server_groupname: www
   cl_lighttpd_server_document_root: /usr/local/www/lighttpd
   cl_lighttpd_lighttpdconf_dict:
     - {key: server.port, value: '"{{ cl_lighttpd_server_port }}"'}
     - {key: server.use-ipv6, value: '"{{ cl_lighttpd_server_useipv6 }}"'}
     - {key: server.username, value: '"{{ cl_lighttpd_server_username }}"'}
     - {key: server.groupname, value: '"{{ cl_lighttpd_server_groupname }}"'}
     - {key: server.document-root, value: '"{{ cl_lighttpd_server_document_root }}"'}

   # /etc/rc.conf
   cl_lighttpd_rcconf_lighttpd_enable: 'YES'
   cl_lighttpd_rcconf_dict:
     - {key: lighttpd_enable, value: '"{{ cl_lighttpd_rcconf_lighttpd_enable }}"'}

* Create configuration data in the directory ``conf-light/``

.. code-block:: yaml
   :caption: conf-light/files.d/lighttpd-index.yml
   :emphasize-lines: 7

   lighttpd-index:
     path: "{{ cl_lighttpd_server_document_root }}/index.html"
     owner: "{{ cl_lighttpd_server_username }}"
     group: "{{ cl_lighttpd_server_groupname }}"
     create: true
     mode: "0644"
     lines:
       - line: Lighttpd works !

.. code-block:: yaml
   :caption: conf-light/files.d/lighttpd-lighttpdconf.yml
   :emphasize-lines: 8

   lighttpd-lighttpdconf:
     path: /usr/local/etc/lighttpd/lighttpd.conf
     create: true
     owner: root
     group: wheel
     mode: '0644'
     assignment: ' = '
     dict: "{{ cl_lighttpd_lighttpdconf_dict }}"
     handlers:
       - reload lighttpd

.. code-block:: yaml
   :caption: conf-light/files.d/lighttpd-rcconf.yml
   :emphasize-lines: 8

   lighttpd_rcconf:
     path: /etc/rc.conf
     create: true
     owner: root
     group: wheel
     mode: '0644'
     assignment: '='
     dict: "{{ cl_lighttpd_rcconf_dict }}"
     handlers:
       - reload lighttpd

.. code-block:: yaml
   :caption: conf-light/handlers.d/lighttpd-freebsd.yml
   :emphasize-lines: 6,13,20,29,38
   :linenos:

   lighttpd_freebsd:

     template: handlers-auto3.yml.j2
     handlers:

       - handler: Start lighttpd
         listen: start lighttpd
         module: vbotka.freebsd.service
         params:
           - 'script: lighttpd'
           - 'command: start'

       - handler: Stop lighttpd
         listen: stop lighttpd
         module: vbotka.freebsd.service
         params:
           - 'script: lighttpd'
           - 'command: stop'

       - handler: Reload lighttpd
         listen: reload lighttpd
         module: vbotka.freebsd.service
         params:
           - 'script: lighttpd'
           - 'command: reload'
         conditions:
           - '- cl_service_lighttpd_enable | bool'

       - handler: Restart lighttpd
         listen: restart lighttpd
         module: vbotka.freebsd.service
         params:
           - 'script: lighttpd'
           - 'command: restart'
         conditions:
           - '- cl_service_lighttpd_enable | bool'

       - handler: Lighttpd check
         listen: lighttpd check
         module: ansible.builtin.command
         params:
           - 'cmd: /usr/local/sbin/lighttpd -t'

.. code-block:: yaml
   :caption: conf-light/packages.d/lighttpd.yml
   :emphasize-lines: 2

   lighttpd:
     module: pkgng
     name:
       - www/lighttpd

.. code-block:: yaml
   :caption: conf-light/services.d/lighttpd.yml
   :emphasize-lines: 2

   lighttpd:
     name: lighttpd
     state: "{{ cl_service_lighttpd_state }}"
     enabled: "{{ cl_service_lighttpd_enable }}"

.. code-block:: yaml
   :caption: conf-light/states.d/lighttpd-server-document-root.yml
   :emphasize-lines: 2

   lighttpd_server_document_root:
     state: directory
     path: "{{ cl_lighttpd_server_document_root }}"
     owner: "{{ cl_lighttpd_server_username }}"
     group: "{{ cl_lighttpd_server_groupname }}"
     mode: '0750'

Setup
*****

* Select and enable setup. This command will assemble the configuration data and
  create handlers on the control node. Take a look at the directory
  ``conf-light/assemble/`` what files were created. Also, look at the directory
  ``roles/vbotka.config_light/handlers``, what handlers were created ::

   shell> ansible-playbook pb.yml -t cl_setup -e cl_setup=true

  .. note::

   * The tasks *vars* are tagged ``always``.

   * The tasks *setup* and *sanity* are enabled by default ``cl_setup=true,
     cl_sanity=true``.


* Enable and test sanity ::

    shell> ansible-playbook pb.yml -t cl_sanity -e cl_sanity=true


* Display variables ::

    shell> ansible-playbook pb.yml -t cl_debug -e cl_debug=true

Run the play
************

* Install packages ::

    shell> ansible-playbook pb.yml -t cl_packages -e cl_install=true


* Set files `state`_ ::

    shell> ansible-playbook pb.yml -t cl_states


* Create and modify files ::

    shell> ansible-playbook pb.yml -t cl_files


* Configure services ::

    shell> ansible-playbook pb.yml -t cl_services


.. hint::

   If you know what you are doing skip the above selection of particular
   tags and run the complete role at once ::

     shell> ansible-playbook pb.yml -e cl_setup=true -e cl_sanity=true -e cl_install=true

.. seealso::

   The collection `vbotka.freebsd examples`_.

.. note::

   The role and the configuration data in the examples are idempotent. Once
   the application is installed and configured *ansible-playbook* shouldn't
   report any changes. To speedup the playbook disable setup, sanity, debug,
   and install. This way, the role will audit the required infrastructure ::

     shell> ansible-playbook pb.yml

     [...]

     PLAY RECAP ***************************************************************************
     srv.example.com: ok=32 changed=0 unreachable=0 failed=0 skipped=91 rescued=0 ignored=0

Results
*******

* Open the page in a browser ``http://srv.example.com/``. The content should be ::

   Lighttpd works!


.. _lighttpd: https://www.lighttpd.net/
.. _vbotka.freebsd examples: file:///scratch/collections/ansible_collections/vbotka/freebsd/docs/build/html/ug_examples.html
.. _state: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html#parameter-state
