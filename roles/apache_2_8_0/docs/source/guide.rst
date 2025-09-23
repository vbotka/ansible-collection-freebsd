.. role:: bash(code)
   :language: bash

.. _ug:

User's guide
************
.. contents:: Contents
   :local:
   :depth: 2

.. _ug_introduction:

Introduction
============

The role will install and configure Apache web server

* Ansible role: `vbotka.apache`_
* Supported systems: `FreeBSD`_
* Requirements:

    * `vbotka.ansible_lib`_
    * `jtyr.config_encoder_filters`_
    * `community.general`_

The user is expected to have basic knowledge of Ansible

* `Basic Concepts`_
* `Roles`_
* `Working With Playbooks`_

.. _ug_installation:

Installation
============

The most convenient way on how to install a Ansible role or collection is to use Ansible Galaxy CLI
``ansible-galaxy``. The utility is installed by the standard Ansible package and provides the user with
simple interface to the Ansible Galaxy's services. For example take a look at the current status of
the role ::

    shell> ansible-galaxy role info vbotka.apache

and install it ::

    shell> ansible-galaxy role install vbotka.apache

Together with the role `vbotka.apache`_ dependent role `jtyr.config_encoder_filters`_ will be
installed (see meta/main.yml). This role provides the filter `encode_apache`_ used to encode YAML
configuration data to the Apache format.

Install the library `vbotka.ansible_lib`_ if necessary ::

    shell> ansible-galaxy role install vbotka.ansible_lib

Install the collection `community.general`_ ::

    shell> ansible-galaxy collection install community.general

.. seealso::

   * For details on how to install specific versions from various sources see `Installing content`_.

   * Take a look at other roles ``shell> ansible-galaxy search --author=vbotka``

.. _ug_ansible_playbook:

Ansible playbook
================

Simple playbook to install and configure Apache at srv.example.com (2)

.. code-block:: yaml
   :emphasize-lines: 2
   :linenos:

   shell> cat apache.yml
   - hosts: srv.example.com
     gather_facts: true
     connection: ssh
     remote_user: admin
     become: yes
     become_user: root
     become_method: sudo
     roles:
       - vbotka.apache

.. note::

   * See :ref:`ug_variables`.

   * | ``gather_facts: true`` (3) must be set to collect variables needed to evaluate
     | :ref:`ug_os_defaults` and :ref:`ug_os_custom`:
     | ``ansible_distribution``, ``ansible_distribution_release``, ``ansible_os_family``

.. seealso::

   * For details see `Connection Plugins`_ (4-5) and
   * `Understanding Privilege Escalation`_ (6-8).

.. _ug_tags:

Tags
====

The tags provide very useful tool to run selected tasks of the role. The below command lists the available tags

.. code-block:: yaml
   :emphasize-lines: 1
   :linenos:

    shell> ansible-playbook apache.yml --list-tags

    playbook: apache.yml

    play #1 (srv.example.conf): srv.example.com	TAGS: []

      TASK TAGS: [always, apache_debug, apache_httpd,
      apache_httpd_alias, apache_httpd_confd,
      apache_httpd_confd_includes, apache_httpd_confd_vhosts,
      apache_httpd_dirs, apache_httpd_modules, apache_httpd_php,
      apache_httpd_ssl, apache_httpd_vhosts, apache_pkg,
      apache_samples, apache_sanity, apache_service, apache_vars]

For example, display the variables ::

    shell> ansible-playbook apache.yml -t apache_debug -e apache_debug=true

Display what packages will be installed ::

    shell> ansible-playbook apache.yml -t apache_pkg -e apache_debug=true --check

Install packages and exit the play. Enable the debug output ::

    shell> ansible-playbook apache.yml -t apache_pkg -e apache_debug=true

.. _ug_debug:

Debug
=====

To see additional debug information in the output enable debug output in the configuration ::

    apache_debug: true

, or set the extra variable in the command ::

    shell> ansible-playbook apache.yml -e apache_debug=true

