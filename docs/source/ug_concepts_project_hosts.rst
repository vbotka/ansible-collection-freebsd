.. _ug_concepts_project_hosts:

Project hosts
-------------

.. index:: single: variable project_hosts; Project hosts
.. index:: single: project_hosts; Project hosts


The ``project_hosts`` variable stores jail IP addresses for iocage hosts. For
example,

.. code-block:: yaml

   project_hosts:
     iocage_06:
       defaultrouter: 172.16.99.1
       default_pkg_repo: 172.16.99.1
       log_server: 172.16.99.10
       repos: 172.16.99.21
       repos_devel: 172.16.99.22
       pkg_repo: 172.16.99.23

The template below can be used to provide jails with the fixed IP
addresses for a project running on a particular host.


.. code-block:: yaml+jinja

   project_hosts:
     {{ project_hosts[inventory_hostname] }}
