.. _example_340:

340 Role vbotka.freebsd.config_light
------------------------------------

.. contents::
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.config_light; Example 340
.. index:: single: vbotka.freebsd.config_light; Example 340
.. index:: single: lighttpd; Example 340

Use case
^^^^^^^^

Create 3 jails (Ansible clients) at iocage host. Install and configure `lighttpd`_ in Ansible
clients using the role `vbotka.freebsd.config_light`_.

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
  │   ├── 02_iocage.yml
  │   └── 99_constructed.yml
  ├── host_vars
  │   ├── iocage_01
  │   │   └── iocage.yml
  │   └── iocage_02
  │       └── iocage.yml
  ├── iocage.ini
  └── pb.yml

Synopsis
^^^^^^^^

In the playbook:

* `vbotka.freebsd.pb_iocage_ansible_clients.yml`_ create and start jails.
* `vbotka.freebsd.pb_iocage_update_repos.yml`_ update repositories.
* ``pb.yml`` at the jails, install and configure `lighttpd`_.

Requirements
^^^^^^^^^^^^

* Templates created in :ref:`example_205`

Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module `community.general.pkgng`_ if the
  jail was created by ``iocage``. Use JID instead ::

    freebsd_pkgng_jail: "{{ iocage_jid }}"

* The play ``pb.yml` runs in the jails. The inventory ``iocage.ini`` is needed when a task is
  delegated to an iocage host ::

    freebsd_pkgng_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_ ::

    freebsd_pkgng_use_globs: false

  to use the packages in the form `pkg-origin`_ ::

    lighttpd:
      module: pkgng
      name:
        - www/lighttpd

* The playbook `vbotka.freebsd.pb_iocage_update_repos.yml`_ updates the repositories. Then, use the
  `cached`_ local package base instead of fetching an updated one ::

    freebsd_pkgng_cached: true

* The directories ``handlers``, ``setup``, and ``files`` are group-writable ::

    cl_dird_group: adm
    cl_dird_dmode: "0770"
    cl_dira_group: adm
    cl_dira_dmode: "0770"
    cl_dira_fmode: "0660"
    cl_handlers_dir_group: adm

  The user running the plays must be a member of the group ``adm`` ::

    shell> > groups admin
    admin : admin adm dialout

  Fit the ownership and permissions in ``cl-common.yml`` to your needs.
    
.. seealso::

   * documentation `Ansible role Config Light`_
   * module `community.general.pkgng`_

ansible.cfg
^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
   :language: ini

Inventory iocage.ini
^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage.ini
   :language: ini

group_vars
^^^^^^^^^^

.. literalinclude:: group_vars/all/ansible-client.yml
   :language: yaml
   :caption:
.. literalinclude:: group_vars/all/cl-common.yml
   :language: yaml
   :caption:
.. literalinclude:: group_vars/all/cl-lighttpd.yml
   :language: yaml
   :caption:
.. literalinclude:: group_vars/all/common.yml
   :language: yaml
   :caption:

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/iocage_01/iocage.yml
   :language: yaml
   :caption:

.. literalinclude:: host_vars/iocage_02/iocage.yml
   :language: yaml
   :caption:

Create and start jails
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook vbotka.freebsd.pb_iocage_ansible_clients.yml \
                            -i iocage.ini \
                            -l iocage_02 \
                            -t swarm \
                            -e swarm=true

.. literalinclude:: out/out-11.txt
   :language: bash

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   [iocage_02]# iocage list -l

.. literalinclude:: out/out-01.txt
   :language: bash

Inventory hosts
^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
   :language: yaml
   :caption:
.. literalinclude:: hosts/99_constructed.yml
   :language: yaml
   :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-inventory -i hosts -i iocage.ini --graph

.. literalinclude:: out/out-02.txt
   :language: bash

Update repos
^^^^^^^^^^^^

.. code-block:: console

   ansible-playbook vbotka.freebsd.pb_iocage_update_repos.yml -i iocage.ini -l iocage_02

.. literalinclude:: out/out-12.txt
   :language: yaml
   :force:

Configuration conf-light
^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: conf-light/files.d/lighttpd-index.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/files.d/lighttpd-lighttpd-annotated-conf.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/files.d/lighttpd-lighttpd-conf.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/handlers.d/lighttpd-freebsd.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/packages.d/lighttpd.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/services.d/lighttpd.yml
   :language: yaml
   :caption:
.. literalinclude:: conf-light/states.d/lighttpd-server-document-root.yml
   :language: yaml
   :caption:

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
   :language: yaml

Playbook output - setup
^^^^^^^^^^^^^^^^^^^^^^^

Assemble data and create handlers.

.. code-block:: console

   (env) > ansible-playbook pb.yml -i hosts -t cl_setup -e cl_setup=true

.. literalinclude:: out/out-03.txt
   :language: yaml
   :force:

Playbook output - install and configure lighttpd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory ``iocage.ini`` is needed to delegate the tasks 'Manage FreeBSD packages' from the
jails to their iocage hosts.

.. code-block:: console

   (env) > ansible-playbook pb.yml -i hosts -i iocage.ini

.. literalinclude:: out/out-10.txt
   :language: yaml
   :force:

Results
^^^^^^^

Open the page in a browser. For example, http://10.1.0.111/. The content should be ::

  Lighttpd works!

.. note::

   The role and the configuration data in the examples are idempotent. Once the application is
   installed and configured, ansible-playbook shouldn’t report any changes. To speedup the playbook,
   disable setup, sanity, debug, and install. This way, the role will audit the required
   infrastructure ::

     (env) > ansible-playbook pb.yml -i hosts

   Optionally, do not display OK hosts. See `display_ok_hosts`_ ::

     (env) > ANSIBLE_DISPLAY_OK_HOSTS=false ansible-playbook pb.yml -i hosts

     PLAY [Test role vbotka.freebsd.config_light] **************************************************

     TASK [vbotka.config_light : Files: Manage files.] *********************************************

         ...

     PLAY RECAP ************************************************************************************
     0ed0d0ca: ok=32   changed=0    unreachable=0    failed=0    skipped=91   rescued=0    ignored=0
     59a3f932: ok=32   changed=0    unreachable=0    failed=0    skipped=69   rescued=0    ignored=0
     test_111: ok=32   changed=0    unreachable=0    failed=0    skipped=69   rescued=0    ignored=0

     
.. _lighttpd: https://www.lighttpd.net/
.. _Ansible role Config Light: https://ansible-config-light.readthedocs.io/en/latest/index.html

.. _vbotka.freebsd.config_light: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light/
.. _vbotka.config_light: https://galaxy.ansible.com/ui/standalone/roles/vbotka/config_light/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/

.. _vbotka.freebsd.pb_iocage_ansible_clients.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_ansible_clients.yml
.. _vbotka.freebsd.pb_iocage_update_repos.yml: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/playbook/pb_iocage_update_repos.yml

.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _cached: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-cached
.. _use_globs: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
.. _pkg-origin: https://man.freebsd.org/cgi/man.cgi?query=pkg-install
