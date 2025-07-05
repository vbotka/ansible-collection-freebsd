# freebsd_packages

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/freebsd_packages)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-freebsd-packages.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-freebsd-packages)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-packages)](https://github.com/vbotka/ansible-freebsd-packages/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.network](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_packages/) FreeBSD. Configure repositories. Install, update, and upgrade packages.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-packages/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

### Collections

- community.general >= 9.3.0


## Variables

See the defaults and examples in vars.


## Workflow

1) Change shell on the remote host to /bin/sh if necessary

```bash
shell> ansible host -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod user -s /bin/sh'
```

2) Install the role and collection

```bash
shell> ansible-galaxy role install vbotka.freebsd_packages
```

Install the collection if necessary

```bash
shell> ansible-galaxy collection install community.general
```

3) Change variables to your needs.

Optionally, get the dictionaries of packages' lists. See:

* contrib/vars
* [vbotka.freebsd_postinstall/defaults/main/pkgdict_*.yml](https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main)

Put them, for example, into the *group_vars/all*

```bash
shell> ls -1 group_vars/all/
pkgdict_amd64.yml
pkgdict_arm64.yml
pkgdict_arm.yml
pkgdict_i386.yml
pkgdict_versions.yml
```

See *tasks/vars.yml*. The fact *ansible_architecture* is used to
automatically select the correct list of dictionaries *pkgdict_*

See *tasks/pkg_install* and *tasks/delete* how the variables are used.

There are three options how to declare which packages to install:

* Install all lists from *pkg_dict*. Set *pkg_dict_all: true*

* Select lists from *pkg_dict*. For example, *pkg_dict_select: [minimal, postinstall]*

* Declare the list of packages. For example, *pkg_list: [bash, git, gtar, pkg, rsync, wget]

To deinstall declare the list of packages. For example, *pkg_list_deinstall: [gtk3, libxkbcommon, wayland]*

See examples *vars/main.yml.sample*

4) Create playbook

```yaml
shell> cat freebsd-packages.yml
- hosts: srv.example.com
  roles:
    - vbotka.freebsd_packages
```

Display the lists of packages to install/deinstall

```bash
shell> ansible-playbook freebsd-packages.yml -e pkg_debug=true -t pkg_vars
```

5) Manage the packages

Check syntax

```bash
shell> ansible-playbook freebsd-packages.yml --syntax-check
```

Display variables

```bash
shell> ansible-playbook freebsd-packages.yml -e pkg_debug=true -t pkg_debug
```

Configure repositories. Set pkg_repos_conf_clean=true to delete repos not listed
in pkg_repos_conf

```bash
shell> ansible-playbook freebsd-packages.yml -t pkg_conf
```

Dry-run the playbook and display changes

```bash
shell> ansible-playbook freebsd-packages.yml --check --diff
```

Dry-run the packages installation

```bash
shell> ansible-playbook freebsd-packages.yml -e pkg_dryrun=true
```

If all seems to be right manage the packages

```bash
shell> ansible-playbook freebsd-packages.yml
```

Hint. There are lot of skipped tasks. To make the output of the playbook easier to read:

* Use callback plugin community.general.yaml

* Disable skipped hosts and display debug


```bash
shell> ANSIBLE_DISPLAY_SKIPPED_HOSTS=false ansible-playbook freebsd-packages.yml -e pkg_debug=true
```


## Upgrade packages

Since community.general 9.3.0 it is possible to upgrade
*(state=latest)* packages in the form “category/port” aka
“pkg-origin”. You have to disable globs *(use_globs=false)* if the
form "pkg-origin" is used. See the parameter
[use_globs](https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-use_globs)

```bash
shell> ansible-playbook freebsd-packages.yml -e pkg_state=latest -e pkg_use_globs=false
```


## Repositories

