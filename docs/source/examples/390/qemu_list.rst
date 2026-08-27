Test QEMU is running
""""""""""""""""""""

The building of ARM (armv6, armv7, and aarch64) packages on amd64 needs QEMU. If you want to build
ARM packages on amd64 make sure QEMU is running.

.. code-block:: console

   shell> /usr/local/etc/rc.d/qemu_user_static list

.. literalinclude:: out/out-19.txt
   :language: bash
