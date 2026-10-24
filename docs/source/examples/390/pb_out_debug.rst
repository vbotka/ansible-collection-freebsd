poudriere - Display variables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: console

   (env) > ansible-playbook -t poudriere_debug -e poudriere_debug=true pb.yml

.. literalinclude:: out/out-01.txt
   :language: yaml
   :force:
