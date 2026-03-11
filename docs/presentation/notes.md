# FreeBSD Jails Orchestration with Ansible
  Presenter Notes

Good afternoon ...

You can download this notes from (TBD link to GitHub).


## (2) Contents

We start with a brief overview of FreeBSD and Ansible. The main goal is to present the idea that
FreeBSD Ansible collection is needed and propose how to proceed to create such a collection.

We will review the proposed FreeBSD collection with the focus on the iocage plugins.

In this tutorial, there are approx. 30 examples in 4 categories:
  - installation and configuration of an iocage host
  - usage of the iocage plugins
  - creation of FreeBSD jails as Ansible remote hosts
  - orchestration of the FreeBSD jails by Ansible

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Section 1


## (3) Introduction

I'm not sure how many time we will have for questions at the end of the presentation. Therefore, do
not hesitate and ask immediatelly.

Important question is: Do you need your Ansible code to also cover other systems in parallel to
FreeBSD? This means, do you have to write your playbooks, roles, and plugins to manage also other
systems in parallel to FreeBSD?  This question is crucial. The code is much simpler if you cover
FreeBSD only. In this presentation, we focus on the FreeBSD management by Ansible. So, you can write
your own FreeBSD playbooks, roles, and plugins.

(Simple module example)

Goals of this presentation:
  - try to analyze FreeBSD specifics
  - try to explain Ansible options
  - explain the current status of the proposed FreeBSD collection.


## (4) Why Ansible?

* There are many system management tools. We decided to pick Ansible because it is the leading tool.

