.. _ug_variables:

Variables
*********

The :ref:`ug_variables_defaults` control the options of the role.

The most important are the variables that control the collection of the
configuration data. Customize the configuration data stored in the directory
``cl_dird`` in each project.

The names of the dictionaries in the configuration files ``cl_dird/*.d/*`` are
not used by the role and must be:

* valid Ansible variables name
* unique in the particular section (files.d, packages.d, ...).

.. seealso::

   * See :ref:`as_vars.yml` annotated source code
   * `Ansible variable precedence. Where should I put a variable?`_

.. toctree::
  :maxdepth: 1
  :caption: Table of Contents

  guide-variables-defaults.rst
  guide-variables-data.rst
  guide-variables-handlers.rst
  guide-variables-packages.rst
  guide-variables-states.rst
  guide-variables-services.rst
  guide-variables-files.rst

.. _Ansible variable precedence. Where should I put a variable?: https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable
