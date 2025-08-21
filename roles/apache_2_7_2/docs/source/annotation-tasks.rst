.. _as_tasks:

Tasks
=====

.. _as_main.yml:

main.yml
--------

Synopsis: Main task.


Import tasks if enabled.


[`tasks/main.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/main.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/main.yml
    :language: yaml
    :emphasize-lines: 1,2
    :linenos:





.. _as_vars.yml:

vars.yml
--------

Synopsis: Include OS specific variables from the role's directory vars.


OS specific default variables will be loaded from the files in the directories `vars
<https://github.com/vbotka/ansible-apache/blob/master/vars/>`_ and `vars/defaults
<https://github.com/vbotka/ansible-apache/blob/master/vars/defaults/>`_. OS specific custom
variables, that will override default values, can be loaded from the files in the directory `vars
<https://github.com/vbotka/ansible-apache/blob/master/vars/>`_.


[`tasks/vars.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/vars.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/vars.yml
    :language: yaml
    :emphasize-lines: 4-5
    :linenos:

.. seealso::
   * Review the precedence, naming conventions, and other details in the included tasks (5) `al_include_os_vars_path.yml <https://raw.githubusercontent.com/vbotka/ansible-lib/devel/tasks/al_include_os_vars_path.yml>`_
   * See :ref:`ug_variables`

.. note::
   * Put OS specific variables here.
   * Because of the precedence (15.role vars), there are limited options to override these variables.

.. hint::
   * It might be more convenient to maintain the variables incrementally.
   * See `al_include_os_vars_path_incr.yml <https://raw.githubusercontent.com/vbotka/ansible-lib/devel/tasks/al_include_os_vars_path_incr.yml>`_

.. warning::
   * Put customized OS specific variables into the files in the dictionary *vars/*
   * Changes stored in the directory *vars/defaults* will be overwritten by an update of the role.

.. _as_debug.yml:

debug.yml
---------

Synopsis: Configure debug


Description of the task.


[`tasks/debug.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/debug.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/debug.yml
    :language: yaml
    :emphasize-lines: 1
    :linenos:





.. _as_sanity.yml:

sanity.yml
----------

Synopsis: Configure sanity


Description of the task.


[`tasks/sanity.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/sanity.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/sanity.yml
    :language: yaml
    :emphasize-lines: 1
    :linenos:





.. _as_pkg.yml:

pkg.yml
-------

Synopsis: Configure pkg


Description of the task.


[`tasks/pkg.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/pkg.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/pkg.yml
    :language: yaml
    :emphasize-lines: 1
    :linenos:





.. _as_pkg-freebsd.yml:

pkg-freebsd.yml
---------------

Synopsis: Configure pkg-freebsd


Description of the task.


[`tasks/pkg-freebsd.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/pkg-freebsd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/pkg-freebsd.yml
    :language: yaml
    :emphasize-lines: 1
    :linenos:





.. _as_samples.yml:

samples.yml
-----------

Synopsis: <TBD>


<TBD>


[`tasks/samples.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/samples.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/samples.yml
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::
   * <TBD>




.. _as_httpd.yml:

httpd.yml
---------

Synopsis: Configure lines in httpd.conf


Iterate the list ``apache_httpd_conf`` (8) and add lines to the configuration file (4).


[`tasks/httpd.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd.yml
    :language: yaml
    :emphasize-lines: 4,8
    :linenos:

.. seealso::
   * Variable :ref:`ug_apache_httpd_conf`




.. _as_httpd-dirs.yml:

httpd-dirs.yml
--------------

Synopsis: Create files with the directory blocks in the Includes directory.


Iterate the list ``apache_directory_blocks`` (10) and create configuration files in the directory (5).


[`tasks/httpd-dirs.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-dirs.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-dirs.yml
    :language: yaml
    :emphasize-lines: 5,10
    :linenos:

.. seealso::
   * Template :ref:`as_template_directory-block.j2`
   * Variable :ref:`ug_apache_directory_blocks`




.. _as_httpd-modules.yml:

httpd-modules.yml
-----------------

Synopsis: Load Apache modules.


Iterate ``apache_httpd_conf_modules`` (13). When ``item.preset`` (14) insert line ``LoadModule
...`` (10) to httpd.conf (8). Iterate ``apache_httpd_conf_modules`` (23). When ``not item.preset``
(24) comment line ``# LoadModule ...`` (19) in httpd.conf (18).


[`tasks/httpd-modules.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-modules.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-modules.yml
    :language: yaml
    :emphasize-lines: 6,16
    :linenos:

.. seealso::
   * Variable :ref:`ug_apache_httpd_conf_modules`




.. _as_httpd-php.yml:

httpd-php.yml
-------------

Synopsis: Configure httpd-php


Description of the task.


[`tasks/httpd-php.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-php.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-php.yml
    :language: yaml
    :emphasize-lines: 1
    :linenos:





.. _as_httpd-alias.yml:

httpd-alias.yml
---------------

Synopsis: Configure aliases in httpd.conf


When not an empty list (12) iterate ``apache_alias`` (7-9) and update blocks in the configuration file (4).


[`tasks/httpd-alias.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-alias.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-alias.yml
    :language: yaml
    :emphasize-lines: 2,7-9,12
    :linenos:

.. seealso::
   * Variable :ref:`ug_apache_alias`




.. _as_httpd-ssl.yml:

httpd-ssl.yml
-------------

Synopsis: Configure SSL in extra/httpd-ssl.conf


Iterate ``apache_httpd_conf_ssl_extra`` (16) and configure lines in
``extra/httpd-ssl.conf``. Iterate ``apache_httpd_conf_ssl_extra_absent`` (24) and remove lines
from ``extra/httpd-ssl.conf``. Iterate ``apache_httpd_conf_ssl_listen`` (31) and add configuration lines
in ``extra/httpd-ssl.conf``). Iterate ``apache_httpd_conf_ssl`` (38) and configure lines in
``httpd.conf``.


[`tasks/httpd-ssl.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-ssl.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-ssl.yml
    :language: yaml
    :emphasize-lines: 4,16,24,31,38
    :linenos:

.. seealso::
   * Variable :ref:`ug_apache_httpd_conf_ssl`
   * Variable :ref:`ug_apache_httpd_conf_ssl_extra`
   * Variable :ref:`ug_apache_httpd_conf_ssl_extra_absent`
   * Variable :ref:`ug_apache_httpd_conf_ssl_listen`




.. _as_httpd-vhosts.yml:

httpd-vhosts.yml
----------------

Synopsis: Configure virtual hosts in extra directory.


Loop the dictionary ``apache_vhost`` (9, 22, 34) and optionally (12) create directories
``DocumentRoot`` (5). Create configuration files with the Apache virtual hosts (17). See the
template :ref:`as_template_vhost.j2` (16). Include created files (31) in the configuration file
(29).


[`tasks/httpd-vhosts.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-vhosts.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-vhosts.yml
    :language: yaml
    :emphasize-lines: 3,15,28
    :linenos:

.. seealso::
   * Template :ref:`as_template_vhost.j2`
   * Template :ref:`as_template_vhost2.j2`




.. _as_httpd-confd.yml:

httpd-confd.yml
---------------

Synopsis: Configure virtual hosts.


Configure virtual hosts (2) and configuration sections of the directories (6).


[`tasks/httpd-confd.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-confd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-confd.yml
    :language: yaml
    :emphasize-lines: 2,6
    :linenos:

.. seealso::
   * httpd-confd-vhosts.yml and httpd-confd-includes.yml




.. _as_httpd-confd-vhosts.yml:

httpd-confd-vhosts.yml
----------------------

Synopsis: Configure virtual hosts. Create files.


Use the filter `encode_apache <https://galaxy.ansible.com/jtyr/config_encoder_filters>`_ to
configure virtual hosts. See the template vhost2.j2.  Take the YAML configuration files from the
directory ``apache_confd_dir_vhosts`` (7) at master and create files with the Apache virtual hosts
in the directory (41) at the remote host. The created files will be included in the configuration
file (51).


**Include data from conf.d (2-19)**

Include tasks from the file ``al_include_confd_vars_list`` (13) in the role ``vbotka.ansible_lib``
(12). This task takes as parameters the directory with the YAML configuration files (7) and the
type of the list (8), and returns the list with the YAML configurations of the virtual hosts
stored in the variable ``al_include_confd_vars_list``. The variable can be printed (15) when debug
is enabled ``apache_debug: true`` (19). The parameters (7, 8) are tested inside the included tasks.


**Create directories for virtual hosts (21-32)**

Include tasks from ``fn/httpd-confd-vhost-dirs.yml`` .


**Configure virtual hosts in extra directory (34-55)**

Create the Apache configuration files for the virtual hosts with the help of ``encode_apache``
filter. Store the configuration file (41). Include virtual hosts in httpd.conf (50).


[`tasks/httpd-confd-vhosts.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-confd-vhosts.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-confd-vhosts.yml
    :language: yaml
    :emphasize-lines: 7,41,51
    :linenos:

.. seealso::
   * Template :ref:`as_template_vhost2.j2`
   * Example of the configuration file `vars/conf.d/vhosts-sample/example.com.yml <https://github.com/vbotka/ansible-apache/blob/master/vars/conf.d/vhosts-sample/example.com.yml>`_
   * Included task `al_include_confd_vars_list.yml <https://github.com/vbotka/ansible-lib/blob/master/tasks/al_include_confd_vars_list.yml>`_.




.. _as_httpd-confd-vhost-dirs.yml:

httpd-confd-vhost-dirs.yml
--------------------------

Synopsis: Create ``DocumentRoot`` directories for vhosts.


<TBD>


[`tasks/fn/httpd-confd-vhost-dirs.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/fn/httpd-confd-vhost-dirs.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/fn/httpd-confd-vhost-dirs.yml
    :language: yaml
    :emphasize-lines: 3
    :linenos:

.. seealso::
   * <TBD>




.. _as_httpd-confd-includes.yml:

httpd-confd-includes.yml
------------------------

Synopsis: Configure sections using the filter encode_apache.


Take the YAML configuration files from the directory ``apache_confd_dir_sections`` (7) at master
and create the configuration files (24) at the remote host. The created configuration files are
included in the configuration file ``httpd.conf`` by default. For example,

.. code-block:: yaml

  shell> grep Includes /usr/local/etc/apache24/httpd.conf
  Include etc/apache24/Includes/*.conf

**Include data from conf.d (2-19)**

Include tasks from the file ``al_include_confd_vars_list`` (13) in the role ``vbotka.ansible_lib``
(12). This task takes as parameters the directory of the YAML configuration files (7) and the
type of the list (8), and returns the list with the YAML configurations of the sections stored in
the variable ``al_include_confd_vars_list``. The parameters (7, 8) are tested inside the included
tasks.

**Configure sections in Includes directory (21-30)**

Use the filter ``encode_apache`` to create the configuration files (24) for the sections. See the
template ``section2.j2``.


[`tasks/httpd-confd-includes.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/httpd-confd-includes.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/httpd-confd-includes.yml
    :language: yaml
    :emphasize-lines: 2,21
    :linenos:

.. seealso::
   * Template :ref:`as_template_section2.j2`
   * Example of the configuration file `vars/conf.d/section-sample/usr-local-www-example.com.yml <https://github.com/vbotka/ansible-apache/blob/master/vars/conf.d/sections-sample/usr-local-www-example.com.yml>`_
   * Details of the format are described in the filter `encode_apache <https://galaxy.ansible.com/jtyr/config_encoder_filters>`_




.. _as_service.yml:

service.yml
-----------

Synopsis: Configure service.


At the moment, only the configuration of FreeBSD is implemented (2).


[`tasks/service.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/service.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/service.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:

.. seealso::
   * rcconf.yml




.. _as_rcconf.yml:

rcconf.yml
----------

Synopsis: Configure service in FreeBSD.


Configure (2), enable (11) or disable (20) the service.


[`tasks/rcconf.yml <https://github.com/vbotka/ansible-apache/blob/master/tasks/rcconf.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../tasks/rcconf.yml
    :language: yaml
    :emphasize-lines: 2,11,20
    :linenos:

.. seealso::
   * <TBD>




