Create ports
""""""""""""

::

   shell> poudriere ports -c -m git+https -B main
   [00:00:00] Creating default fs at /usr/local/poudriere/ports/default... done
   [00:00:00] Cloning the ports tree... done

Update ports tree, if already created ::

  shell> poudriere ports -u -m git+https -B main
  [00:00:00] Updating portstree "default" with git+https... done

.. seealso:: man `poudriere-ports`_

.. _poudriere-ports: https://man.freebsd.org/cgi/man.cgi?query=poudriere-ports
