.. _dg_clone_git:

Clone Git repository
--------------------

To install the latest version, clone the ``devel`` branch:

.. code-block:: console

   shell> git clone -b devel https://github.com/vbotka/ansible-collection-freebsd.git

Rename the cloned directory to ``freebsd``:

.. code-block:: console

   shell> mv ansible-collection-freebsd freebsd

Export ``ANSIBLE_COLLECTIONS_PATH``. For example, if you cloned the
repository into the directory ``/scratch/collections/ansible_collections/vbotka``:

.. code-block:: console

   shell> export ANSIBLE_COLLECTIONS_PATH=/scratch/collections

In your Python virtual environment, make sure the collection is visible:

.. code-block:: console

   (env) > ansible-galaxy collection list vbotka.freebsd

   # /scratch/collections/ansible_collections
   Collection     Version
   -------------- -------
   vbotka.freebsd 1.1.1
