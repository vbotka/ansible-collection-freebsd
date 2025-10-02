.. _ug_variables_states:

States
======

.. contents::
   :local:

Synopsis
^^^^^^^^

The dictionary ``cl_states`` comprises the states of the managed files. If mounted, the ``path`` is
unmounted when ``state`` is in the list ``cl_states_unmount`` (default=absent) ::

  cl_states_unmount: [absent, unmounted]

Then, the module ``file`` is applied if ``state`` is in the list ``cl_states_file`` (default=file)
::

  cl_states_file: [absent, directory, file, hard, link, touch]

In the end, the ``path`` is mounted if ``state`` is in the list ``cl_states_mount`` (default=absent)
::

  cl_states_mount: [present, mounted, remounted]

The variables ``cl_states_unmount, cl_states_mount, cl_states_file`` are declared in
``defaults/main.yml``. Details of the parameters are described in the modules ``mount`` and
``file``.

Parameters
^^^^^^^^^^

+---------------------+-----------------------+---------------------------------------+
| Parameter           | Type                  | Comments                              |
+=====================+=======================+=======================================+
| path                | string ``required``   | Path to file.                         |
+---------------------+-----------------------+---------------------------------------+
| state               | string                | State of the file.                    |
+---------------------+-----------------------+---------------------------------------+
| owner               | string                | Owner of the file.                    |
+---------------------+-----------------------+---------------------------------------+
| group               | string                | Group of the file.                    |
+---------------------+-----------------------+---------------------------------------+
| mode                | string                | Mode of the file.                     |
+---------------------+-----------------------+---------------------------------------+
| ...                 | ...                   | <TBD: see tasks/states.yml>           |
+---------------------+-----------------------+---------------------------------------+


Examples
^^^^^^^^

Lighttpd document root ownership and permissions
""""""""""""""""""""""""""""""""""""""""""""""""

[`contrib/lighttpd/conf-light/states.d/lighttpd-server-document-root.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/lighttpd/conf-light/states.d/lighttpd-server-document-root.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/lighttpd/conf-light/states.d/lighttpd-server-document-root.yml
    :language: yaml
    :emphasize-lines: 2
    :linenos:


Delete snap directories
"""""""""""""""""""""""

[`contrib/ubuntu-snap-disable/conf-light/states.d/snap.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/ubuntu-snap-disable/conf-light/states.d/snap.yml>`_]

.. highlight:: yaml
    :linenothreshold: 5
.. literalinclude:: ../../contrib/ubuntu-snap-disable/conf-light/states.d/snap.yml
    :language: yaml
    :emphasize-lines: 2,5,8
    :linenos:

.. seealso::

   * See ``shell> ansible-doc -t module mount``
   * See ``shell> ansible-doc -t module file``
   * :ref:`as_vars-states.yml`
   * :ref:`as_states.yml`
