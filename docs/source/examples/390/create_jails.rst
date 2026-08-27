Create jails
""""""""""""

.. seealso::

   * man `poudriere-jail`_
   * FreeBSD Wiki `Building Packages Through Emulation`_

.. hint:: The directory */usr/obj/* is used to build the world. Make sure there is enough disk space.

amd64
=====

::

  shell> poudriere jail -c -j 142amd64 -v 14.2-RELEASE
  ...

Update the jail if already created.

::

  shell> poudriere jail -u -j 142amd64 -v 14.2-RELEASE
  [00:00:00] Upgrading using http
  Looking up update.FreeBSD.org mirrors... 3 mirrors found.
  Fetching metadata signature for 14.2-RELEASE from update2.freebsd.org... done.
  Fetching metadata index... done.
  Inspecting system... done.
  Preparing to download files... done.

  No updates needed to update system to 14.2-RELEASE-p3.
  14.2-RELEASE-p3
  [00:00:51] Recording filesystem state for clean... done

aarch64
=======

::

  shell> poudriere jail -c -j 142aarch64 -m http -v 14.2-RELEASE -a arm64.aarch64 -x
  ...
  14.2-RELEASE-p3
  [01:10:21] Recording filesystem state for clean... done
  [01:10:21] Jail 142aarch64 14.2-RELEASE-p3 arm64.aarch64 is ready to be used

.. note:: Building aarch64 packages on amd64 needs QEMU.

armv6
=====

::

  shell> poudriere jail -c -j 135armv6 -m git+https -v releng/13.5 -a arm.armv6 -x
  ...
  [04:03:27] Recording filesystem state for clean... done
  [04:03:27] Jail 135armv6 13.5-RELEASE-p1 1305000 arm.armv6 is ready to be used

.. note:: Building armv6 packages on amd64 needs QEMU.

.. _Building Packages Through Emulation: https://wiki.freebsd.org/Ports/BuildingPackagesThroughEmulation
.. _poudriere-jail: https://man.freebsd.org/cgi/man.cgi?query=poudriere-jail
