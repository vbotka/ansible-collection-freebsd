.. _ug_concepts_ansible_init:

Service ansible_init
--------------------

.. index:: single: ansible_init; Service ansible_init
.. index:: single: service ansible_init; Service ansible_init
.. index:: single: ansible-conf-init-example; Service ansible_init
.. index:: single: ansible-conf-test; Service ansible_init

.. contents::
   :local:
   :depth: 2

Introduction
^^^^^^^^^^^^

`ansible_init`_ is a lightweight, cloud-init style FreeBSD rc(8) initialization
service designed for unattended, automated configuration of freshly deployed
FreeBSD instances.

By leveraging the native FreeBSD ``firstboot`` framework and Ansible's pull
execution model (``ansible-pull``), this service eliminates the need for an
external orchestration server to push configuration changes. Instead, the newly
booted system configures itself locally.

High-level architecture
"""""""""""""""""""""""

The service coordinates the handover between system initialization and
configuration management::

  [ Provisioning Layer ] ──> Instance Boots ──> rc.d/ansible_init runs
                                                       │
                                                       ▼
                                         Clones Remote Git Repository
                                                       │
                                                       ▼
                                         Executes Playbook Locally
                                                       │
                                                       ▼
                                         [ System Fully Configured ]

* **Bootstrap Condition:** The script is flagged with the ``KEYWORD: firstboot``
  rc(8) setting. It triggers dynamically on systems where the marker file
  ``/firstboot`` exists in the root directory.

* **Execution Hook:** It delays the final multi-user runlevel sequence until the
  networking layer is available (``REQUIRE: NETWORKING``).

* **Local Execution:** Rather than requiring an open SSH port for an external
  control node, ``ansible_init`` pulls down your infrastructure-as-code repository
  via standard Git/HTTPS protocols, resolves variables locally, and executes the
  target playbooks against ``localhost``.

* **Self-Termination:** Upon successful execution, the underlying FreeBSD
  ``firstboot`` framework removes the ``/firstboot`` trigger file, ensuring the
  initialization tasks run exactly once during the lifecycle of the instance.

Example
^^^^^^^

This example demonstrates how to bootstrap a FreeBSD system within an isolated
provisioning network using a local Git daemon.

What This Example Accomplishes
""""""""""""""""""""""""""""""

1. Creates an infrastructure-as-code repository containing a custom Ansible
   configuration, inventory file, and example playbook.
2. Configures the host to export this repository over the lightweight,
   unauthenticated ``git://`` protocol.
3. Configures the ``ansible_init`` rc service to pull from that local repository.
4. On execution, ``ansible-pull`` clones the repository and runs a task that
   generates the file ``/tmp/ansible-hello-world.txt``.

Install Git and create local Git repository
"""""""""""""""""""""""""""""""""""""""""""

.. code-block:: console

   # ls -la /usr/local/git/ansible-conf-example/
   total 230
   drwxr-xr-x  3 git_daemon git_daemon   6 Jul  2 11:05 .
   drwxr-xr-x  7 git_daemon git_daemon   7 Jul  2 10:55 ..
   drwxr-xr-x  7 git_daemon git_daemon  12 Jul  2 11:07 .git
   -rw-r--r--  1 git_daemon git_daemon  65 Jul  2 10:59 ansible.cfg
   -rw-r--r--  1 git_daemon git_daemon  35 Jul  2 10:48 hosts
   -rw-r--r--  1 git_daemon git_daemon 211 Jul  2 10:48 pb-example.yml

.. seealso::

   The `Example`_ directory in the ``ansible_init`` repository.

Configure git_daemon in /etc/rc.conf and start it
"""""""""""""""""""""""""""""""""""""""""""""""""

.. code-block:: sh

   git_daemon_enable="YES"
   git_daemon_directory="/usr/local/git"
   git_daemon_flags="--syslog --base-path=/usr/local/git --export-all --reuseaddr --detach"

Configure ansible_init in /etc/rc.conf
""""""""""""""""""""""""""""""""""""""

.. code-block:: sh

   ansible_init_enable="YES"
   ansible_init_host="git://localhost"
   ansible_init_repo="ansible-conf-example"
   ansible_init_playbook="pb-example.yml"

Start ansible_init
""""""""""""""""""

.. code-block:: console

   # service ansible_init start

During execution, ``ansible-pull`` clones the repository into the local directory
``/root/ansible-conf-example`` and runs the playbook, creating
``/tmp/ansible-hello-world.txt``:

.. code-block:: console

   # cat /tmp/ansible-hello-world.txt
   [ansible-test] Hello world!

.. seealso::

   * Repository `ansible_init`_
   * Repository `ansible-conf-init-example`_
   * Repository `ansible-conf-test`_
   * Example :ref:`example_524`

.. warning::

   The ``git://`` protocol does not provide encryption or authentication. While
   suitable for fast local prototyping or isolated provisioning networks, use
   ``https://`` (or SSH) for ``ansible_init_host`` in production environments.


.. _ansible_init: https://github.com/vbotka/ansible_init/
.. _ansible-conf-init-example: https://github.com/vbotka/ansible-conf-init-example/
.. _Example: https://github.com/vbotka/ansible_init/tree/master/files/examples/
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test/
