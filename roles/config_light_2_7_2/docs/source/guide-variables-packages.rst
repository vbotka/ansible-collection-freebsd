.. _ug_variables_packages:

Packages
========

.. contents::
   :local:

Synopsis
^^^^^^^^

The dictionary *cl_packages* comprises managed packages (Linux or BSD) or BSD ports.

FreeBSD
"""""""

By default, packages will be installed. If you want to install ports set ::

  freebsd_install_method: ports

In this case, the default is to use packages ::

  freebsd_use_packages: true

See the variables *freebsd_pkgng_\** in :ref:`as_packages.yml`. There are no
defaults. If these variables are not defined the options are omitted. See the
module `community.general.pkgng`_. For example, disable *use_globs*
(*default=true*) if you want to use the packages in the form <pkg-origin> ::

  freebsd_pkgng_use_globs: false

.. seealso::

   `FreeBSD. Add option use_globs to the module pkgng. #8632`_


Enable *cached* packages (*default=false*) ::

  freebsd_pkgng_cached: true

This is especially useful when you install packages in jails from a host. For
example, ::

  freebsd_pkgng_delegate: iocage_host.example.com

In this case, you have to provide also *freebsd_pkgng_jail*.

.. hint::

   See the `examples in vbotka.freebsd`_

  
.. seealso::

   The defaults of the Ansible module `community.general.pkgng`_
  
snap
""""

By default snap packages won't be installed or uninstalled if *snap* binary can't be found in
``cl_snap_paths``. If you want the role to fail when *snap* is missing set ::

  cl_snap_missing_fatal: true

The variables *cl_snap_missing_fatal, cl_snap_paths, cl_snap_patterns* are declared in
``defaults/main.yml``.

Parameters
^^^^^^^^^^

.. list-table::
   :widths: 20 20 50
   :header-rows: 1

   * - Parameter
     - Type
     - Comments
   * - name
     - list ``required``
     - List of packages or BSD ports
   * - module
     - string
     - | Ansible module to manage packages.
       | choices: package, apt, yum, snap, pkgng
       | (default=package)
   * - state
     - string
     - | State of packages or BSD ports
       | (default=present)
   * - .
     - .
     - <TBD: see tasks/packages.yml>

Examples
^^^^^^^^

FreeBSD install Postfix package or port
"""""""""""""""""""""""""""""""""""""""

[`contrib/postfix/conf-light/packages.d/postfix.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/postfix/conf-light/packages.d/postfix.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/postfix/conf-light/packages.d/postfix.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

Armbian package for Simple SMTP
"""""""""""""""""""""""""""""""

[`contrib/ssmtp/conf-light/packages.d/ssmtp.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ssmtp/conf-light/packages.d/ssmtp.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ssmtp/conf-light/packages.d/ssmtp.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

Ubuntu delete snap packages
"""""""""""""""""""""""""""

[`contrib/ubuntu-snap-disable/conf-light/packages.d/snap-deinstall.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ubuntu-snap-disable/conf-light/packages.d/snap-deinstall.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ubuntu-snap-disable/conf-light/packages.d/snap-deinstall.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:


Ubuntu purge snapd package
""""""""""""""""""""""""""

[`contrib/ubuntu-snap-disable/conf-light/packages.d/snapd.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ubuntu-snap-disable/conf-light/packages.d/snapd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ubuntu-snap-disable/conf-light/packages.d/snapd.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

.. seealso::

   * :ref:`as_vars-packages.yml`
   * :ref:`as_packages.yml`


.. _community.general.pkgng: https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html
.. _examples in vbotka.freebsd: https://ansible-collection-freebsd.readthedocs.io/en/stable/ug_examples.html
.. _FreeBSD. Add option use_globs to the module pkgng. #8632: https://github.com/ansible-collections/community.general/issues/8632
