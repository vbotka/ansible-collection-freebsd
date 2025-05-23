Result - package lists
^^^^^^^^^^^^^^^^^^^^^^

::

  (env) > ssh admin@build.example.com tree /usr/local/etc/poudriere.d/pkglist

.. literalinclude:: out/out-12.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/amd64/ansible

.. literalinclude:: out/out-13-amd64.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/amd64/minimal

.. literalinclude:: out/out-14-amd64.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/arm/ansible

.. literalinclude:: out/out-13-arm.txt
   :language: bash

::

  (env) > ssh admin@build.example.com cat /usr/local/etc/poudriere.d/pkglist/arm/minimal

.. literalinclude:: out/out-14-arm.txt
   :language: bash
