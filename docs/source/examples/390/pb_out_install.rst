poudriere - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook pb.yml -t poudriere_pkg -e poudriere_install=true

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:
