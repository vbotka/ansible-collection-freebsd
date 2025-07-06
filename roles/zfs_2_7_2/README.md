# freebsd_zfs

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/freebsd_zfs)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-freebsd-zfs.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-freebsd-zfs)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-zfs)](https://github.com/vbotka/ansible-freebsd-zfs/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.zfs](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/zfs)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_zfs/) FreeBSD. Configure ZFS.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-zfs/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

### Roles

* [vbotka.freebsd_postinstall](https://galaxy.ansible.com/vbotka/freebsd_postinstall)

This role is needed to run tasks from *sysctl.yml* and *loader.yml*

### Collections

* community.general


## Variables

See defaults and examples in vars.


## Workflow

1) Change the shell on the remote host to /bin/sh if necessary

```bash
shell> ansible host -e ansible_shell_type=csh -e ansible_shell_executable=/bin/csh -a 'sudo pw usermod user -s /bin/sh'
```

2) Install the roles and collections

```bash
shell> ansible-galaxy role install vbotka.freebsd_zfs
shell> ansible-galaxy role install vbotka.freebsd_postinstall
```

If necessary install the collection

```bash
shell> ansible-galaxy collection install community.general
```

3) Fit variables to your needs.

4) Create the playbook

```yaml
shell> cat freebsd-zfs.yml
- hosts: host
  roles:
    - vbotka.freebsd_zfs
```

5) Configure the system

```bash
shell> ansible-playbook freebsd-zfs.yml
```


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [FreeBSD handbook: The Z File System (ZFS)](https://docs.freebsd.org/en/books/handbook/zfs/)
- [FreeBSD wiki: ZFS](https://wiki.freebsd.org/ZFS)
- [FreeBSD wiki: ZFS Quick Start Guide](https://wiki.freebsd.org/ZFSQuickStartGuide)
- [FreeBSD wiki: ZFS Tuning Guide](https://wiki.freebsd.org/ZFSTuningGuide)
- [FreeBSD wiki: Category ZFS](https://wiki.freebsd.org/CategoryZfs)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
