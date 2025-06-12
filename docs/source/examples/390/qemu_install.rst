postinstall - install QEMU
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb-postinstall.yml -i build-hosts.ini -l build.example.com -t fp_packages

.. literalinclude:: out/out-16.txt
   :language: yaml
   :force:
