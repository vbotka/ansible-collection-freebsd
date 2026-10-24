.. _example_340:

340 Role vbotka.freebsd.config_light
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index::
   single: lighttpd; Example 340
   single: swarms; Example 340
   single: pb_iocage_ansible_clients.yml; Example 340
   single: role vbotka.freebsd.config_light; Example 340
   single: vbotka.freebsd.config_light; Example 340

Use case
^^^^^^^^

Use the role `vbotka.freebsd.config_light`_ to install and configure `lighttpd`_.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── conf-light
  │   ├── files.d
  │   │   ├── lighttpd-index.yml
  │   │   ├── lighttpd-lighttpd-annotated-conf.yml
  │   │   └── lighttpd-lighttpd-conf.yml
  │   ├── handlers.d
  │   │   └── lighttpd-freebsd.yml
  │   ├── packages.d
  │   │   └── lighttpd.yml
  │   ├── services.d
  │   │   └── lighttpd.yml
  │   └── states.d
  │       └── lighttpd-server-document-root.yml
  ├── group_vars
  │   └── all
  │       ├── ansible-client.yml
  │       ├── cl-common.yml
  │       ├── cl-lighttpd.yml
  │       └── common.yml
  ├── hosts
  │   ├── 06_iocage2.yml
  │   └── 99_constructed.yml
  ├── iocage.ini
  ├── pb-test.yml
  └── pb.yml

Synopsis
^^^^^^^^

* On the managed nodes:

  * In the playbook :ref:`ug_pb-iocage-ansible-clients`, create and start jails.

  * In the playbook :ref:`ug_pb-iocage-update-repos`, update repositories.

  * In the playbook ``pb-test.yml``, display the status of the `lighttpd`_
    service.

* On all created jails in the group ``swarm_sw_01``:

  * In the playbook ``pb.yml``, install and configure `lighttpd`_.

Requirements
^^^^^^^^^^^^

* Playbook :ref:`ug_pb-iocage-ansible-clients`
* Playbook :ref:`ug_pb-iocage-update-repos`
* Role `vbotka.freebsd.config_light`_
* :ref:`ug_connection_jailexec`
* Template ``ansible-client`` created in :ref:`example_202`

Notes
^^^^^

* Jail names created by ``iocage`` do not work in the `jail parameter`_ of the
  module `community.general.pkgng`_. Use the JID instead::

    freebsd_pkgng_jail: "{{ iocage_jid }}"

* The play ``pb.yml`` runs inside the jails. The inventory ``iocage.ini`` is
  needed when a task is delegated to an iocage host::

    freebsd_pkgng_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_::

    freebsd_pkgng_use_globs: false

  to specify packages in `pkg-origin`_ format::

    lighttpd:
      module: pkgng
      name:
        - www/lighttpd

* The playbook :ref:`ug_pb-iocage-update-repos` updates the
  repositories. Afterwards, use the `cached`_ local package database instead of
  fetching an updated one::

    freebsd_pkgng_cached: true

* The directories ``handlers``, ``setup``, and ``files`` are group-writable::

    cl_dird_group: adm
    cl_dird_dmode: "0770"
    cl_dira_group: adm
    cl_dira_dmode: "0770"
    cl_dira_fmode: "0660"
    cl_handlers_dir_group: adm

  The user running the plays must be a member of the group ``adm``::

    shell> groups admin
    admin : admin adm dialout

  Adjust the ownership and permissions in ``cl-common.yml`` to your needs.

.. seealso::

   * `Ansible role Config Light`_
   * Module `community.general.pkgng`_
   * :ref:`ug_qa_jexec_iocage_name`

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

.. literalinclude:: hosts/06_iocage2.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: hosts/99_constructed.yml
   :language: yaml+jinja
   :caption:

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/cl-common.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/cl-lighttpd.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: group_vars/all/common.yml
   :language: yaml+jinja
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini \
                            -t swarm -e swarm=true \
                            -e iocage_jails_source=inventory \
                            vbotka.freebsd.pb_iocage_ansible_clients.yml

.. literalinclude:: out/out-01.txt
   :language: bash

Graph
^^^^^

.. literalinclude:: out/out-02.txt
   :language: bash
   :caption: (env) > ansible-inventory -i hosts -i iocage.ini --graph

Jails
^^^^^

.. literalinclude:: out/out-03.txt
   :language: bash
   :caption: [iocage_06]# iocage list -l

Update repos
^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i iocage.ini vbotka.freebsd.pb_iocage_update_repos.yml

.. literalinclude:: out/out-04.txt
   :language: yaml+jinja
   :force:

Configuration conf-light
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: conf-light/files.d/lighttpd-index.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/files.d/lighttpd-lighttpd-annotated-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/files.d/lighttpd-lighttpd-conf.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/handlers.d/lighttpd-freebsd.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/packages.d/lighttpd.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/services.d/lighttpd.yml
   :language: yaml+jinja
   :caption:

.. literalinclude:: conf-light/states.d/lighttpd-server-document-root.yml
   :language: yaml+jinja
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml+jinja

Playbook output - Setup
^^^^^^^^^^^^^^^^^^^^^^^

Assemble data and create handlers.

.. code-block:: console

   (env) > ansible-playbook -i hosts \
                            -t cl_setup -e cl_setup=true \
                            pb.yml

.. literalinclude:: out/out-05.txt
   :language: yaml+jinja
   :force:

Playbook output - Install and configure lighttpd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the tasks "Manage
FreeBSD packages" from the jails to their iocage hosts.

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb.yml

.. literalinclude:: out/out-06.txt
   :language: yaml+jinja
   :force:

Playbook pb-test.yml
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-test.yml
   :language: yaml+jinja

Playbook output - Display lighttpd status
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -i hosts -i iocage.ini pb-test.yml

.. literalinclude:: out/out-07.txt
   :language: yaml+jinja
   :force:

Results
^^^^^^^

Open the page in a browser, for example, ``http://10.1.0.111/``. The
content should be::

  Lighttpd works!

.. note::

   The role and configuration data in the examples are
   idempotent. Once the application is installed and configured,
   ``ansible-playbook`` should not report any changes. To speed up the
   playbook, disable setup, sanity, debug, and install. This way, the
   role will audit the required infrastructure::

     (env) > ansible-playbook -i hosts pb.yml

   Optionally, do not display ``OK`` hosts. See `display_ok_hosts`_::

     (env) > ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook -i hosts pb.yml

     PLAY [Test role vbotka.freebsd.config_light] **************************************************

     TASK [vbotka.config_light : Files: Manage files.] *********************************************

         ...

     PLAY RECAP ************************************************************************************
     0ed0d0ca: ok=32    changed=0    unreachable=0    failed=0    skipped=91   rescued=0    ignored=0
     59a3f932: ok=32    changed=0    unreachable=0    failed=0    skipped=69   rescued=0    ignored=0
     test_111: ok=32    changed=0    unreachable=0    failed=0    skipped=69   rescued=0    ignored=0
