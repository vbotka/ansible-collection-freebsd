.. _ag_create_collection_docsite:

Create collection docsite
*************************

See `Creating a collection docsite <https://ansible.readthedocs.io/projects/antsibull-docs/collection-docs/>`_.

For example, given the collection is installed in the directory ::

  ~/.ansible/collections/ansible_collections/vbotka/freebsd/

Create the collection docsite in this directory

.. code:: console

   (env) > cd ~/.ansible/collections/ansible_collections/vbotka/freebsd/
   (env) > python3 -m pip install ansible-core antsibull-docs
   (env) > export ANSIBLE_COLLECTIONS_PATH=~/.ansible/collections
   (env) > antsibull-docs lint-collection-docs --plugin-docs .
   (env) > mkdir dest
   (env) > chmod g-w dest
   (env) > antsibull-docs sphinx-init --use-current --squash-hierarchy vbotka.freebsd --dest-dir dest
   (env) > cd dest
   (env) > python3 -m pip install -r requirements.txt
   (env) > ./build.sh

Upon successful build, you'll see the message ::

  The HTML pages are in build/html.
  ~/.ansible/collections/ansible_collections/vbotka/freebsd/dest


Open the local doc page in a browser ::

  ~/.ansible/collections/ansible_collections/vbotka/freebsd/dest/build/html/index.html

.. seealso::

   * `Documenting collections <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_documenting.html#documenting-collections>`_.
   * `docs directory <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_structure.html#docs-directory>`_.
