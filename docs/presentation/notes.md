# FreeBSD Jails Orchestration with Ansible

Presenter Notes.

Good afternoon ...


## (2) Contents

* We start with a brief overview of FreeBSD and Ansible. The goal is to present
  the idea that FreeBSD Ansible collection is needed.

* Then, we review the proposed FreeBSD collection with the focus on the iocage
  plugins.

* In this tutorial, there are approx. 30 examples in 4 categories:
  - installation and configuration of an iocage host
  - usage of the iocage plugins
  - creation of FreeBSD jails as Ansible remote hosts
  - orchestration of the FreeBSD jails by Ansible


# Section 1


## (3) Introduction

TBD


## (4) Why Ansible?

There are many system management tools. We decided to pick Ansible because it is
the leading tool ...


## (5) Does Ansible work with FreeBSD?

TBD


## (6) Ansible collections

There are more than 100 collections included in the Ansible distribution.

Ansible introduced the collection in the version 2.8. This feature provides a
new distribution format for Ansible content, including playbooks, roles, and
plugins. This fragmentation was necessary to keep the tools maintainable.

The introduction of collections allowed for several key changes:

Independent release cycles: Content maintainers could develop and release their
plugins outside of the main Ansible core release cycle, allowing for quicker bug
fixes and feature additions.

Improved organization: Collections help structure content into logical,
project-specific units, reducing namespace collisions and managing the large
number of plugins in the core repository.

Centralized hub: Ansible Galaxy became the primary platform for sharing and
finding community-contributed collections.

Certified content: Red Hat introduced the concept of certified collections
available through the Red Hat Automation Hub.


## (7) Ansible collections ansible.*

TBD


## (8) Ansible collections community.*

TBD


## (9) Ansible collection dedicated to FreeBSD is needed

TBD


# Section 2


## (10) FreeBSD collection


# Section 3


## (23) Examples


## (24) Example groups

[examples](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_examples.html)


## (25) How to use the examples


## (26) Notes


# Section 4

## (27) Install, configure, and activate iocage

[Manage iocage](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_examples.html)


## (28) example 001: Install Iocage

Click at the `source code` link and at the `results`

The `source code` link shows the directory of this example and the `results` link shows the description in the documentation. 

Let's review the role `vbotka.freebsd.iocage`. Open the link `role vbotka.freebsd.iocage`. This is the Ansible Galaxy page of the collection showing the README file of the role `freebsd_iocage`

All roles included in this collection have got repositories in the GitHub and are published as standalone roles in Ansible Galaxy. For example, this role is named `freebsd_iocage` in the Ansible Galaxy name space `vbotka` and is named
simply `iocage` in the collection. Clink the link `Ansible role`.

See the [Naming conventions](https://ansible-collection-freebsd.readthedocs.io/en/latest/ag_setup_roles.html#naming-convention)
in the `Administration guide`. If there is time, we'll explain the setup of the collection later.

You can use the standalone roles or the roles included in the collection. The code is the same.

Take a look at the directory [roles](https://github.com/vbotka/ansible-collection-freebsd/tree/master/roles)

You see what versions of the roles are included in the collection. The names of the roles are links to the versions.

Take a look at the tasks of the role
[ansible-freebsd-iocage/tasks/main.yml](https://github.com/vbotka/ansible-freebsd-iocage/blob/master/tasks/main.yml)

For now, we only demonstrate how the role works and in this example we only
display variables and install the package iocage.

Take a look at the:

- inventory `iocage.ini`
- playbook `pb-iocage.yml`
- `batch.sh`

The first play selects the tag `freebsd_iocage_debug` and enables `freebsd_iocage_debug` (Describe the debug variables.)

The second play selects the tag `freebsd_iocage_pkg` The package has already beed installed. Therefor we see the message `package(s) already present`


## (29) example 002: Activate iocage

Click at the `source code` link and at the `results`


## (30) example 003: Audit iocage host

Click at the `source code` link and at the `results`


# EOF
