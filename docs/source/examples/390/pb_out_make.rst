poudriere - customize make
^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_make

.. literalinclude:: out/out-08.txt
    :language: bash
