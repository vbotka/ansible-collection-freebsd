Create jails
""""""""""""

::

  shell> poudriere jail -c -j 142aarch64 -m http -v 14.2-RELEASE -a arm64.aarch64 -x
  ...
  14.2-RELEASE-p3
  [01:10:21] Recording filesystem state for clean... done
  [01:10:21] Jail 142aarch64 14.2-RELEASE-p3 arm64.aarch64 is ready to be used

::

  shell> poudriere jail -c -j 135armv6 -m git+https -v releng/13.5 -a arm.armv6 -x
  ...
  [04:03:27] Recording filesystem state for clean... done
  [04:03:27] Jail 135armv6 13.5-RELEASE-p1 1305000 arm.armv6 is ready to be used

.. note:: The directory */usr/obj/* is used to build the world. Make sure there is enough disk space.

.. seealso:: `Building Packages Through Emulation`_

.. _Building Packages Through Emulation: https://wiki.freebsd.org/Ports/BuildingPackagesThroughEmulation
