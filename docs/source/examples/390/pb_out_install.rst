poudriere - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -t poudriere_pkg -e poudriere_install=true pb.yml

.. literalinclude:: out/out-02.txt
   :language: yaml
   :force:
