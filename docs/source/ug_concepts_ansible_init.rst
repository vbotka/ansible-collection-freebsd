.. _ug_concepts_ansible_init:

Service ansible_init
--------------------

.. index:: single: ansible_init; Concepts
.. index:: single: service ansible_init; Concepts
.. index:: single: ansible-conf-init-example; Concepts
.. index:: single: ansible-conf-test; Concepts

.. contents::
   :local:
   :depth: 2

Introduction
^^^^^^^^^^^^

`ansible_init`_ is a lightweight, cloud-init style FreeBSD rc(8) initialization
service designed for the unattended, automated configuration of freshly deployed
FreeBSD instances.

By leveraging the native FreeBSD ``firstboot`` framework and Ansible's pulling
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

Bootstrap Condition: The script is flagged with the "KEYWORD: firstboot" macro.
It triggers dynamically on systems where the marker file /firstboot exists in
the root directory.

Execution Hook: It blocks the final multi-user runlevel sequence until the
networking layer is available (REQUIRE: NETWORKING).

Local Compilation: Rather than exposing an open SSH port for an internal control
node, ansible_init pulls down your infrastructure-as-code repository via
standard Git/HTTPS channels, compiles variables locally, and executes the target
playbooks against localhost.

Self-Termination: Upon a successful complete execution, the underlying FreeBSD
firstboot framework removes the /firstboot trigger file, ensuring the
initialization tasks run exactly once in the lifecycle of the instance.

Example
^^^^^^^
This example demonstrates how to bootstrap a FreeBSD system within an isolated
provisioning network using a local Git daemon.

What This Example Accomplishes
""""""""""""""""""""""""""""""

1. It creates an infrastructure-as-code repository containing a custom Ansible
   configuration, inventory file, and an example playbook.
2. It configures the host to export this repository over the lightweight,
   unauthenticated git:// protocol.
3. It configures the ansible_init rc service to hook into that local repository.
4. Upon execution, ansible-pull clones the repository and executes a task that
   generates a file (/tmp/ansible-hello-world.txt).

Install Git and create local Git repository
"""""""""""""""""""""""""""""""""""""""""""

::

   # ls -la /usr/local/git/ansible-conf-example/
   total 230
   drwxr-xr-x  3 git_daemon git_daemon   6 Jul  2 11:05 .
   drwxr-xr-x  7 git_daemon git_daemon   7 Jul  2 10:55 ..
   drwxr-xr-x  7 git_daemon git_daemon  12 Jul  2 11:07 .git
   -rw-r--r--  1 git_daemon git_daemon  65 Jul  2 10:59 ansible.cfg
   -rw-r--r--  1 git_daemon git_daemon  35 Jul  2 10:48 hosts
   -rw-r--r--  1 git_daemon git_daemon 211 Jul  2 10:48 pb-example.yml

.. seealso::

   The `Example`_

Configure git_daemon in /etc/rc.conf and start it
"""""""""""""""""""""""""""""""""""""""""""""""""

::

   git_daemon_enable="YES"
   git_daemon_directory="/usr/local/git"
   git_daemon_flags="--syslog --base-path=/usr/local/git --export-all --reuseaddr --detach"

Configure ansible_init in /etc/rc.conf
""""""""""""""""""""""""""""""""""""""

::

   ansible_init_enable="YES"
   ansible_init_host="git://localhost"
   ansible_init_repo="ansible-conf-example"
   ansible_init_playbook="pb-example.yml"

Start ansible_init
""""""""""""""""""

::

   # service ansible_init start

The ``ansible-pull`` execution ``clones`` the ``repository`` into the local
directory ``/root/ansible-conf-example`` and executes the playbook. As a result,
the file ``/tmp/ansible-hello-world.txt`` is created:

::

   # cat /tmp/ansible-hello-world.txt
   [ansible-test] Hello world!

.. seealso::

   * repository `ansible_init`_
   * repository `ansible-conf-init-example`_
   * repository `ansible-conf-test`_
   * example :ref:`example_524`

.. warning::

   The git:// protocol does not support encryption or authentication.  While
   perfect for fast local prototyping or isolated provisioning networks, you
   should change your ansible_init_host parameter to https:// for production
   deployments.


.. _ansible_init: https://github.com/vbotka/ansible_init/
.. _ansible-conf-init-example: https://github.com/vbotka/ansible-conf-init-example/
.. _Example: https://github.com/vbotka/ansible_init/tree/master/files/examples/
.. _ansible-conf-test: https://github.com/vbotka/ansible-conf-test/
