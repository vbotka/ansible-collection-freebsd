# freebsd_network

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/freebsd_network)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-freebsd-network.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-freebsd-network)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-network)](https://github.com/vbotka/ansible-freebsd-network/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.network](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/network)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_network/) FreeBSD. Configure network.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-network/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

None.


## Role Variables

Review the defaults and examples in vars.


## Dependencies

### Collections

* [community.general](https://github.com/ansible-collections/community.general/)
* [vbotka.freebsd](https://github.com/vbotka/ansible-collection-freebsd/)


## Workflow

1) Change shell on the remote host to /bin/sh if necessary

```bash
shell> ansible host -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod user -s /bin/sh'
```

2) Install role

```bash
shell> ansible-galaxy role install vbotka.freebsd_network
```

3) Fit variables to your needs.


4) Create playbook

```bash
shell> cat freebsd-network.yml
- hosts: host
  roles:
    - vbotka.freebsd_network
```

5) Configure the system

```bash
shell> ansible-playbook freebsd-network.yml
```

## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [FreeBSD handbook: Network](https://docs.freebsd.org/en/books/handbook/network/)
- [FreeBSD handbook: Virtualization](https://docs.freebsd.org/en/books/handbook/virtualization/)
- [FreeBSD handbook: Advanced Networking](https://docs.freebsd.org/en/books/handbook/advanced-networking/index.html)
- [FreeBSD handbook: Gateways and Routes](https://docs.freebsd.org/en/books/handbook/advanced-networking/#network-routing)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