* AI generated code: fine, but you have to know what you want. I other words, you have to ask good
  questions. This presentation is to help ask good questions.

  AI is not a subject of this presentation. But, still, what is the latest Ansible AI status?

  At the moment it can be described as `IT automation with agentic AI`

  1) Introducing the `Model Context Protocol` MCP server for Red Hat Ansible Automation Platform (technology preview)
     [MCP for Ansible](https://www.redhat.com/en/blog/it-automation-agentic-ai-introducing-mcp-server-red-hat-ansible-automation-platform)
     [Deploying MCP](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.6/html/containerized_installation/deploying-ansible-mcp-server)
     [AAP MCP Service](https://github.com/ansible/aap-mcp-server)

  2) The integration of Ansible, `Model Context Protocol` (MCP), and `ARA` Records enables `AI-powered, conversational monitoring and troubleshooting of Ansible playbooks`.
     See [ARA](https://ara.recordsansible.org/)
	 "ARA Records Ansible and makes it easier to understand and troubleshoot."

  3) [Ansible Development Tools MCP Server](https://docs.ansible.com/projects/vscode-ansible/mcp/)

Note: MCP (Model Context Protocol) is an open standard that enables AI models to use external AI tools and services via a unified interface.
      Using the Ansible MCP server, you can connect your Ansible Automation Platform with your preferred external AI tool (such as Claude, Cursor, or ChatGPT).

* [Ansible Forum](https://forum.ansible.com/) is the main Ansible social network. If you use Ansible, join this forum.

* Latest status of Ansible was extensively presented at the
  [CfgMgmtCamp 2026 February 2, 2026](https://forum.ansible.com/t/cfgmgmtcamp-2026/44250)
  tag: cfgmfmftcamp

  Major changes in Ansible 2.19.
  - See the CfgMgmtCamp 2026  videos at youtube.com (search "CfgMgmtCamp 2026")
  - Read the [threads](https://forum.ansible.com/tag/cfgmgmgtcamp)

  Ansible introduced data tagging in core 2.19
  There are some undocumented changes. Not mentioned in the release notes. For example, see
  [Type ‘GroupTuple’ is unsupported in variable storage](https://forum.ansible.com/t/type-grouptuple-is-unsupported-in-variable-storage/44513)

Quoting Ansible:

> We don’t have knowledge of every python type returned by every filter out there … try to let you know there is something that needs done."

  Topic closed with the conclusion:
  - Is this a bug? `No`
  - Do I have to explicitly convert all such filters to eliminate these particular warnings (and errors)? `Yes`
  - Is the user now responsible for handling this? `Yes`

  To learn what to expect, see [CfgMgmtCamp 2026 B.1.014 -- Ansible Contributor Summit](https://www.youtube.com/watch?v=I5-T-RuhJzY&t=106s)

  Take a look at other recorded presenations. For example,

   - Felix Fontein (@felixfontein) Ansible Steering Committee Member and
     Maintainer of the collection community.general

     * Problems in the Ansible world and how to improve on them
       https://gist.github.com/felixfontein/72562a7bd35bad62ee7c849af533a76e

  - Konstantin Volenbovskyi

    * Upgrade to Ansible 12 (core 2.19)
      Ansible Style Guide
      https://github.com/abacusresearch/ansible-style-guide/blob/main/Ansible_Style_Guide_CfgMgmtCamp2026.pdf


  - Writing, running, and testing awesome Ansible content with natural language and AI - powered by Ansible's MCP server
    https://cfp.cfgmgmtcamp.org/ghent2026/talk/WG9ST8/

* It is not all that cool. There are also problems.

  - Ansible Lint.(There are ~100 open [issues](https://github.com/ansible/ansible-lint/issues)

  - Ansible Galaxy issues
    - https://forum.ansible.com/latest
      "We aware that ansible.galaxy.com is currently throwing 500 errors and Collection can not be downloaded. See details."
    - Import errors <TBD>

  - Some modules are poor quality. e.g.
    - filesystem; dev is mandatory, the UUID can't be used to identify the device!
    - community.general.zfs/zpool ~10 open bugs


## (5) Does Ansible work with FreeBSD?

There are problems with some Ansible modules running on FreeBSD. The modules `service` and `sysctl` are typical examples.

**ansible.builtin.service**

  Still open since May, 2025
  [FreeBSD service arguments are passed in the wrong order #85156](https://github.com/ansible/ansible/issues/85156)
  [service: Fix order of arguments in FreeBSD #85190](https://github.com/ansible/ansible/pull/85190)

Quoting last comment on Oct 2, 2025 [conversation](https://github.com/ansible/ansible/pull/85190#issuecomment-3359300597)

> A different solution I would personally accept is a new, FreeBSD-specific module and a note on the generic service module that it does not accept extra arguments to the service script.

**vbotka.freebsd.service**

It is easier to write a FreeBSD module. The poposed collection comprises the FreeBSD specific module [service](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/module/service/)
See the [source code](https://raw.githubusercontent.com/vbotka/ansible-collection-freebsd/refs/heads/master/plugins/modules/service.py)

**ansible.posix.sysctl**

The next typical example is `sysctl`. In Linux, there is no `/boot/loader.conf`

Quoting from the issue [In FreeBSD, the module sysctl always reports changed ...](https://github.com/ansible-collections/ansible.posix/issues/663)

> The default option is reload=True. As a result, /etc/sysctl.conf and /etc/sysctl.conf.local are reloaded even when the option is sysctl_file=/boot/loader.conf

In other words, if you use `ansible.posix.sysctl` to configure `/boot/loader.conf` the module
reloads the `sysctl` service. This doesn't make sense, because in FreeBSD, you have to reboot the
system if you want to activate the changes in `/boot/loader.conf`.

The simple remedy is to set the module parameter `reload=False` because you have to reboot the
system on your own anyway (let an Ansible handler run the module ansible.builtin.reboot)

Still, it would be good to know, because you don't expect it. But, the PR below hasn't been accepted yet
[In FreeBSD, fail if loader.conf shall be reloaded.](https://github.com/ansible-collections/ansible.posix/pull/664)

Conclusion:

* When using Ansible "multi-OS" modules in FreeBSD, testing is needed. It can happen that such
  modules do not implement all FreeBSD options properly.

* Consider to create BSD native modules.


## (6) Ansible collections

* Complexity: To make qualified decision in Ansible, multiple areas of expertise are needed:
  - Multiple OS. Most modules are created for Linux.
  - OS administration experience.
  - Multiple programming languages.
  Logical consequences are collections focused on particular technologies.

There are more than 100 collections included in the Ansible distribution, sometimes referenced as 'battery included'. See [Collection Index][(https://docs.ansible.com/projects/ansible/latest/collections/index.html)

Ansible introduced the collections in the version 2.8 released in the year 2019. This feature provided a new distribution format for Ansible content, including playbooks, roles, and plugins.

It's necessary to mention that Ansible is highly configurable. Everything is a plugin. See [Working with plugins](https://docs.ansible.com/projects/ansible/latest/plugins/plugins.html). Later we will describe our iocage plugins:

* iocage inventory plugin,
* iocage module, and
* iocage filter

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

To realize the extent of the code, take a look at the current number of the modules included in the collections distributed with Ansible 2.20.3

```console
shell> ansible-doc -t module -l | wc -l
9604
```
It is clear that the fragmentation was necessary to keep the project maintainable.


## (7) Ansible collections ansible.*

Take a look at who the author of the collections is. This can tell you what the collection support level might be.

## (8) Ansible collections community.*

Take a look at what FreeBSD version(s) are being tested. Quoting
[CfgMgmtCamp 2026 discussion (8/12): Instant Ansible-test target updates without announcements](https://forum.ansible.com/t/cfgmgmtcamp-2026-discussion-8-12-instant-ansible-test-target-updates-without-announcements/45295)

> The VM images are sometimes also changed for stable branches, in the same manner: no announcement, no overlap between availability of the old and new image. As an example, when I woke up on January 8th, I noticed the following replacements since the previous evening: ... freebsd/13.5 VM → freebsd/15.0


## (9) Ansible collection dedicated to FreeBSD is needed

FreeBSD collection is missing. In a certain sense, this is a good news. Ansible is mature, we can
avoid trials and errors when building Ansible FreeBSD collection.

The question is not `if` FreeBSD collection? But `how`?
  - this is a proposal
  - as flexible as possible
  - tools, not policy

Proposed collection
  - FreeBSD or BSD?
  - namespace (bsd ?)
  - setup; start with a minimal tested content; customize your collection on-demand
  - setup description (distfiles, files, vars, playbooks setup.yml and .configure.yml)
    The framework is well-known from the ports collection.

A module vs. command/shell ansible module
  - For example, iocage: complex utility; module is idempotent but slow; use 'creates' to make the command idempotent (faster)

General dilemmas:

  - Use a module or a command (ansible.builtin.command or ansible.builtin.shell) e.g. iocage ?

  - To configure a file, instead of the modules to run a command you can use modules 'lineinfile' or 'blockinfiles'. e.g. sysrc

  This is a trade-off: A specific module provides more comfort, but it's slower. Instead, 'command/shell' and 'lineinfile/blockinfile' are faster
   but the user is responsible to check the consistency.

   As of the consistency of Ansible modules, it is not all that cool. e.g. module 'ansible.builtin.group' makes 'gid' double entries in '/etc/group'

   You can:
    - test it and file a bug
    - Use the modules 'command/shell' to run the 'pw' command
    - Write module 'pw'

  Ansible prefers writting new modules. e.g. new module: logrotate#11424
  https://github.com/ansible-collections/community.general/pull/11424

  Make modules 'command' and 'shell' idempotent

  Both modules 'command' and 'shell' can be idempotent via:

  - The 'creates' option.
     Quote: 'creates'  A filename, when it already exists, this step will not be run.

  - The registering and testing the command output.
    See: Defining “changed”
    https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_error_handling.html#defining-changed


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Section 2


## (10) FreeBSD collection

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Section 3


## (23) Examples


## (24) Example groups

[examples](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_examples.html)


## (25) How to use the examples


## (26) Notes

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Section 4

## (27) Install, configure, and activate iocage

(The below link shows the examples' categories)
[Manage iocage](https://ansible-collection-freebsd.readthedocs.io/en/latest/ug_examples.html)

Let's start with the first 3 examples to `Manage iocage host`.


## (28) example 001: Install Iocage

In the slide, click at the `source code` and `results` links.

The `source code` link shows the directory of this example at GitHub and the `results` link shows the example in the documentation at `ReadTheDocs.io`. 

Let's review the role `vbotka.freebsd.iocage`. Open the link `role vbotka.freebsd.iocage`. This is the Ansible Galaxy page of the collection showing the README file of the role `freebsd_iocage`.

Here it is necessary to explain the roles' naming conventions.

All roles included in this collection have got repositories in `GitHub` and are published as standalone roles in `Ansible Galaxy`. For example, this role is named `freebsd_iocage` in the Ansible Galaxy name space `vbotka`. In this collection  the role is simply named `iocage`. See the list of the roles at the left side. Clink the link `Ansible role`. This is the standalone role `vbotka.freebsd_iocage` in `Ansible Galaxy`.

`Ansible Galaxy` hosts both standalone roles and collections.

See the [Naming conventions](https://ansible-collection-freebsd.readthedocs.io/en/latest/ag_setup_roles.html#naming-convention)
in the `Administration guide`. If there is time, we'll explain the setup of the collection later.

You can use the standalone roles or the roles included in the collection. The code is the same.

Take a look at the directory [roles](https://github.com/vbotka/ansible-collection-freebsd/tree/master/roles)

You see what versions of the roles are included in the collection. The names of the roles are links to the versions.

Take a look at the tasks of the role
[ansible-freebsd-iocage/tasks/main.yml](https://github.com/vbotka/ansible-freebsd-iocage/blob/master/tasks/main.yml)

For now, we only demonstrate how the role works. In this example we only display variables and install the package iocage.

Take a look at the:

- inventory `iocage.ini`,
- playbook `pb-iocage.yml`, and
- `batch.sh`

The first play selects the tag `freebsd_iocage_debug` and enables `freebsd_iocage_debug` (Describe the debug variables.)

The second play selects the tag `freebsd_iocage_pkg`. The package has already been installed. Therefor we see the message `package(s) already present`.


## (29) example 002: Activate iocage

In the slide, click at the `source code` and `results` links.

Quote [Activate iocage](https://freebsd.github.io/iocage/basic-use.html#activate-iocage):

> Before iocage is functional, it needs to activate. Essentially, iocage needs to link with a usable zpool.

The files' tree shows new directory `host_vars`. In production, it is recommended to use a dedicated ZFS pool for iocage, for example, `iocage` in the host `iocage_04`. For testing, you can use `zroot`.


## (30) example 003: Audit iocage host

In the slide, click at the `source code` and `results` links.


# EOF
