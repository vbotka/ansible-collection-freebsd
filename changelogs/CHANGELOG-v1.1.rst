================================
vbotka.freebsd 1.1 Release Notes
================================

.. contents:: Topics


1.1.1
=====

Release Summary
---------------

Major Changes
-------------

Minor Changes
--------------
* Docs. Update UG installation options.

Bugfixes
--------
* Fix filter combine_properties documentation.


1.1.0
=====

Release Summary
---------------
Ansible 2.21.5 upgrade. Remote hosts tested with 14.5 and 15.1

Major Changes
-------------
* Add module cgetent.
* Add filters ast_to_haproxy, clean_unsafe, combine_properties, project, and
  to_ast.
* Upgrade role dhcp to 2.9.1
* Upgrade role haproxy to 1.0.1
* Upgrade role nginx to 1.0.2
* Upgrade role packages to 2.9.9
* Upgrade role pf to 2.9.3
* Upgrade role postinstall to 2.9.4

Minor Changes
--------------
* Docs. Update Guides.
* Docs. Add examples.
* Docs. Add Sphinx dark theme sphinx_rtd_dark_mode
* Docs. Add CSS custom_dark.css
* Docs. Update requirements.txt

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------
* Filter dict_to_ast renamed to to_ast.
