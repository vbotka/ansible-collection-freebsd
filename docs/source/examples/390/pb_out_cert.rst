poudriere - generate SSL certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Optionally, create a SSL certificate for the web server. These tasks are disabled by default.

.. code-block:: console

   (env) > ansible-playbook pb.yml -t poudriere_cert -e poudriere_cert=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:
