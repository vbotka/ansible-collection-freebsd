.. _ug_tags:

Tags
****

The tags provide a handy tool to run selected tasks of the role. The
below command lists the available tags

.. code-block:: bash
   :emphasize-lines: 1
   :linenos:

    shell> ansible-playbook pb.yml --list-tags

    playbook: pb.yml

      play #1 (srv.example.com): srv.example.com	TAGS: []
      TASK TAGS: [always, cl_debug, cl_files, cl_packages, cl_sanity,
      cl_services, cl_setup, cl_states, cl_vars]

For example, using the tag *cl_debug* displays the variables and
their values when ``cl_debug=true``. With this tag specified ``-t
cl_debug`` the tasks *vars.yml* will also run because of the tag
*always* ::

    shell> ansible-playbook pb.yml -t cl_debug -e cl_debug=true

See what packages will be installed ::

    shell> ansible-playbook pb.yml -t cl_packages --check

Install packages and exit the play ::

    shell> ansible-playbook pb.yml -t cl_packages

.. seealso::

   * See :ref:`ug_bp` on how to use tags efficiently

   * See :ref:`as_main.yml` annotated source code

.. hint::

   * Do not display skipped hosts. Set ``ANSIBLE_DISPLAY_SKIPPED_HOSTS=false`` ::

      shell> ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook pb.yml -t cl_debug
