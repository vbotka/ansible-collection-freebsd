poudriere - all tasks
^^^^^^^^^^^^^^^^^^^^^

Optionally, do not display *ok* hosts

::

  (env) > ANSIBLE_DISPLAY_OK_HOSTS=false \
          ansible-playbook pb.yml -i build-hosts.ini -l build.example.com \
                                  -e poudriere_install=true
                                  -e poudriere_cert=true

.. literalinclude:: out/out-09.txt
    :language: bash
