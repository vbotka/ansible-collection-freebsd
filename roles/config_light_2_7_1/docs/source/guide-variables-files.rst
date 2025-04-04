.. _ug_variables_files:

Files
=====

.. contents::
   :local:

The variable *cl_files* is a dictionary of the files that shall be managed by
this role. It's optional which Ansible module will be used to manage a
file. More options can be applied at the same file. For example, it is possible
to create a file by the Ansible module *template* and modify it by the module
*lineinfile* later. Several options, listed in the default order, are available

:copy: If the attribute *copyfile* is defined in the dictionary.
:template: If the attribute *template* is defined in the dictionary.
:markers: Create blockinfile markers. If the attribute *markers* is defined in the dictionary.
:patch: If the attribute *patch* is defined in the dictionary.
:lineinfile: If the attribute *dict* or *lines* is defined in the dictionary.
:blockinfile: If the attribute *blocks* is defined in the dictionary.
:ini_file: If the attribute *ini* is defined in the dictionary.
:ucl:  If the attribute *ucl* is defined in the dictionary.

The variable ``cl_files_order`` controls the order of the execution. Multiple
options will be applied in this order when present in the dictionary of a file
definition. In addition to the options, listed above, there are
``create-backup`` and ``delete-backup`` tasks to backup files that was changed
if enabled by ``cl_backup`` (default: false). By default, the backup files are
created after *copy, template, and markers*. Fit the order of the execution to
your needs.

.. seealso::
     
   * :ref:`as_vars-files.yml`
   * :ref:`as_files.yml`
   * :ref:`as_files-create-backup.yml`
   * :ref:`as_files-delete-backup.yml`

.. toctree::
  :maxdepth: 1
  :caption: Table of Contents

  guide-variables-files-copy.rst
  guide-variables-files-template.rst
  guide-variables-files-markers.rst
  guide-variables-files-patch.rst
  guide-variables-files-lineinfile.rst
  guide-variables-files-blockinfile.rst
  guide-variables-files-inifile.rst
  guide-variables-files-ucl.rst
