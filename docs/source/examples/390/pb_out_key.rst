poudriere - generate signing key
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_key

.. literalinclude:: out/out-04.txt
   :language: yaml
   :force:
