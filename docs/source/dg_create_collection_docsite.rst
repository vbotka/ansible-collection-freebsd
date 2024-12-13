.. _dg_create_collection_docsite:

Create collection docsite
*************************

See `Creating a collection docsite <https://ansible.readthedocs.io/projects/antsibull-docs/collection-docs/>`_.

Upon successful build, open the local page in a browser ::
  
  file:///<path_to_collections>/collections/ansible_collections/vbotka/freebsd/dest/build/html/collections/vbotka/freebsd/index.html

Don't forget to rebuild the page after you upgrade the collection ::

  shell> cd dest
  shell> ./build.sh

.. seealso::

   * `Documenting collections <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_documenting.html#documenting-collections>`_.
   * `docs directory <https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_structure.html#docs-directory>`_.