.. seealso::

   * `Playbook Debugger`_

.. _ug_variables:

Variables
=========

In this section we describe default variables stored in the directory ``defaults`` and variables
included from the directory ``vars``.

Precedence:

* role defaults in the directory ``{{ role_path }}/defaults``
  (precedence 2.)
* include OS specific vars from the directory ``{{ role_path }}/vars``
  (precedence 18.)

.. seealso::

   * `Ansible variable precedence. Where should I put a variable?`_

.. _ug_defaults:

Default variables
-----------------

Most of the variables are self-explaining. For Apache configuration see `Apache HTTP Server Documentation`_.

main.yml
^^^^^^^^

[`defaults/main/main.yml`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../defaults/main/main.yml
    :language: yaml
    :emphasize-lines: 5-8,13-20
    :linenos:

ssl.yml
^^^^^^^

Configure `SSL/TLS`_ when enabled (3)

[`defaults/main/ssl.yml`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../defaults/main/ssl.yml
    :language: yaml
    :emphasize-lines: 3,4
    :linenos:

.. warning:: By default, SSL is turned off ``apache_sslengine: "off"`` (4).

php.yml
^^^^^^^

Install and configure `PHP`_ when enabled (3). Install and configure `FastCGI Process Manager
(FPM)`_ when enabled (4).

[`defaults/main/php.yml`_]

.. highlight:: yaml
    :linenothreshold: 5

.. literalinclude:: ../../defaults/main/php.yml
    :language: yaml
    :emphasize-lines: 3,4
    :linenos:

samples.yml
^^^^^^^^^^^

Copy samples when enabled (3)

[`defaults/main/samples.yml`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../defaults/main/samples.yml
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. _ug_os_defaults:

OS specific default variables
-----------------------------

The configuration files from the directory ``vars/defaults`` will be included in the loop
``with_first_found`` (1). At least empty ``default.yml`` (6) shall be present.

* [`tasks/vars.yml`_]
* [`al_include_os_vars_path.yml`_]

.. code-block:: yaml
   :emphasize-lines: 1,6
   :linenos:

    with_first_found:
    - files:
        - "{{ ansible_distribution }}-{{ ansible_distribution_release }}.yml"
        - "{{ ansible_distribution }}.yml"
        - "{{ ansible_os_family }}.yml"
        - default.yml
        - defaults.yml
      paths: "{{ al_os_vars_path }}/vars/defaults"

.. note::

   * OS specific variables are included by the module ``include_var`` that has very high precedence
     (18 in the list of 22).

   * See `Ansible variable precedence. Where should I put a variable?`_

   * To override the default variables see :ref:`ug_os_custom`.

.. _ug_os_defaults_freebsd:

FreeBSD default variables
^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the binary packages will be installed (4). But, if custom builds are available switch to
``ports`` (5) and use ``freebsd_use_packages: "yes"`` (6) to speedup the installation. Under
standard circumstances, there is no reason to change other parameters here.

[`vars/defaults/FreeBSD.yml`_]

.. literalinclude:: ../../vars/defaults/FreeBSD.yml
    :language: yaml
    :emphasize-lines: 4-6
    :linenos:

.. _ug_os_custom:

OS specific custom variables
----------------------------

The configuration files from the directory ``vars`` will be included in the loop
``with_first_found`` (1) and will override the default values of the variables. At least empty
``default.yml`` (6) shall be present here.

* [`tasks/vars.yml`_]
* [`al_include_os_vars_path.yml`_]

.. code-block:: yaml
   :emphasize-lines: 1,6
   :linenos:

    with_first_found:
    - files:
        - "{{ ansible_distribution }}-{{ ansible_distribution_release }}.yml"
        - "{{ ansible_distribution }}.yml"
        - "{{ ansible_os_family }}.yml"
        - default.yml
        - defaults.yml
      paths: "{{ al_os_vars_path }}/vars"

.. note::

   * OS specific variables from the directory ``{{ al_os_vars_path }}/vars``
     override OS specific default variables from the directory ``{{ al_os_vars_path }}/vars/defaults``

   * See `al_include_os_vars_path.yml`_


.. _ug_apache_vhost:

apache_vhost
------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_vhost`` is a list of virtual hosts.

Parameters
^^^^^^^^^^
============================= ==================== ============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== ============================
| **ServerName**              | *string*           | Fully qualified domain
                              | ``required``       | name (FQDN)
| **DocumentRoot**            | *string*           | Path DocumentRoot
                              | ``required``
| **SSLCertificateFile**      | *string*           | Path to SSL Certificate
                              | ``required``
| **SSLCertificateKeyFile**   | *string*           | Path to SSL Private key
                              | ``required``
| **redirect**                | *boolean*          | Redirect permanent http
                              | ``default: false`` | to https
| **create_document_root**    | *boolean*          | Create DocumentRoot
                              | ``default: false``
============================= ==================== ============================

Example
^^^^^^^
The example below will configure virtual server ``mail.example.net`` (2).

.. code-block:: yaml
   :emphasize-lines: 2
   :linenos:

   apache_vhost:
     - ServerName: "mail.example.net"
       DocumentRoot: "/usr/local/www/roundcube/"
       SSLCertificateFile: "/usr/local/etc/letsencrypt/live/mail.example.net/fullchain.pem"
       SSLCertificateKeyFile: "/usr/local/etc/letsencrypt/live/mail.example.net/privkey.pem"

Notes
^^^^^
.. note::

   * The default value is an empty list ``apache_vhost: []``

   * For details see annotated source :ref:`as_httpd-vhosts.yml`

   * GitHub `tasks/httpd-vhosts.yml`_

See Also
^^^^^^^^
.. seealso::

   * It is also possible to configure virtual servers with ``apache_confd_dir_vhosts``. See :ref:`ug_apache_confd_dir_vhosts`.


.. _ug_apache_directory_blocks:

apache_directory_blocks
-----------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_directory_blocks`` is a list of directory blocks.

Parameters
^^^^^^^^^^
============================= ============== ===================================
| *Parameter*                 | *Type*       | *Comments*
============================= ============== ===================================
| **Directory**               | *string*     | DocumentRoot directory
                              | ``required``
| **Includefile**             | *string*     | Path to the includefile to be
                              | ``required`` | created
| **Conf**                    | *list*       | Configuration of the directory
============================= ============== ===================================

Example
^^^^^^^
Configuration file (3) will be created in the directory ``{{ apache_conf_path }}/Includes/``.

.. code-block:: yaml
   :emphasize-lines: 3
   :linenos:

    apache_directory_blocks:
      - Directory: /usr/local/www/roundcube
        Includefile: usr-local-www-roundcube.conf
        Conf:
          - Options Indexes FollowSymLinks
          - DirectoryIndex index.html
          - AllowOverride All
          - Require all granted

Notes
^^^^^
.. note::

   * The default the value is an empty list ``apache_directory_blocks: []``

   * For details see annotated source :ref:`as_httpd-dirs.yml`

   * GitHub `tasks/httpd-dirs.yml`_

See Also
^^^^^^^^
.. seealso::

   * <TBD>


.. _ug_apache_alias:

apache_alias
------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_alias`` is a list of aliases.

Example
^^^^^^^
.. code-block:: yaml
   :linenos:

    apache_alias:
      - "ScriptAlias /nagios/cgi-bin/ /usr/local/www/nagios/cgi-bin/"
      - "Alias /nagios/ /usr/local/www/nagios/"
      - "Alias /joomla /usr/local/www/joomla3/"

Notes
^^^^^
.. note::

   * The default value is an empty list ``apache_alias: []``

   * For details see annotated source :ref:`as_httpd-alias.yml`

   * GitHub `tasks/httpd-alias.yml`_

.. _ug_apache_confd_dir_vhosts:

apache_confd_dir_vhosts
-----------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_confd_dir_vhosts`` is path to directory with virtual hosts' configuration files.

Parameters
^^^^^^^^^^
The parameters and format of the files are described in the filter `encode_apache
<https://github.com/jtyr/ansible-config_encoder_filters#id6>`_.

Example
^^^^^^^
From the configuration file below the configuration file
``{{ apache_conf_path }}/extra/mail.example.net.conf``
will be created and included in ``{{ apache_conf_path }}/httpd.conf``

.. code-block:: yaml
   :emphasize-lines: 3
   :linenos:

    shell> cat mail.example.net/apache.d/vhosts/mail.example.net.yml
    my_apache_vhost:
      content:
        - sections:
            - name: VirtualHost
              param: "*:80"
              content:
                - options:
                    - ServerName: mail.example.net
                    - DocumentRoot: /usr/local/www/roundcube/
                    - Redirect permanent /: https://mail.example.net/
        - sections:
            - name: VirtualHost
              param: "*:443"
              content:
                - options:
                    - ServerName: mail.example.net
                    - DocumentRoot: /usr/local/www/roundcube/
                    - SSLCertificateFile: /usr/local/etc/ssl/certs/mail.example.net.crt
                    - SSLCertificateKeyFile: /usr/local/etc/ssl/private/mail.example.net.key

Notes
^^^^^
.. note::

   * For details see annotated source :ref:`as_httpd-confd-vhosts.yml`

   * GitHub `tasks/httpd-confd-vhosts.yml`_


Hints
^^^^^
.. hint::

   | * The default value is
   |   ``apache_confd_dir_vhosts: "{{ role_path }}/vars/conf.d/vhosts"``
   | * In projects it might be convenient to change the path. For example,
   |   ``apache_confd_dir_vhosts: "{{ playbook_dir }}/apache.d/vhosts"``

.. _ug_apache_confd_dir_sections:

apache_confd_dir_sections
-------------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^

``apache_confd_dir_sections`` is path to directory with configuration files.

Parameters
^^^^^^^^^^

The parameters and format of the files are described in the filter `encode_apache`_.  The content of
the files will be encoded and stored in the files in the directory ``{{ apache_conf_path
}/Includes/``.

Example
^^^^^^^

For example, from the configuration file below the configuration file
``usr-local-www-roundcube.conf`` will be created and stored in the directory ``{{ apache_conf_path
}}/Includes`` (17).

.. code-block:: yaml
   :emphasize-lines: 5-6,9-15,17
   :linenos:

   shell> cat mail.example.net/apache.d/sections/usr-local-www-roundcube.yml
   my_apache_dir:
     content:
       - sections:
           - name: Directory
             param: /usr/local/www/roundcube
             content:
               - options:
                   - Options:
                       - Indexes
                       - FollowSymLinks
                   - AllowOverride: All
                   - Require:
                       - all
                       - granted

   shell> cat /usr/local/etc/apache24/Includes/usr-local-www-roundcube.conf
   <Directory /usr/local/www/roundcube>
     Options Indexes FollowSymLinks
     AllowOverride All
     Require all granted
   </Directory>

Notes
^^^^^

.. note::

   * For details see annotated source :ref:`as_httpd-confd-includes.yml`, or
   * GitHub `tasks/httpd-confd-includes.yml`_

Hints
^^^^^

.. hint::

   | * The default value is
   |   ``apache_confd_dir_vhosts: "{{ role_path }}/vars/conf.d/sections"``
   | * In projects it might be convenient to change the path. For example,
   |   ``apache_confd_dir_vhosts: "{{ playbook_dir }}/apache.d/sections"``

.. _ug_apache_httpd_conf:

apache_httpd_conf
-----------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf`` is a list of lines in ``httpd.conf``

Parameters
^^^^^^^^^^
============================= ==================== =============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== =============================
| **regexp**                  | *string*           | The pattern to replace if
                              | ``required``       | found
| **line**                    | *string*           | The line to insert/replace
                              | ``required``       | into the file
============================= ==================== =============================

Example
^^^^^^^
.. code-block:: yaml
   :linenos:

   apache_httpd_conf:
     - { regexp: ServerName, line: "{{ apache_servername }}" }
     - { regexp: ServerAdmin, line: "{{ apache_serveradmin }}" }
     - { regexp: ServerRoot, line: /usr/local }
     - { regexp: MIMEMagicFile, line: etc/apache24/magic }

Notes
^^^^^
.. note::

   | * The default value is
   |   ``apache_httpd_conf:``
   |     ``- {regexp: ServerName, line: "{{ apache_servername }}"}``
   |     ``- {regexp: ServerAdmin, line: "{{ apache_serveradmin }}"}``
   | * Because of the escaped quotes the argument line must be quoted
   |     ``- {regexp: ErrorDocument 500, line: "\"The server made a boo boo.\""}``
   | * For details see annotated source :ref:`as_httpd.yml`, or
   | * GitHub `tasks/httpd.yml`_


.. _ug_apache_httpd_conf_ssl:

apache_httpd_conf_ssl
---------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf_ssl`` is a list of lines that configure SSL in ``httpd.conf``

Parameters
^^^^^^^^^^
============================= ==================== =============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== =============================
| **line**                    | *string*           | The line to insert
                              | ``required``       | into the file
============================= ==================== =============================

Notes
^^^^^
.. note::

   | * The default value is
   |   ``apache_httpd_conf_ssl:``
   |     ``- "Include etc/apache{{ apache_version }}/extra/httpd-ssl.conf"``
   | * For details see annotated source :ref:`as_httpd-ssl.yml`, or
   | * GitHub `tasks/httpd-ssl.yml`_

.. _ug_apache_httpd_conf_ssl_extra:

apache_httpd_conf_ssl_extra
---------------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf_ssl_extra`` is a list of lines that configure SSL in ``extra/httpd-ssl.conf``

Parameters
^^^^^^^^^^
============================= ==================== =============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== =============================
| **regexp**                  | *string*           | The pattern to replace if
                              | ``required``       | found
| **line**                    | *string*           | The line to insert/replace
                              | ``required``       | into the file
============================= ==================== =============================

Notes
^^^^^
.. note::

   * See the default value in :ref:`ug_defaults`
   * For details see annotated source :ref:`as_httpd-ssl.yml`, or
   * GitHub `tasks/httpd-ssl.yml`_

.. _ug_apache_httpd_conf_ssl_extra_absent:

apache_httpd_conf_ssl_extra_absent
----------------------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf_ssl_extra_absent`` is a list of lines that will be removed from ``extra/httpd-ssl.conf``

Parameters
^^^^^^^^^^
============================= ==================== =============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== =============================
| **regexp**                  | *string*           | The pattern to be removed
                              | ``required``       |
============================= ==================== =============================

Notes
^^^^^
.. note::

   * The default value is empty list ``apache_httpd_conf_ssl_extra_absent: []``
   * For details see annotated source :ref:`as_httpd-ssl.yml`, or
   * GitHub `tasks/httpd-ssl.yml`_

.. _ug_apache_httpd_conf_ssl_listen:

apache_httpd_conf_ssl_listen
----------------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf_ssl_listen`` is a list of addresses and ports that the server will bind to.

Notes
^^^^^
.. note::

   | * The default value is
   |   ``apache_httpd_conf_ssl_listen:``
   |     ``- Listen 443``
   | * Overlapping Listen directives will result in a fatal error.
   | * For details see annotated source :ref:`as_httpd-ssl.yml`, or
   | * GitHub `tasks/httpd-ssl.yml`_

.. _ug_apache_httpd_conf_modules:

apache_httpd_conf_modules
-------------------------
.. highlight:: yaml
.. contents::
   :local:

Synopsis
^^^^^^^^
``apache_httpd_conf_modules`` is a list of modules to be loaded.

Parameters
^^^^^^^^^^
============================= ==================== =============================
| *Parameter*                 | *Type*             | *Comments*
============================= ==================== =============================
| **module**                  | *string*           | Name of the module
                              | ``required``       |
| **mod**                     | *string*           | Object file or Library
                              | ``required``       |
| **present**                 | *boolean*          | If ``true`` LoadModule
                              | ``default: true``  | directive will be added to
                                                   | httpd.conf.
                                                   | If ``false`` directive will
                                                   | be commented (disabled).
============================= ==================== =============================

Example
^^^^^^^
.. code-block:: yaml
   :linenos:

   apache_httpd_conf_modules:
     - { module: socache_shmcb_module, mod: mod_socache_shmcb.so }
     - { module: ssl_module, mod: mod_ssl.so }
     - { module: php5_module, mod: libphp5.so }

Notes
^^^^^
.. note::

   | * The default value is
   |   ``apache_httpd_conf_modules:``
   |     ``- { module: socache_shmcb_module, mod: mod_socache_shmcb.so }``
   | * For details see annotated source :ref:`as_httpd-modules.yml`, or
   | * GitHub `tasks/httpd-modules.yml`_

.. _vbotka.apache: https://galaxy.ansible.com/vbotka/apache
.. _FreeBSD: https://www.freebsd.org
.. _vbotka.ansible_lib: https://galaxy.ansible.com/vbotka/ansible_lib
.. _jtyr.config_encoder_filters: https://galaxy.ansible.com/jtyr/config_encoder_filters
.. _community.general: https://github.com/ansible-collections/community.general

.. _Basic Concepts: https://docs.ansible.com/ansible/latest/network/getting_started/basic_concepts.htm
.. _Roles: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
.. _Working With Playbooks: https://docs.ansible.com/ansible/latest/user_guide/playbooks.html

.. _encode_apache: https://github.com/jtyr/ansible-config_encoder_filters#id6
.. _Installing content: https://galaxy.ansible.com/docs/using/installing.html
.. _Connection Plugins: https://docs.ansible.com/ansible/latest/plugins/connection.html
.. _Understanding Privilege Escalation: https://docs.ansible.com/ansible/latest/user_guide/become.html#understanding-privilege-escalation
.. _Playbook Debugger: https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html
.. _Ansible variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
.. _Apache HTTP Server Documentation: https://httpd.apache.org/docs

.. _defaults/main/main.yml: https://github.com/vbotka/ansible-apache/blob/master/defaults/main/main.yml
.. _defaults/main/php.yml: https://github.com/vbotka/ansible-apache/blob/master/defaults/main/php.yml
.. _defaults/main/samples.yml: https://github.com/vbotka/ansible-apache/blob/master/defaults/main/samples.yml
.. _defaults/main/ssl.yml: https://github.com/vbotka/ansible-apache/blob/master/defaults/main/ssl.yml

.. _tasks/httpd.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd.yml
.. _tasks/httpd-alias.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-alias.yml
.. _tasks/httpd-confd-includes.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-confd-includes.yml
.. _tasks/httpd-confd-vhosts.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-confd-vhosts.yml
.. _tasks/httpd-dirs.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-dirs.yml
.. _tasks/httpd-modules.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-modules.yml
.. _tasks/httpd-ssl.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-ssl.yml
.. _tasks/httpd-vhosts.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-vhosts.yml
.. _tasks/vars.yml: https://github.com/vbotka/ansible-apache/blob/master/tasks/vars.yml

.. _vars/defaults/FreeBSD.yml: https://github.com/vbotka/ansible-apache/blob/master/vars/defaults/FreeBSD.yml

.. _SSL/TLS:  https://httpd.apache.org/docs/current/ssl
.. _PHP: https://www.php.net/manual/en/book.apache.php
.. _FastCGI Process Manager (FPM): https://www.php.net/manual/en/install.fpm.php

.. _al_include_os_vars_path.yml: <https://github.com/vbotka/ansible-lib/blob/master/tasks/al_include_os_vars_path.yml
