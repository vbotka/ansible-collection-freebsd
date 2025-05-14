.. _ug_bp:

Best practice
*************

.. contents:: Table of Contents
   :local:
   :depth: 1


Check syntax
============

Check syntax of the playbook ::

    shell> ansible-playbook pb.yml --syntax-check


Validation
==========

Install ``yamllint`` to use the default validation of the created handlers and
assembled data. See the variables *cl_assemble_validate* and
*cl_handlers_validate* in *defaults/main.yml*. Optionally, use other linter, for
example, ``ansible-lint`` and change the variables. You can disable the validation
by clearing the variables ::

    cl_assemble_validate: ''
    cl_handlers_validate: ''


Setup
=====

Create handlers and assemble data. When you take a look at ``tasks/main.yml``
you'll see that ``tasks/vars.yml`` is tagged *always*. As a result, when you
apply the tag *cl_setup* these tasks will be executed too ::

    shell> ansible-playbook pb.yml -t cl_setup


Vars
====

Assemble data. ::

    shell> ansible-playbook pb.yml -t cl_vars

.. note::

   ``tasks/vars.yml`` is tagged *always*.


Sanity
======

Test sanity ::

    shell> ansible-playbook pb.yml -t cl_sanity


Debug
=====

Display variables ::

    shell> ansible-playbook pb.yml -t cl_debug -e cl_debug=true


Manage packages
===============

Dry-run the management of packages ::

    shell> ansible-playbook pb.yml -t cl_packages -CD

Manage packages ::

    shell> ansible-playbook pb.yml -t cl_packages

Then disable the installation ``cl_install=false`` to speedup the playbook
execution.


Manage states of files
======================

Dry-run the management of files' states ::

    shell> ansible-playbook pb.yml -t cl_states -CD

Set the states (existence and attributes) of the files ::

    shell> ansible-playbook pb.yml -t cl_states


Manage configuration files
==========================

Dry-run the configuration of files ::

    shell> ansible-playbook pb.yml -t cl_files -CD

Create and modify files ::

    shell> ansible-playbook pb.yml -t cl_files


Manage services
===============

Dry-run the configuration of services ::

    shell> ansible-playbook pb.yml -t cl_services -CD

Configure services ::

    shell> ansible-playbook pb.yml -t cl_services

.. hint::

   If you know what you are doing skip the above selection of particular tags
   and run the complete role at once ::

    shell> ansible-playbook pb.yml


Idempotency
===========

The role and the configuration data in the examples are idempotent. When the
application is installed and configured there should be no changes reported by
``ansible-playbook`` when running the playbook repeatedly. Disable setup, sanity
and install to speedup the execution when running the playbook periodically to
audit the configuration ::

    shell> ansible-playbook pb.yml -e cl_setup=false \
                                   -e cl_sanity=false \
                                   -e cl_install=false
