poudriere - debug
^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_debug \
                                  -e poudriere_debug=true

.. literalinclude:: out/out-01.txt
    :language: bash
