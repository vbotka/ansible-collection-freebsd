poudriere - all tasks
^^^^^^^^^^^^^^^^^^^^^

Optionally, do not display ``ok`` hosts

.. code-block:: console

   (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
          ansible-playbook pb.yml -e poudriere_install=true -e poudriere_cert=true

.. literalinclude:: out/out-09.txt
   :language: yaml
   :force:
