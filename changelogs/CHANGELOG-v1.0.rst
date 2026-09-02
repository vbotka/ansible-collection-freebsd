============================
vbotka.freebsd Release Notes
============================

.. contents:: Topics


1.1.0
=====

Release Summary
---------------

Major Changes
-------------
* Role iocage_template upgraded to 1.4.0

Minor Changes
--------------
* Docs. Update example 529.
* Role iocage_template 1.4.0 tested in sandbox 435, 917-929.

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------
* See GitHub Release Notes ansible-freebsd-iocage-template.


1.0.3
=====

Release Summary
---------------
Upgrade role iocage_template. Mount and configure pkg repo.

Major Changes
-------------

Minor Changes
--------------
* Upgrade role iocage_template to 1.3.6
* Update pb_iocage_project_create.yml; change default template ansible_client to
  ansible-client.
* Docs. Update examples 523-528
* Docs. Add example 529 and sandbox 928; mount fs and configure repo in
  ansible-init.
* Docs. Update project-hosts.yml in sandbox.
* Update galaxy.yml; do not distribute jailexec.

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------


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
