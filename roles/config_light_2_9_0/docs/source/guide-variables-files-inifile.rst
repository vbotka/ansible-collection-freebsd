.. _ug_variables_files_inifile:

ini_file
^^^^^^^^

.. contents::
   :local:

Create or configure ini entries in a file.

Parameters
""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file.               |
+---------------------+-----------------------+-----------------------------+
| ini                 | list ``required``     | ini_file parameters         |
|                     |                       | list of dictionaries        |
|                     |                       | (see files-inifile.yml)     |
+--+------------------+-----------------------+-----------------------------+
|  | section          | string ``required``   | Section name in INI file.   |
|  +------------------+-----------------------+-----------------------------+
|  | option           | string                | Name of the option.         |
|  +------------------+-----------------------+-----------------------------+
|  | value            | string                | Value of the option.        |
|  +------------------+-----------------------+-----------------------------+
|  | state            | string                | If absent, the option or    |
|  |                  |                       | section will be removed.    |
|  +------------------+-----------------------+-----------------------------+
|  | allow_no_value   | boolean               | Allow option without value. |
|  +------------------+-----------------------+-----------------------------+
|  | no_extra_spaces  | boolean               | Do not insert spaces.       |
|  +------------------+-----------------------+-----------------------------+
|  | ...              | ...                   | <TBD>                       |
+--+------------------+-----------------------+-----------------------------+
| owner               | string                | Owner of the file.          |
+---------------------+-----------------------+-----------------------------+
| group               | string                | Group of the file.          |
+---------------------+-----------------------+-----------------------------+
| mode                | string                | Mode of the file.           |
+---------------------+-----------------------+-----------------------------+
| attributes          | string                | Attributes of the file.     |
+---------------------+-----------------------+-----------------------------+
| create              | boolean               | Create file.                |
+---------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers.           |
+---------------------+-----------------------+-----------------------------+

Example
"""""""

<TODO: No example yet>

.. seealso::

   * See :ref:`as_files-inifile.yml` annotated source code

   * community.general `ini_file.py <https://github.com/ansible-collections/community.general/blob/main/plugins/modules/files/ini_file.py>`_


.. note:: Quoting `Multiple options with the same name exist #273
          <https://github.com/ansible-collections/community.general/issues/273#issuecomment-625047180>`_
          *"There is no "The INI format", there are many different
          interpretations out there what valid INI formats should be
          ..."*
