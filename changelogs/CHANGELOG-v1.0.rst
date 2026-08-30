============================
vbotka.freebsd Release Notes
============================

.. contents:: Topics


1.0.2
=====

Release Summary
---------------
Update and fix plugins. Update documentation.

Major Changes
-------------

Minor Changes
--------------
* Update filter iocage formatting.
* Update filter documentation.
* Update modules: iocage, ucl.
* Update connection jailexec metadata.
* Update README.md
* Docs. Update included content.
* Tests. Add ignore.txt

Bugfixes
--------
* Update filter ast_to_nginx. Protect the dependency import.
* Update lookup galaxy_info. Checks for MANIFEST.json first (using
  collection_info metadata format) and falls back to galaxy.yml (for editable
  development checkouts). Fix documentation.
* Fix ansible-test sanity.

Breaking Changes / Porting Guide
--------------------------------


1.0.1
=====

Release Summary
---------------
Add role nginx. Update filters.

Major Changes
-------------

Minor Changes
--------------
* Add role nginx 1.0.1
* Update filters.
* Docs. Add example and sandbox 435. Test Nginx.

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------


1.0.0
=====

Release Summary
---------------
Initial release.
