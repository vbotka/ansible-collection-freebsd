.. _example_313:

313 Role vbotka.freebsd.config_light
------------------------------------

.. contents:: Table of Contents
   :depth: 2

.. index:: single: role vbotka.freebsd.config_light; Example 313
.. index:: single: vbotka.freebsd.config_light; Example 313
.. index:: single: lighttpd; Example 313


Use case
^^^^^^^^

Install and configure `lighttpd`_ in Ansible clients using the role
`vbotka.freebsd.config_light`_


Tree
^^^^

.. code:: bash

   shell> tree .
   .
   ├── ansible.cfg
   ├── conf-light/
   │   ├── files.d
   │   │   ├── lighttpd-index.yml
   │   │   ├── lighttpd-lighttpdconf.yml
   │   │   └── lighttpd-rcconf.yml
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
   │       ├── cl-common.yml
   │       ├── cl-lighttpd.yml
   │       └── common.yml
   ├── hosts
   │   ├── 02_iocage.yml
   │   └── 99_constructed.yml
   ├── iocage-hosts.ini
   └── pb.yml


Synopsis
^^^^^^^^

In the playbook pb.yml at the jails install and configure `lighttpd`_.


Requirements
^^^^^^^^^^^^

* Running jails at the iocage host.

* Updated FreeBSD repository catalogue. See the playbook *pb-pkg-update.yml* in :ref:`example_311`


Notes
^^^^^

* Jail name doesn't work in the parameter `name`_ of the module
  `community.general.pkgng`_ if the jail was created by *iocage*. Use JID
  instead ::

    freebsd_pkgng_jail: "{{ iocage_jid }}"

* The play *pb.yml* runs at the jails. The inventory *iocage-hosts.ini* is
  needed when a task is delegated to an iocage host ::

    freebsd_pkgng_delegate: "{{ iocage_tags.vmm }}"

* Disable `use_globs`_ ::

    freebsd_pkgng_use_globs: false

  to use the packages in the form `pkg-origin`_ ::

    lighttpd:
      module: pkgng
      name:
        - www/lighttpd

* The playbook *pb-pkg-update.yml* in :ref:`example_311` updates the
  repositories. Use the `cached`_ local package base instead of fetching an
  updated one ::

    freebsd_pkgng_cached: true

* The *handlers* and *setup* directories, and files are group-writable ::

    cl_dird_group: adm
    cl_dird_dmode: "0770"
    cl_dira_group: adm
    cl_dira_dmode: "0770"
    cl_dira_fmode: "0660"
    cl_handlers_dir_group: adm

  The user running the plays must be a member of the group *adm* ::

    shell> > groups admin
    admin : admin adm dialout

  Fit the ownership and permissions in *cl-common.yml* to your needs.
    
.. seealso::

   * documentation `Ansible role Config Light`_
   * module `community.general.pkgng`_

List jails at iocage_02
^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash


Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

Do not display skipped hosts. See the option `display_skipped_hosts`_

.. literalinclude:: ansible.cfg
    :language: ini
    :caption:

Configuration group_vars/all/
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: group_vars/all/common.yml
    :language: yaml
    :caption:
.. literalinclude:: group_vars/all/cl-common.yml
    :language: yaml
    :caption:
.. literalinclude:: group_vars/all/cl-lighttpd.yml
    :language: yaml
    :caption:

Configuration conf-light/
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: conf-light/files.d/lighttpd-index.yml
    :language: yaml
    :caption:
.. literalinclude:: conf-light/files.d/lighttpd-lighttpdconf.yml
    :language: yaml
    :caption:
.. literalinclude:: conf-light/files.d/lighttpd-rcconf.yml
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

Inventory hosts/
^^^^^^^^^^^^^^^^

.. literalinclude:: hosts/02_iocage.yml
    :language: ini
    :caption:
.. literalinclude:: hosts/99_constructed.yml
    :language: ini
    :caption:

Display inventory
^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
    :language: yaml
    :caption:


Playbook output. Setup.
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -t cl_setup -e cl_setup=true

.. literalinclude:: out/out-04.txt
    :language: yaml

.. note::

   * The tasks *vars* are tagged ``always``

Playbook output. Sanity.
^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -t cl_sanity -e cl_sanity=true

.. literalinclude:: out/out-05.txt
    :language: yaml

Playbook output. Debug.
^^^^^^^^^^^^^^^^^^^^^^^

Enable debug and limit the inventory to one jail *test_111*. The
repeated output of *Vars-\** was removed.

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -l test_111 -t cl_debug -e cl_debug=true

.. literalinclude:: out/out-06.txt
    :language: yaml


Playbook output. Install packages.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The inventory *iocage-hosts.ini* is needed to delegate the tasks
'Manage FreeBSD packages' to the iocage hosts.

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -i iocage-hosts.ini -t cl_packages -e cl_install=true

.. literalinclude:: out/out-07.txt
    :language: yaml


Playbook output. Files states.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -t cl_states

.. literalinclude:: out/out-08.txt
    :language: yaml


Playbook output. Files.
^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -t cl_files

.. literalinclude:: out/out-09.txt
    :language: yaml


Playbook output. Services.
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   (env) > ansible-playbook pb.yml -i hosts -t cl_services

.. literalinclude:: out/out-10.txt
    :language: yaml


Results
^^^^^^^

Open the page in a browser. For example, http://10.1.0.111/. The content should be ::

  Lighttpd works!

.. hint::

   If you know what you are doing skip the above selection of particular tags
   and run the complete role at once ::

     (env) > ansible-playbook pb.yml -i hosts -i iocage-hosts.ini \
                                     -e cl_setup=true -e cl_sanity=true -e cl_install=true

.. note::

   The role and the configuration data in the examples are idempotent. Once the
   application is installed and configured ansible-playbook shouldn’t report any
   changes. To speedup the playbook disable setup, sanity, debug, and
   install. This way, the role will audit the required infrastructure ::

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
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289/
.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _name: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-name
.. _cached: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-cached
.. _use_globs: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs
.. _display_ok_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_ok_hosts
.. _display_skipped_hosts: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/default_callback.html#parameter-display_skipped_hosts
.. _pkg-origin: https://man.freebsd.org/cgi/man.cgi?query=pkg-install
