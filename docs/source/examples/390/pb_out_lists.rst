poudriere - create package lists
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_pkglists

.. literalinclude:: out/out-07.txt
    :language: bash
