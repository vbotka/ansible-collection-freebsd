.. _ug_variables_handlers:

Handlers
========

.. contents::
   :local:

Synopsis
^^^^^^^^

The dictionary *cl_handlers* comprises data to create handlers. The
structure of the dictionary depends on the template that creates the
files with the handlers. For example, the structure below can be used
together with the template *handlers-auto1.yml.j2*.

Parameters
^^^^^^^^^^

.. list-table::
   :widths: 20 20 50
   :header-rows: 1

   * - Parameter
     - Type
     - Comments
   * - template
     - string ``required``
     - Template filename
   * - handlers
     - list ``required``
     - List of handlers dictionaries
   * - ``-`` handler
     - string ``required``
     - Name of the handler
   * - ``-`` listen
     - string
     - Topic to listen to
   * - ``-`` module
     - string ``required``
     - Ansible module in handler
   * - ``-`` params
     - list ``required``
     - Ansible module parameters
   * - ``-`` conditions
     - list
     - List of conditions

Version control
^^^^^^^^^^^^^^^

The role is distributed with no handlers and empty file *main.yml*

.. code-block:: yaml

   shell> cat handlers/main.yml
   ---
   # handlers

It's up to you whether you include the changed *main.yml* and created
handlers in the version control. In git, run the below command to
ignore changes in *main.yml* ::

   shell> git update-index --assume-unchanged handlers/main.yml

To ignore the created handlers put into the *.gitignore* ::

   handlers/*.yml


Examples
^^^^^^^^

FreeBSD handlers for Postfix
""""""""""""""""""""""""""""

[`contrib/postfix/conf-light/handlers.d/postfix-freebsd.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/postfix/conf-light/handlers.d/postfix-freebsd.yml>`_]

.. literalinclude:: ../../contrib/postfix/conf-light/handlers.d/postfix-freebsd.yml
    :language: yaml
    :emphasize-lines: 2,5,12,19,27,35,40
    :linenos:

Create the handlers ::

  shell> ansible-playbook pb.yml -t cl_vars -e cl_setup=true

Take a look at the file with the handlers ::

  shell> cat roles/vbotka.config_light/handlers/handlers-auto-postfix_freebsd.yml

.. literalinclude:: ../samples/handlers-auto-postfix_freebsd.yml
    :language: yaml
    :linenos:
    :emphasize-lines: 5,11,17,24,31,35

The file is imported into the *handlers/main.ym* ::

  shell> grep handlers-auto-postfix_freebsd.yml roles/vbotka.config_light/handlers/main.yml
  - import_tasks: handlers-auto-postfix_freebsd.yml # noqa: name[missing]

There is no *name* in this task. The comment ``# noqa: name[missing]``
prevents *ansible-lint* from complaining about missing *name*.


.. seealso::

   * the template `handlers-auto1.yml.j2  <https://github.com/vbotka/ansible-config-light/blob/master/templates/handlers-auto1.yml.j2>`_

   * :ref:`as_vars-handlers.yml`

   * :ref:`as_setup.yml`
	     
.. note::

   The template *handlers-auto1.yml.j2* is available in the role's
   directory ``templates``. The user is expected to create new
   templates when needed. Feel free to change the structure of the
   data and to create new templates that might fit the purpose
   better. Feel free to contribute new templates and configuration
   examples to the `project <https://github.com/vbotka/ansible-config-light/>`_.
