postinstall - run QEMU
^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-postinstall.yml -i build-hosts.ini -l build.example.com -t fp_qemu

.. literalinclude:: out/out-17.txt
   :language: bash