The parameter [pkgsite](https://docs.ansible.com/ansible/latest/collections/community/general/pkgng_module.html#parameter-pkgsite) of the module *community.general.pkgng* says:

> specify a the name of a repository configured in /usr/local/etc/pkg/repos


### Default repository

The module *community.general.pkgng* will use the default repository *FreeBSD* declared in */etc/pkg/FreeBSD.conf* if no repositories are configured in */usr/local/etc/pkg/repos*

```yaml
shell> cat /etc/pkg/FreeBSD.conf
# $FreeBSD$
#
# To disable this repository, instead of modifying or removing this file,
# create a /usr/local/etc/pkg/repos/FreeBSD.conf file:
#
#   mkdir -p /usr/local/etc/pkg/repos
#   echo "FreeBSD: { enabled: no }" > /usr/local/etc/pkg/repos/FreeBSD.conf
#

FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/quarterly",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
```

Display the configured repository

```yaml
# pkg -vv
  ...
Repositories:
  FreeBSD: {
    url             : "pkg+http://pkg.FreeBSD.org/FreeBSD:13:amd64/quarterly",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    signature_type  : "FINGERPRINTS",
    fingerprints    : "/usr/share/keys/pkg"
  }
```


### Custom repositories

You can disable the default repository and declare other repositories. For example, create the dictionary

```yaml
pkg_repos_conf:
  - name: FreeBSD
    conf:
      - {key: enabled, value: 'no'}
  - name: FreeBSD_quarterly
    conf:
      - {key: url, value: '"pkg+http://pkg.FreeBSD.org/${ABI}/quarterly"'}
      - {key: mirror_type, value: '"srv"'}
      - {key: signature_type, value: '"fingerprints"'}
      - {key: fingerprints, value: '"/usr/share/keys/pkg"'}
      - {key: enabled, value: 'yes'}
  - name: FreeBSD_latest
    conf:
      - {key: url, value: '"pkg+http://pkg.FreeBSD.org/${ABI}/latest"'}
      - {key: mirror_type, value: '"srv"'}
      - {key: signature_type, value: '"fingerprints"'}
      - {key: fingerprints, value: '"/usr/share/keys/pkg"'}
      - {key: enabled, value: 'yes'}
```

and create the configuration files

```bash
shell> ansible-playbook -t pkg_conf freebsd-packages.yml
```

Take a look at the files

```yaml
shell> cat /usr/local/etc/pkg/repos/FreeBSD.conf
# Ansible managed

FreeBSD: {
  enabled: no
}
# EOF
```
```yaml
shell> cat /usr/local/etc/pkg/repos/FreeBSD_quarterly.conf
# Ansible managed

FreeBSD_quarterly: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/quarterly",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
# EOF
```
```yaml
shell> cat /usr/local/etc/pkg/repos/FreeBSD_latest.conf
# Ansible managed

FreeBSD_latest: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
  mirror_type: "srv",
  signature_type: "fingerprints",
  fingerprints: "/usr/share/keys/pkg",
  enabled: yes
}
# EOF
```

and display the configured repositories

```yaml
shell> pkg -vv
  ...
Repositories:
  FreeBSD_latest: {
    url             : "pkg+http://pkg.FreeBSD.org/FreeBSD:13:amd64/latest",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    signature_type  : "FINGERPRINTS",
    fingerprints    : "/usr/share/keys/pkg"
  }
  FreeBSD_quarterly: {
    url             : "pkg+http://pkg.FreeBSD.org/FreeBSD:13:amd64/quarterly",
    enabled         : yes,
    priority        : 0,
    mirror_type     : "SRV",
    signature_type  : "FINGERPRINTS",
    fingerprints    : "/usr/share/keys/pkg"
  }
```


### Examples

Given the list

```yaml
pkg_list: [bash]
```

* Install *bash* from the default repository

```yaml
shell> ansible-playbook -t pkg_packages_install_list -e pkg_debug=true freebsd-packages.yml
  ...
ok: [srv.exmple.org] =>
  result:
    attempts: 1
    changed: false
    failed: false
    msg: package(s) already present
    stderr: ''
    stderr_lines: []
    stdout: |-
      Updating FreeBSD_latest repository catalogue...
      FreeBSD_latest repository is up to date.
      Updating FreeBSD_quarterly repository catalogue...
      FreeBSD_quarterly repository is up to date.
      All repositories are up to date.
  ...
```

* Install *bash* from the repository *FreeBSD_latest*

```yaml
shell> ansible-playbook -t pkg_packages_install_list -e pkg_debug=true -e pkg_pkgsite=FreeBSD_latest freebsd-packages.yml
  ...
ok: [srv.example.org] =>
  result:
    attempts: 1
    changed: false
    failed: false
    msg: package(s) already present
    stderr: ''
    stderr_lines: []
    stdout: |-
      Updating FreeBSD_latest repository catalogue...
      FreeBSD_latest repository is up to date.
      All repositories are up to date.
  ...
```

* Install latest package *bash* from the repository *FreeBSD_latest*

```yaml
shell> ansible-playbook -t pkg_packages_install_list -e pkg_debug=true -e pkg_pkgsite=FreeBSD_latest -e pkg_state=latest freebsd-packages.yml
  ...
ok: [srv.example.org] =>
  result:
    attempts: 1
    changed: false
    failed: false
    msg: package(s) already latest
    stderr: ''
    stderr_lines: []
    stdout: |-
      Updating FreeBSD_latest repository catalogue...
      FreeBSD_latest repository is up to date.
      All repositories are up to date.
  ...
```

* Install latest packages in the *minimal* list from the repository *FreeBSD_latest*

Get the dictionaries *pkgdict_\** from Github [ansible-freebsd-postinstall/defaults/main](https://github.com/vbotka/ansible-freebsd-postinstall/tree/master/defaults/main) and declare the list

```yaml
pkg_dict_select: [minimal]
```
Install the packages

```yaml
shell> ansible-playbook -t pkg_packages_install_selected -e pkg_debug=true -e pkg_pkgsite=FreeBSD_latest -e pkg_state=latest  freebsd-packages.yml
  ...
ok: [srv.example.org] =>
 result:
    changed: true
    msg: All items completed
    results:
    - ansible_loop_var: item
      attempts: 1
      changed: true
      failed: false
      invocation:
        module_args:
          annotation: null
          autoremove: false
          cached: false
          chroot: null
          ignore_osver: false
          jail: null
          name:
          - shells/bash
          - devel/git
          - archivers/gtar
          - ports-mgmt/pkg
          - ports-mgmt/portmaster
          - ports-mgmt/portupgrade
          - net/rsync
          - ftp/wget
          pkgsite: FreeBSD_latest
          rootdir: null
          state: latest
      item:
        packages:
        - shells/bash
        - devel/git
        - archivers/gtar
        - ports-mgmt/pkg
        - ports-mgmt/portmaster
        - ports-mgmt/portupgrade
        - net/rsync
        - ftp/wget
        pkglist: minimal
      msg: upgraded 4 packages
      stderr: ''
      stderr_lines: []
      stdout: |-
        Updating FreeBSD_latest repository catalogue...
        FreeBSD_latest repository is up to date.
        All repositories are up to date.
        The following 4 package(s) will be affected (of 0 checked):

        Installed packages to be UPGRADED:
                git-tiny: 2.41.0 -> 2.42.0 [FreeBSD_latest]
                gtar: 1.34_1 -> 1.35 [FreeBSD_latest]
                portmaster: 3.26 -> 3.27 [FreeBSD_latest]
                portupgrade: 2.4.16,2 -> 2.4.16_1,2 [FreeBSD_latest]

        Number of packages to be upgraded: 4

        5 MiB to be downloaded.
        [1/4] Fetching git-tiny-2.42.0.pkg: .......... done
        [2/4] Fetching portupgrade-2.4.16_1,2.pkg: ......... done
        [3/4] Fetching gtar-1.35.pkg: ........ done
        [4/4] Fetching portmaster-3.27.pkg: .... done
        Checking integrity... done (0 conflicting)
        [1/4] Upgrading git-tiny from 2.41.0 to 2.42.0...
        ===> Creating groups.
        Using existing group 'git_daemon'.
        ===> Creating users
        Using existing user 'git_daemon'.
        [1/4] Extracting git-tiny-2.42.0: .......... done
        [2/4] Upgrading portupgrade from 2.4.16,2 to 2.4.16_1,2...
        [2/4] Extracting portupgrade-2.4.16_1,2: .......... done
        [3/4] Upgrading gtar from 1.34_1 to 1.35...
        [3/4] Extracting gtar-1.35: .......... done
        [4/4] Upgrading portmaster from 3.26 to 3.27...
        [4/4] Extracting portmaster-3.27: ........ done
  ...
```

* Install the *minimal* list of packages at the hosts in the group *test*

```yaml
- hosts: test
  gather_facts: true
  become: true

  vars:

    pkg_dict_select:
      - minimal

  roles:
    - vbotka.freebsd_packages
```


## Ansible lint

Use the configuration file *.ansible-lint.local* when running *ansible-lint*. Some rules might be disabled and some warnings might be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [FreeBSD handbook: Using pkg for Binary Package Management](https://www.freebsd.org/doc/handbook/pkgng-intro.html)
- [FreeBSD handbook: Building Packages with poudriere](https://www.freebsd.org/doc/handbook/ports-poudriere.html)
- [man pkg.conf](https://www.freebsd.org/cgi/man.cgi?query=pkg.conf&sektion=5)
- [pkg - a binary package manager for FreeBSD](https://github.com/freebsd/pkg#working-with-multiple-repositories)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
