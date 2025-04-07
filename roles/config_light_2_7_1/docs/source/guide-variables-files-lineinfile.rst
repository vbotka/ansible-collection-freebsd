.. _ug_variables_files_lineinfile:

lineinfile
^^^^^^^^^^

.. contents::
   :local:

Create or configure lines in a file.


Parameters for lineinfile
"""""""""""""""""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file                |
+---------------------+-----------------------+-----------------------------+
| lines               | list ``required``     | lineinfile params. Either   |
|                     |                       | dict or lines is required.  |
+--+------------------+-----------------------+-----------------------------+
|  | regexp           | string ``required``   | Regular expression          |
|  +------------------+-----------------------+-----------------------------+
|  | line             | string ``required``   | Line                        |
|  +------------------+-----------------------+-----------------------------+
|  | backrefs         |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | state            |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | firstmatch       |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | insertafter      |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | insertbefore     |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | ...              | ...                   | <TBD>                       |
+--+------------------+-----------------------+-----------------------------+
| assignment          | string                | Assignment of key and value |
|                     |                       | in dict                     |
+---------------------+-----------------------+-----------------------------+
| dict                | list ``required``     | lineinfile params. Either   |
|                     |                       | dict or lines is required.  |
|                     |                       | (see files-lineinfile.yml)  |
+--+------------------+-----------------------+-----------------------------+
|  | key              | string ``required``   | Key value for regexp        |
|  +------------------+-----------------------+-----------------------------+
|  | value            | string ``required``   | Value for line              |
|  +------------------+-----------------------+-----------------------------+
|  | firstmatch       |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | insertafter      |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | insertbefore     |                       |                             |
|  +------------------+-----------------------+-----------------------------+
|  | ...              | ...                   | <TBD>                       |
+--+------------------+-----------------------+-----------------------------+
| owner               | string                | Owner of the file           |
+---------------------+-----------------------+-----------------------------+
| group               | string                | Group of the file           |
+---------------------+-----------------------+-----------------------------+
| mode                | string                | Mode of the file            |
+---------------------+-----------------------+-----------------------------+
| attributes          | string                | Attributes of the file      |
+---------------------+-----------------------+-----------------------------+
| other               | string                | Attributes of module file   |
+---------------------+-----------------------+-----------------------------+
| create              | boolean               | Create file                 |
+---------------------+-----------------------+-----------------------------+
| validate            | string                | Command to validate file    |
+---------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers            |
+---------------------+-----------------------+-----------------------------+

Example of lineinfile with lines
""""""""""""""""""""""""""""""""

File ``/usr/local/etc/dma/dma.conf`` for `DragonFly Mail Agent <https://www.dragonflybsd.org/handbook/mta/>`_

[`contrib/dma/conf-light/files.d/dma-dmaconf.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/dma/conf-light/files.d/dma-dmaconf.yml>`_]

.. literalinclude:: ../../contrib/dma/conf-light/files.d/dma-dmaconf.yml
    :language: yaml
    :linenos:
    :emphasize-lines: 7

[`contrib/dma/host_vars/srv.example.com/config-light-dma.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/dma/host_vars/srv.example.com/config-light-dma.yml>`_]

.. literalinclude:: ../../contrib/dma/host_vars/srv.example.com/config-light-dma.yml
    :language: yaml
    :linenos:
    :lines: 20-27
    :lineno-start: 20
    :emphasize-lines: 1

Example of lineinfile with dict
"""""""""""""""""""""""""""""""

File ``/usr/local/etc/lighttpd/lighttpd.conf`` for lighttpd

[`contrib/lighttpd/conf-light/files.d/lighttpd-lighttpdconf.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/lighttpd/conf-light/files.d/lighttpd-lighttpdconf.yml>`_]

.. literalinclude:: ../../contrib/lighttpd/conf-light/files.d/lighttpd-lighttpdconf.yml
    :language: yaml
    :linenos:
    :emphasize-lines: 8

[`contrib/lighttpd/host_vars/srv.example.com/cl-lighttpd.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/lighttpd/host_vars/srv.example.com/cl-lighttpd.yml>`_]

.. literalinclude:: ../../contrib/lighttpd/host_vars/srv.example.com/cl-lighttpd.yml
    :language: yaml
    :linenos:
    :lines: 10-15
    :lineno-start: 10
    :emphasize-lines: 1

.. seealso::

   * See `files-lineinfile.yml  <https://github.com/vbotka/ansible-config-light/blob/master/tasks/files-lineinfile.yml>`_ at GitHub how the files are modified or created by the Ansible module ``lineinfile``

   * See :ref:`as_files-lineinfile.yml` annotated source code
