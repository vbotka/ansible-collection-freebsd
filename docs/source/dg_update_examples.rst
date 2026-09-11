.. _dg_update_examples:

Update examples
***************

Run the script ``docs/source/examples/batch.sh``.

Environment
-----------

Inspect the script to see how the following environment variables are used:

* ``VBOTKA_FREEBSD_BATCH``
* ``VBOTKA_FREEBSD_COPY_ORIG``
* ``VBOTKA_FREEBSD_DESTROY_JAILS``
* ``VBOTKA_FREEBSD_DESTROY_TEMPLATES``
* ``VBOTKA_FREEBSD_RUN_BATCH``

host_key_checking
-----------------

Disable `HOST_KEY_CHECKING`_ in ``ansible.cfg`` to avoid connection errors in the examples:

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
-------------------

To adapt the examples to your environment, update:

* ``ansible_host`` in ``iocage.ini`` files
* ``host`` in ``hosts/*.yml`` files
* IPs in ``docs/source/examples/defaults/batch``
* Files in ``files/*``

Update files
------------

.. code-block:: console

   (env) > find . -type d -name files | xargs ls -1
   ./source/examples/200/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san
   pkgs.json

   ./source/examples/202/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san
   pkgs.json

   ./source/examples/208/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san
   pkgs.json

   ./source/examples/209/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san
   pkgs.json

   ./source/examples/310/files:
   pk_admins.txt
   pk_admins.txt.orig
   pk_admins.txt.san

   ./source/examples/321/files:
   build.example.com-sk.crt

   ./source/examples/422/files:
   info.php

.. note::

   The ``*.orig`` files are excluded from:

   * The collection (see ``galaxy.yml``)
   * Git tracking (see ``.gitignore``)
