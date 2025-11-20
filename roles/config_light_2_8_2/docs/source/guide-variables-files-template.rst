.. _ug_variables_files_template:

template
^^^^^^^^

.. contents::
   :local:

Create files from templates.

Parameters for template
"""""""""""""""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file.               |
+---------------------+-----------------------+-----------------------------+
| template            | dict ``required``     | Template parameters         |
|                     |                       | (see files-templates.yml)   |
+--+------------------+-----------------------+-----------------------------+
|  | path             | string ``required``   | Path of the source file.    |
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

Example of template
"""""""""""""""""""

File ``/etc/mail/mailer.conf`` for postfix

[`contrib/postfix/conf-light/files.d/mailer-conf.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/postfix/conf-light/files.d/mailer-conf.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/postfix/conf-light/files.d/mailer-conf.yml
    :language: yaml
    :linenos:
    :emphasize-lines: 2,4

.. seealso::

   * See `files-template.yml  <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-template.yml>`_ how the files are modified or created by the Ansible module ``template``

   * See :ref:`as_files-template.yml` annotated source code

.. note::

   There are couple of templates ready to be used in the directory
   ``templates``. The user is expected to create new templates when
   needed. Feel free to contribute new templates to the `project
   <https://github.com/vbotka/ansible-config-light/>`_.
