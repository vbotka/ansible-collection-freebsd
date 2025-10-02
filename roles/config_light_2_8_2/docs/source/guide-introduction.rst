.. _ug_introduction:

Introduction
************

* Ansible role: `config_light`_
* Supported systems: `FreeBSD`_, `Ubuntu`_
* Requirements: `ansible.posix`_, `community.general`_, `vbotka.freebsd`_

The role installs packages, creates and configures files and services. The
handlers are created from user-provided data. The user-provided configuration
data determines the control flow. Some attributes of the dictionaries determine
which Ansible module will be used. This `data-driven programming`_ paradigm
provides a flexible and robust framework to apply basic Ansible modules. Each
Ansible module is used only once in the code. This makes the modules'
implementation, upgrading, and testing simple and easy.

The user of this role is expected to master at least the following Ansible
topics:

* `Basic Concepts`_
* `Roles`_
* `Working With Playbooks`_

The supported OS (FreeBSD and Ubuntu) can use the role to install and configure
arbitrary applications. The other Linux distributions that support the used
Ansible modules should work with minimal changes. BSD*, Debian, and Red Hat
*ansible_os_family* should work out of the box.

There are four imported tasks in the first part of the role to setup handlers,
assemble, test, and display the configuration data: ::

  tasks     description                  tags               enabled (default)
  ___________________________________________________________________________
  setup     create handlers              cl_setup           cl_setup=true
  vars      assemble configuration data  cl_vars, always
  sanity    test sanity                  cl_sanity          cl_sanity=true
  debug     display configuration data   cl_debug           cl_debug=false


Next, there are four imported tasks to manage the systems: ::

  tasks     description                  tags               enabled (default)
  ___________________________________________________________________________
  packages  install packages             cl_packages        cl_install=true
  states    modify states of files       cl_states
  files     configure files              cl_files
  services  configure services           cl_services


* packages: The Ansible modules ``package``, ``apt``, ``dnf``, and
  ``snap`` are used to install Linux packages. In FreeBSD, modules
  ``pkgng`` and ``portinstall`` are used to install FreeBSD packages
  and ports.

* states: The Ansible module ``mount`` is used to mount and unmount paths, and
  to configure *fstab*. The module ``file`` is used to modify `states`_ of
  files.

* files: The Ansible modules ``blockinfile``, ``copy``, ``ini_file``,
  ``lineinfile``, ``patch``, ``replace``, ``sysrc``, ``template``, and ``ucl``
  are used to configure files.

* services:

  * The module `ansible.builtin.service`_ is used to control Linux services.
  * The module `vbotka.freebsd.service`_ is used to control BSD services.

.. note::

   For backward compatibility use ``yum`` instead of ``dnf`` in the
   configuration. For example

   .. code:: yaml

      shell> cat conf-light/packages.d/lighttpd.yml
      lighttpd:
        module: yum
        name:
          - lighttpd

   The module ``ansible.builtin.dnf`` will be used. See :ref:`as_packages.yml`

.. seealso::

   * The directory `contrib`_ comprises examples of installation and configuration of various
     applications. Some of them are commented :ref:`ex`.

   * The ``User's Guide -> Examples`` in the `documentation vbotka.freebsd`_. Search
     ``vbotka.freebsd.config_light``, ``vbotka.freebsd.service``, and ``vbotka.freebsd.ucl`` in the
     ``Index``.

.. hint::

   Feel free to `share your feedback and report issues`_. The contributions to
   the `project`_ are welcome.


.. _project: https://github.com/vbotka/ansible-config-light/
.. _config_light: https://galaxy.ansible.com/vbotka/config_light/
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/
.. _documentation vbotka.freebsd: https://ansible-collection-freebsd.readthedocs.io/en/latest/

.. _FreeBSD: https://www.freebsd.org/releases/
.. _Ubuntu: http://releases.ubuntu.com/

.. _ansible.posix: https://github.com/ansible-collections/ansible.posix/
.. _community.general: https://github.com/ansible-collections/community.general

.. _data-driven programming: https://en.wikipedia.org/wiki/Data-driven_programming

.. _Basic Concepts: https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.html
.. _Roles: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
.. _Working With Playbooks: https://docs.ansible.com/ansible/latest/user_guide/playbooks.html

.. _states: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html#parameter-state
.. _ansible.builtin.service: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
.. _vbotka.freebsd.service: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/

.. _share your feedback and report issues: https://github.com/vbotka/ansible-config-light/issues/
.. _contrib: https://github.com/vbotka/ansible-config-light/blob/master/contrib/
