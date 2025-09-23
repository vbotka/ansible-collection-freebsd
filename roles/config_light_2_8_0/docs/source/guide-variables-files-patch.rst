.. _ug_variables_files_patch:

patch
^^^^^

.. contents::
   :local:

Patch files.

Parameters for patch
""""""""""""""""""""

+---------------------+-----------------------+-----------------------------+
| Parameter           | Type                  | Comments                    |
+=====================+=======================+=============================+
| path                | string ``required``   | Path to file to be patched  |
+---------------------+-----------------------+-----------------------------+
| patch               | dict ``required``     | Parameters of patch module  |
|                     |                       | (see files-patch.yml)       |
+--+------------------+-----------------------+-----------------------------+
|  | src              | string ``required``   | Path of the patch file      |
|  +------------------+-----------------------+-----------------------------+
|  | basedir          | path                  | Apply patch in this dir     |
|  +------------------+-----------------------+-----------------------------+
|  | ...              | ...                   | <TBD>                       |
+--+------------------+-----------------------+-----------------------------+
| handlers            | list                  | List of handlers            |
+---------------------+-----------------------+-----------------------------+

Example of patch
""""""""""""""""

File ``/etc/network.subr`` for */etc/rc.d/wpa_cli*

[`contrib/freebsd-custom-image-wpacli/conf-light/files.d/network_subr.yml <https://github.com/vbotka/ansible-config-light/blob/master/contrib/freebsd-custom-image-wpacli/conf-light/files.d/network_subr.yml>`_]

.. literalinclude:: ../../contrib/freebsd-custom-image-wpacli/conf-light/files.d/network_subr.yml
    :language: yaml
    :linenos:
    :emphasize-lines: 2,4

.. seealso::

   * See :ref:`as_files-patch.yml` annotated source code
   * See details about the example in the role `vbotka.freebsd_wpa_cli <https://galaxy.ansible.com/vbotka/freebsd_wpa_cli>`_
