.. _dg_update_examples:

Update examples
---------------

.. contents::
   :local:
   :depth: 2

Configure examples
******************

See ``docs/source/examples/.configure.yml``.

host_key_checking
*****************

If needed, disable `HOST_KEY_CHECKING`_ in ``ansible.cfg`` to avoid connection
errors in the examples:

.. code-block:: ini
   :emphasize-lines: 5

   [defaults]
   gathering = explicit
   callback_result_format = yaml
   display_skipped_hosts = false
   host_key_checking = false

   [connection]
   pipelining = true

Contribute examples
*******************

To adapt the examples to your environment, update:

* ``iocage.ini`` files
* ``hosts`` or ``hosts/*.yml`` files
* ``files/*``

Update files
************

List ``files`` in ``docs/source/examples/``:

.. code-block:: console

   (env) > find . -type d -name files | xargs ls -1

.. code-block:: console

   ./source/examples/200/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san
   pkgs.json

   ...

   ./source/examples/321/files:
   build.example.com-sk.crt

   ./source/examples/422/files:
   info.php

.. note::

   The ``*.orig`` files are excluded from:

   * The collection (see ``galaxy.yml``)
   * Git tracking (see ``.gitignore``)

Environment
***********

Inspect the script ``docs/source/examples/batch.sh`` to see how the following
environment variables are used:

* ``VBOTKA_FREEBSD_BATCH``
* ``VBOTKA_FREEBSD_COPY_ORIG``
* ``VBOTKA_FREEBSD_DESTROY_JAILS``
* ``VBOTKA_FREEBSD_DESTROY_TEMPLATES``
* ``VBOTKA_FREEBSD_RUN_BATCH``

Update examples
***************

Run the script ``docs/source/examples/batch.sh``.