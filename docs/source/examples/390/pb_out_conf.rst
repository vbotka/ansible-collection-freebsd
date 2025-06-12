poudriere - configure Poudriere
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ansible-playbook pb.yml -i build-hosts.ini -l build.example.com -t poudriere_conf

.. literalinclude:: out/out-06.txt
   :language: yaml
   :force:
