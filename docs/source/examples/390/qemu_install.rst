postinstall - install QEMU
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb-postinstall.yml -t fp_packages -e fp_install=true

.. literalinclude:: out/out-16.txt
   :language: yaml
   :force:
