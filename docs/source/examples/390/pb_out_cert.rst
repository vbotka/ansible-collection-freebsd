poudriere - generate SSL certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Optionally, create a SSL certificate for the web server. These tasks are disabled by default.

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com \
                                  -t poudriere_cert \
                                  -e poudriere_cert=true

.. literalinclude:: out/out-05.txt
   :language: yaml
   :force:
