.. _ug_variables_files_ucl:

ucl
^^^

.. contents::
   :local:

Create or configure UCL files.

Parameters
""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file.               |
+---------------------+-----------------------+-----------------------------+
| ucl                 | list ``required``     |                             |
+--+------------------+-----------------------+-----------------------------+
|  | upath            | string                | The key in object notation. |
|  +------------------+-----------------------+-----------------------------+
|  | value            | string                | The selected upath value.   |
|  +------------------+-----------------------+-----------------------------+
|  | <TODO>           |                       | see vbotka.freebsd.ucl      |
+--+------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers.           |
+---------------------+-----------------------+-----------------------------+

Example
"""""""

<TODO: No example yet>

.. seealso::

   * See :ref:`as_files-ucl.yml` annotated source code
   * Ansible module `vbotka.freebsd.ucl`_


.. _vbotka.freebsd.ucl: https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/ucl/
