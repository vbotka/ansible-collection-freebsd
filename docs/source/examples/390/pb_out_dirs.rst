poudriere - create SSL directories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_dirs

.. literalinclude:: out/out-03.txt
    :language: bash
