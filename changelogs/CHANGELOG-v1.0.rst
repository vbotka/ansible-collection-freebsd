============================
vbotka.freebsd Release Notes
============================

.. contents:: Topics


0.7.16
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update README.
* Upgrade role packages 2.7.2


0.7.15
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update Galaxy metadata.
* Update requirements.
* Update docs ug_inventory_iocage_*
* Update docs example 207
* Update docs ag and dg.
* Upgrade role config_light 2.7.4
* Upgrade role custom_image 2.7.6
* Upgrade role iocage 0.5.3
* Upgrade role lib 2.7.1
* Upgrade role network 2.7.6
* Upgrade role packages 2.7.1
* Upgrade role pf 2.7.5
* Upgrade role postinstall 2.7.11
* Upgrade role poudriere 2.7.4
* Upgrade role rsnapshot 2.7.3
* Upgrade role zfs 2.7.3


0.7.14
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update README.
* Update docs. Update example 410.
* Update docs. Add example 411.
* Upgrade role rsnapshot to 2.7.2
* Upgrade role postinstall to 2.7.10
* Upgrade role custom_image to 2.7.5


0.7.13
======

Release Summary
---------------
Add role vbotka.freebsd.lib

Major Changes
-------------

Minor Changes
-------------
* Add role vbotka.freebsd.lib 2.7.0
* Update README.
* Update docs. Updated examples.
* Updated docs. Add role vbotka.freebsd.lib
* Updated docs. Add example 410.
* Update documentation URL to the latest (master) branch.


0.7.12
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add role vbotka.freebsd.zfs 2.7.1
* Update docs. Fix links. Add example 400.


0.7.11
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Upgraded roles:
  config_light 2.7.3
  freebsd_custom_image 2.7.4
  freebsd_iocage 0.5.2
  freebsd_postinstall 2.7.9
  freebsd_poudriere 2.7.3
* Updated modules iocage, ucl, and service. Updated documentation and docstrings.
* Updated filter iocage. Updated documentation and docstrings.
* Updated docs.
* Updated examples: 200, 202, 205, 207, 310, 350.
* Added playbook pb_iocage_update_vmm_repos.yml
* Added example 500.


0.7.10
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Upgrade inventory iocage. Added options inventory_hostname_tag and
  inventory_hostname_required.
* Updated docs. Updated examples.
* Added example 020
* Added chapters ug_inventory_iocage_*.rst


0.7.9
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Updated roles: postinstall 2.7.7, poudriere 2.7.2
* Updated docs. Updated example 390.


0.7.8
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Added role poudriere 2.7.1
* Updated role postinstall 2.7.6
* Added dest/collection_docsite.sh
* Updated docs. Added example 390.
* Updated README.


0.7.7
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Updated README.


0.7.6
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Added role custom_image 2.7.3
* Updated README.
* Updated roles:
  config-light 2.7.2
  postinstall 2.7.5


0.7.5
=====

Release Summary
---------------
Maintenance update. Add role pf.

Major Changes
-------------

Minor Changes
-------------
* Add role: pf 2.7.4
* Update roles: network 2.7.5, postinstall 2.7.3
* Add docs examples: 361, 370
* Update docs examples: 202, 203, 330
* Fix playbooks lint errors: run-once


0.7.4
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update module ucl
* Update .gitignore tests/output


0.7.3
=====

Release Summary
---------------
Update role network.


0.7.2
=====

Release Summary
---------------
Remove role info.


0.7.1
=====

Release Summary
---------------
Fix module ucl documentation.


0.7.0
=====

Release Summary
---------------
Major release. Tested with 13.5 and 14.2

Major Changes
-------------
* Docs examples updated to 13.5 and 14.2

Minor Changes
-------------
* Update galaxy.yml; Do not distribute roles/\*/docs"
* Update module ucl.py
* Fix docs pigments.
* Update module service:
  _parse_command_output returns 'void' when stdout is empty.
* Update playbooks. Replace dash by underscore in files and directories.
* Add roles: info, network, rsnapshot
* Add playbooks:
  pb_iocage_destroy_all_jails.yml
  pb_iocage_start_all_jails.yml
  pb_iocage_update_repos.yml


0.6.11
======

Release Summary
---------------
Include role config_light and module ucl. Update docs.

Major Changes
-------------

Minor Changes
-------------
* Add module ucl
* Add role config_light
* Update docs
  Add included_content.rst, ug_module_ucl.rst
  Add examples: 301, 313
  Update examples: 017, 206, 311
  Update local TOC.
* Update setup.

Breaking Changes / Porting Guide
--------------------------------
* Update setup
  Renamed vars-files and variables.
  Changed structures.


