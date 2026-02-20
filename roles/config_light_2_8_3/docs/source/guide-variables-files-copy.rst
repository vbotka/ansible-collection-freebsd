.. _ug_variables_files_copy:

copy
^^^^

.. contents::
   :local:

Copy files.

Parameters
""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file.               |
+---------------------+-----------------------+-----------------------------+
| copyfile            | dict ``required``     | copyfile parameters         |
|                     |                       | (see tasks/files-copy.yml)  |
+--+------------------+-----------------------+-----------------------------+
|  | path             | string ``required``   | Path of the source file.    |
|  +------------------+-----------------------+-----------------------------+
|  | remote_src       | string                | Source file from remote.    |
|  +------------------+-----------------------+-----------------------------+
|  | force            | boolean               | If *no*, transfer if dest   |
|  |                  |                       | does not exist.             |
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
| validate            | string                | Command to validate file.   |
+---------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers.           |
+---------------------+-----------------------+-----------------------------+

Example
"""""""

Create the description of the file (2) and declare the variable for the dictionary (7)

[`contrib/lighttpd_nagios/conf-light/files.d/lighttpd-modulesconf.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/lighttpd_nagios/conf-light/files.d/lighttpd-modulesconf.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/lighttpd_nagios/conf-light/files.d/lighttpd-modulesconf.yml
    :language: yaml
    :emphasize-lines: 2,7
    :linenos:

Create the dictionary ``cl_lighttpd_modulesconf_copy`` (69)

[`contrib/lighttpd_nagios/cl-lighttpd.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/lighttpd_nagios/cl-lighttpd.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/lighttpd_nagios/cl-lighttpd.yml
    :language: yaml
    :linenos:
    :lines: 68-72
    :lineno-start: 68
    :emphasize-lines: 2

Then, the command ::

  shell> ansible-playbook config-light.yml -t cl_files_copy

will copy sample file ``modules.conf.sample`` to ``modules.conf`` if
the destination does not exist.

.. seealso::

   * See `files-copy.yml  <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-copy.yml>`_ at GitHub
   * See :ref:`as_files-copy.yml` annotated source code
