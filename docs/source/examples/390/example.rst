.. _example_390:

390 Build packages amd64
------------------------

.. contents:: Table of Contents
   :local:
   :depth: 1

.. index:: single: role vbotka.freebsd.poudriere; Example 390
.. index:: single: vbotka.freebsd.poudriere; Example 390
.. index:: single: Poudriere; Example 390

Use case
^^^^^^^^

Use the role `vbotka.freebsd.poudriere`_ to build packages.

Tree
^^^^

::

  shell> tree .
  .
  ├── ansible.cfg
  ├── host_vars
  │   └── build.example.com
  │       ├── pkg_dict.yml
  │       └── poudriere.yml
  └── pb.yml

Synopsis
^^^^^^^^

* Use the playbook *pb.yml* at *build.example.com* to build arm packages.
    
Requirements
^^^^^^^^^^^^

* root privilege on the *build.example.com*.

Notes
^^^^^

TBD

.. note::

   | `vbotka.freebsd.poudriere`_ is the role **poudriere** in the collection `vbotka.freebsd`_.
   | `vbotka.freebsd_poudriere`_ is the role **freebsd_poudriere** in the namespace `vbotka`_.
   | Please make sure the versions are the same before you switch between them.

.. seealso::

   * `Building Packages with Poudriere`_

Configuration ansible.cfg
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory build-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: build-hosts.ini
    :language: ini

host_vars
^^^^^^^^^

.. literalinclude:: host_vars/build.example.com/poudriere.yml
    :language: yaml
    :caption: host_vars/build.example.com/poudriere.yml

.. literalinclude:: host_vars/build.example.com/pkg_dict.yml
    :language: yaml
    :caption: host_vars/build.example.com/pkg_dict.yml

Playbook pb.yml
^^^^^^^^^^^^^^^

.. literalinclude:: pb.yml
    :language: yaml

Playbook output - debug
^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_debug \
                                  -e poudriere_debug=true

.. literalinclude:: out/out-01.txt
    :language: bash

Playbook output - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkg \
                                  -e poudriere_install=true

.. literalinclude:: out/out-02.txt
    :language: bash

Playbook output - create SSL directories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_dirs

.. literalinclude:: out/out-03.txt
    :language: bash

Result
^^^^^^

     
.. _vbotka.freebsd.poudriere: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/poudriere
.. _vbotka.freebsd_poudriere: https://galaxy.ansible.com/ui/standalone/roles/vbotka/freebsd_poudriere
.. _vbotka.freebsd: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd
.. _vbotka: https://galaxy.ansible.com/ui/standalone/namespaces/7289

.. _Building Packages with Poudriere: https://docs.freebsd.org/en_US.ISO8859-1/books/handbook/ports-poudriere.html