0.6.10
======

Release Summary
---------------
Update README and docs.


0.6.9
=====

Release Summary
---------------
Include role vbotka.freebsd.packages

Major Changes
-------------

Minor Changes
-------------
* Update docs
  Add example 311.
  Rename example 100 to 312
  Rename example 101 to 030


0.6.8
=====

Release Summary
---------------
Update README and docs.


0.6.7
=====

Release Summary
---------------
Include role vbotka.freebsd.postinstall. Add example 310.

Major Changes
-------------

Minor Changes
-------------
* Include role vbotka.freebsd.postinstall
* Update docs.
  Add UG example 310. Audit Ansible clients.Use role vbotka.freebsd.postinstall
  Update UG index in example 300.
  Update UG chapter plugins.
  Update UG playbook pb-iocage-template.


0.6.6
=====

Release Summary
---------------
Update module service incl. the docs update.

Major Changes
-------------

Minor Changes
-------------
* Update docs.
  Add pb-test-06.yml and pb-test-07.yml to example 300
* Update module service.
  Update DOCS.
  Add option 'wait' to complete a command.
  Always return changed=False in check_mode.
  Return 'state' for commands that change results of 'status' or 'enabled'


0.6.5
=====

Release Summary
---------------
Upgrade module service incl. docs update.

Major Changes
-------------

Minor Changes
-------------
* Upgrade module service; Add option synopsis; Parse rcvar and status output and
  return the results.
* Update docs example 300.
* Upgrade role pf to 2.7.3


0.6.4
=====

Release Summary
---------------
Maintenance incl. docs update.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage
* Update docs DG Create Collection Docsite.
* Fix link in example 300
* Fix module service documentation.
* Update build_ignore in galaxy.yml
* Update README.


0.6.3
=====

Release Summary
---------------
Add module vbotka.freebsd.service. Update docs.

Major Changes
-------------

Minor Changes
-------------
* Add module vbotka.freebsd.service
* Upgrade role pf.


0.6.2
=====

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Add docs chapter "iocage tags".


0.6.1
=====

Release Summary
---------------
Update playbook pb-iocage-template and update docs.

Major Changes
-------------

Minor Changes
-------------
* Update playbook pb-iocage-template.yml
* Update docs examples and playbooks.

Breaking Changes / Porting Guide
--------------------------------
* Updated playbook pb-iocage-template uses dictionary clones.


0.6.0
=====

Release Summary
---------------
Minor release incl docs update.

Major Changes
-------------
* Upgrade inventory iocage.
* Update playbooks.

Minor Changes
-------------
* Add docs examples: 205, 206
* Update examples: 200, 202, 203, and 204.
* Update playbook pb-iocage-ansible-clients.yml
  Add debug2 tasks.
  Use json_query instead selectattr.

Breaking Changes / Porting Guide
--------------------------------
* Updated playbook pb-iocage-template use dictionary templates.
* Updated playbook pb-iocage-ansible-clients use dictionaries clones.


0.5.5
=====

Release Summary
---------------
Maintenance update incl. updated docs.

Major Changes
-------------

Minor Changes
-------------
* Update docs index.
* Upgrade role vbotka.freebsd_postinstall to 2.6.20
* Upgrade role vbotka.ansible_lib to 2.6.4
* Upgrade filter vbotka.freebsd.iocage. Add option dataset.
* Add docs examples: 204


0.5.4
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update galaxy.yml


0.5.3
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update docs.
* Update galaxy.yml


0.5.2
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Upgrade inventory plugin iocage. Add option hooks_results.
* Upgrade role postinstall to 2.6.19
* The playbooks pb-iocage-template.yml and
  pb-iocage-ansible-clients.yml moved from the examples to playbooks.
* Update examples: 200, 013
* Add examples: 202,203


0.5.1
=====

Release Summary
---------------
Documentation update.

Major Changes
-------------

Minor Changes
-------------
* Fix filter iocage docs.
* Update docs.
* Update docs genindex.


0.5.0
=====

Release Summary
---------------
Minor release. Update plugins, roles and docs.

Major Changes
-------------

Minor Changes
-------------
* Add filter iocage. Parse iocage lists.
* Update inventory plugin iocage.
* Update role iocage.
* Update examples.
* Add example 018.

Bugfixes
--------
#9538 Inventory iocage fails when DHCP is enabled.

Breaking Changes / Porting Guide
--------------------------------
* Upgrade inventory plugin iocage.py. Backward not compatible. In
  multiple interface format the variable iocage_ip4 will be a string
  of comma-separated IPs. New variable iocage_ip4_dict is created.


0.4.7
=====

