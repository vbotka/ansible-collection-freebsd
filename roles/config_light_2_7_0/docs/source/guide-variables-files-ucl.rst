.. _ug_variables_files_ucl:

ucl
^^^

.. contents::
   :local:

Create or configure UCL files.


Parameters for ucl
""""""""""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file                |
+---------------------+-----------------------+-----------------------------+

<TODO>

+--+------------------+-----------------------+-----------------------------+
| owner               | string                | Owner of the file           |
+---------------------+-----------------------+-----------------------------+
| group               | string                | Group of the file           |
+---------------------+-----------------------+-----------------------------+
| mode                | string                | Mode of the file            |
+---------------------+-----------------------+-----------------------------+
| attributes          | string                | Attributes of the file      |
+---------------------+-----------------------+-----------------------------+
| create              | boolean               | Create file                 |
+---------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers            |
+---------------------+-----------------------+-----------------------------+


Example of ucl
""""""""""""""

<TODO: No example yet>

.. seealso::

   * See :ref:`as_files-ucl.yml` annotated source code
   * Ansible module `vbotka.freebsd.ucl`_


.. _vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/
