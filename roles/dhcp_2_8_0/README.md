# freebsd_dhcp

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/freebsd_dhcp)
[![Build Status](https://app.travis-ci.com/vbotka/ansible-freebsd-dhcp.svg?branch=master)](https://app.travis-ci.com/vbotka/ansible-freebsd-dhcp)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-dhcp)](https://github.com/vbotka/ansible-freebsd-dhcp/tags)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_dhcp/) Install and configure DHCP in FreeBSD.

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-freebsd-dhcp/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements

### Collections

* community.general


## Role Variables

Review the defaults and examples in vars.


## Workflow

1) Change shell on the remote host to /bin/sh if necessary

```bash
shell> ansible dhcp.example.com -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod freebsd -s /bin/sh'
```

2) Install the role

```bash
shell> ansible-galaxy role install vbotka.freebsd_dhcp
```

3) Fit the variables.

4) Create the playbook

```yaml
shell> cat freebsd-dhcp.yml
- hosts: dhcp.example.com
  roles:
    - role: vbotka.freebsd_dhcp
```

5) Run the playbook

Test the syntax

```bash
shell> ansible-playbook --syntax-check  freebsd-dhcp.yml
```

Take a look at the variables

```bash
shell> ansible-playbook -t bsd_dhcpd_debug -e bsd_dhcpd_debug=true freebsd-dhcp.yml
```

Install packages

```bash
shell> ansible-playbook -t bsd_dhcpd_packages -e bsd_dhcpd_install=true freebsd-dhcp.yml
```

Dry run and see what will be configured

```bash
shell> ansible-playbook --check --diff freebsd-dhcp.yml
```

If this is what you want run the play

```bash
shell> ansible-playbook freebsd-dhcp.yml
```


## Firewall

If you use the PF firewall add the following rules to /etc/pf.conf

```
dhcp_ports="{ bootps, bootpc }"
pass quick on $if proto { tcp, udp } to $if port $dhcp_ports
```


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## References

- [FreeBSD handbook: Dynamic Host Configuration Protocol (DHCP)](https://www.freebsd.org/doc/handbook/network-dhcp.html)
- [Highly Available DHCP Server on FreeBSD](https://medium.com/@vermaden/highly-available-dhcp-server-on-freebsd-2bf81a5e4e77)
- [man dhcpd(8)](https://www.freebsd.org/cgi/man.cgi?query=dhcpd)
- [man dhcpd.conf(5)](https://www.freebsd.org/cgi/man.cgi?query=dhcpd.conf)
- [FreeBSD Forum: pf.conf rules for dhcp](https://forums.freebsd.org/threads/pf-conf-rules-for-dhcp.15213/)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
