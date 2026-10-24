postinstall - install QEMU
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -t fp_packages -e fp_install=true pb-postinstall.yml

.. literalinclude:: out/out-16.txt
   :language: yaml
   :force:
