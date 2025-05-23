poudriere - install packages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkg \
                                  -e poudriere_install=true

.. literalinclude:: out/out-02.txt
    :language: bash