Release Summary
---------------
Docs update.

Major Changes
-------------

Minor Changes
-------------
* Update example 030.


0.4.6
=====

Release Summary
---------------
Maintenance update incl. docs update.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage.
* Replace deprecated stdout_callback=yaml with callback_result_format=yaml
* Add example 017
* Update example 031


0.4.5
=====

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Update docs.
* Update module iocage.


0.4.4
=====

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Update example 030


0.4.3
=====

Release Summary
---------------
Update docs. Update module iocage.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage.
* Update example 030 (WIP)


0.4.2
=====

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage.
* Add (WIP) examples 030 and 031.


0.4.1
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update README
* Upgrade role vbotka.freebsd.iocage to ver. 0.4.0


0.4.0
=====

Release Summary
---------------
Minor release. Update plugins, roles, and docs.

Major Changes
-------------

Minor Changes
-------------
* Upgrade role vbotka.freebsd.iocage to ver. 0.4.0

Breaking Changes / Porting Guide
--------------------------------
* Upgrade inventory plugin iocage.py. Backward not
  compatible. Parameter env changed to dictionary.


0.3.5
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add Example 030


0.3.4
=====

Release Summary
---------------
Maintenance udpate.

Major Changes
-------------

Minor Changes
-------------
* Update README
* CodeCov badge added to README


0.3.3
=====

Release Summary
---------------
Maintenance udpate.

Major Changes
-------------

Minor Changes
-------------
* Update inventory iocage.
* Update docs.
* Add example 020.


0.3.2
=====

Release Summary
---------------

Major Changes
-------------

Minor Changes
-------------
* Update inventory plugin iocage.
* Update README.
* Update docs.


0.3.1
=====

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Update README.


0.3.0
=====

Release Summary
---------------
Minor release.


0.2.15
======

Release Summary
---------------
Update docs.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage current.
* Update docs UG plugins.
* Fix and update example 013.
* Add examples 015, 016.


0.2.14
======

Release Summary
---------------
Update module iocage. Add docs examples.

Major Changes
-------------

Minor Changes
-------------
* Update module iocage.
* Update README.
* Add links to ug_plugin and examples.
* Add Examples 004, 011, 012, 013, 014.


0.2.13
======

Release Summary
---------------
Upgrade role iocage; Update docs.

Major Changes
-------------

Minor Changes
-------------
* Upgrade role iocage to 0.2.5
* Update setup playbooks.
* Split docs to 3 guides: User, Administrator, and Devel.
* Add docs UG chapter Best Practice.
* Add docs Examples 002 and 003.


0.2.12
======

Release Summary
---------------
Add role iocage_0_2_4


0.2.11
======

Release Summary
---------------
Fix roles dir names.


0.2.10
======

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update plugins and roles default mode. Groups can not write.
* Update docs.
* Update setup.yml. Create links to roles.
* Upgrade role iocage to 0.2.4


0.2.9
=====

Release Summary
---------------
Maintenance update.


0.2.8
=====

Release Summary
---------------
Bug fix and maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update setup.
* Update iocage module.
* Update docs.


0.2.7
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update galaxy.yml documentation.
* Update Plugins.
* Update Example 001 Clone jails and create inventory
* Update docs.
* Update versions in setup/vars/roles.yml


0.2.6
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update README.
* Update galaxy.yml documentation.
* Update Wiki.


0.2.5
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add .readthedocs.yaml


0.2.4
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add dependencies to galaxy.yml
* Add playbook setup/modules-in-role.yml to list dependencies
* Add setup/vars/keywords.yml needed by modules-in-role.yml
* Create docs. Add example: Clone jails and create inventory


0.2.3
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update vars/checksum.yml
* Update inventory/iocage.py
* Update modules/iocage.py


0.2.2
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Update README.
* Update module iocage.yml
* Remove setup/vars/roles.yml.bak
* Remove plugins/inventory/__pycache__/iocage.cpython-312.pyc


0.2.1
=====

Release Summary
---------------
Maintenance update.

Major Changes
-------------

Minor Changes
-------------
* Add distfiles to setup.
* Add requirements.yml
* Fix inventory iocage name.
* Fix module iocage name.
* Update checksum, plugins, plugins_all, plugins_install


0.2.0
=====

Release Summary
---------------
Feature update.

Major Changes
-------------
* Add plugins/modules/iocage.py
* Add plugins/inventory/iocage.py
* Add setup/.configure.yml
* Update setup/setup.yml
* Update playbooks
* Update roles/iocage
* Update galaxy.yml, meta, and tests

Minor Changes
-------------
* Update README.

Bugfixes
--------

Breaking Changes / Porting Guide
--------------------------------
