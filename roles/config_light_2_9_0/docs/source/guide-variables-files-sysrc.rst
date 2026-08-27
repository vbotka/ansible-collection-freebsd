.. _ug_variables_files_sysrc:

sysrc
^^^^^

.. contents::
   :local:

Create or configure ``rc.conf`` file and ``rc.conf.d`` directory.

Parameters
""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file.               |
+---------------------+-----------------------+-----------------------------+
| jail                | string                | Jail name/ID to operate on. |
+---------------------+-----------------------+-----------------------------+
| delim               | string                | Delimiter instead of space. |
+---------------------+-----------------------+-----------------------------+
| sysrc               | list ``required``     |                             |
+--+------------------+-----------------------+-----------------------------+
|  | key              | string ``required``   | Parameter name.             |
|  +------------------+-----------------------+-----------------------------+
|  | value            | string                | Parameter value.            |
|  +------------------+-----------------------+-----------------------------+
|  | state            | string                | see community.general.sysrc |
+--+------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers.           |
+---------------------+-----------------------+-----------------------------+

Example
"""""""

Configure ``git_daemon``

.. code-block:: yaml
   :caption: conf-light/files.d/git.yml

   git:
     path: /etc/rc.conf
     sysrc: "{{ cl_git_daemon_dict }}"
     handlers:
       - restart git_daemon

.. code-block:: yaml
   :caption: host_vars/branch-server.example.com/cl-git-daemon.yml

   cl_git_daemon_user: git_daemon
   cl_git_daemon_group: git_daemon
   cl_git_daemon_directory: /usr/local/var/db/git
   cl_git_daemon_flags: "--syslog --reuseaddr --detach --base-path={{ cl_git_daemon_directory }}"

   cl_git_daemon_dict: "{{ cl_git_daemon_dict_raw | dict2items }}"
   cl_git_daemon_dict_raw:
     git_daemon_user: "{{ cl_git_daemon_user }}"
     git_daemon_group: "{{ cl_git_daemon_group }}"
     git_daemon_directory: "{{ cl_git_daemon_directory }}"
     git_daemon_flags: "{{ cl_git_daemon_flags }}"

creates the below lines in ``/etc/rc.conf``

.. code-block:: yaml
   :caption: /etc/rc.onf

   git_daemon_user=git_daemon
   git_daemon_group=git_daemon
   git_daemon_directory=/usr/local/var/db/git
   git_daemon_flags="--syslog --reuseaddr --detach --base-path=/usr/local/var/db/git"

.. seealso::

   * See :ref:`as_files-sysrc.yml` annotated source code
   * Ansible module `community.general.sysrc`_
   * `man rc.conf`_


.. _community.general.sysrc: https://docs.ansible.com/ansible/latest/collections/community/general/sysrc_module.html
.. _man rc.conf: https://man.freebsd.org/cgi/man.cgi?rc.conf
