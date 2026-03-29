# apache

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/apache)
[![Build Status](https://travis-ci.org/vbotka/ansible-apache.svg?branch=master)](https://travis-ci.org/vbotka/ansible-apache)
[![Documentation Status](https://readthedocs.org/projects/ansible-apache/badge/?version=latest)](https://ansible-apache.readthedocs.io/en/latest/?badge=latest)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-apache)](https://github.com/vbotka/ansible-apache/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.apache](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/apache)

[Ansible role.](https://galaxy.ansible.com/vbotka/apache/) Install and configure Apache.

[Documentation at readthedocs.io](https://ansible-apache.readthedocs.io)

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-apache/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Supported platforms

This role has been developed and tested with
* [FreeBSD Supported Production Releases](https://www.freebsd.org/releases/)


## Requirements

### Collections

- community.general

### Roles

- [config_encoder_filters](https://galaxy.ansible.com/jtyr/config_encoder_filters)
- [ansible_lib](https://galaxy.ansible.com/vbotka/ansible_lib)


## Variables

Review defaults and examples in vars. By default SSL is off.

```yaml
apache_ssl: False
```

Certificates are needed to enable SSL.

```yaml
apache_ssl: True
apache_version: "24"
apache_SSLCertificateFile: "/usr/local/etc/apache{{ apache_version }}/server.crt"
apache_SSLCertificateKeyFile: "/usr/local/etc/apache{{ apache_version }}/server.key"
```

Virtual hosts are configured with optional redirection to SSL. By
default virtual hosts for ports 80 and 443 will be created and port 80
permanently redirected to 443. Example is available in vars.


## Workflow

1) Change shell to /bin/sh if necessary

```sh
shell> ansible webserver -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod freebsd -s /bin/sh'
```

2) Install role

```sh
shell> ansible-galaxy role install vbotka.apache
```

3) Fit variables

4) Create playbook and inventory

```yaml
shell> cat apache.yml
---
- hosts: webserver
  roles:
    - vbotka.apache
```

```ini
shell> cat hosts
[webserver]
<webserver-ip-or-fqdn>
[webserver:vars]
ansible_connection=ssh
ansible_user=freebsd
ansible_become=true
ansible_become_method=sudo
ansible_python_interpreter=/usr/local/bin/python3.9
ansible_perl_interpreter=/usr/local/bin/perl
```

5) Test syntax

```sh
shell> ansible-playbook apache.yml --syntax-check
```

6) Show variables

```sh
shell> ansible-playbook apache.yml -t apache_debug -e apache_debug=true
```

7) Install packages

```sh
shell> ansible-playbook apache.yml -t apache_pkg -e apache_install=true
```

8) Dry run and show differences

```sh
shell> ansible-playbook apache.yml --check --diff
```

9) Install and configure apache

```sh
shell> ansible-playbook apache.yml
```


10) Optionally test the webserver

   - http://validator.w3.org
   - https://www.ssllabs.com


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```sh
shell> ansible-lint -c .ansible-lint.local
```


## References

- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
- [SSL/TLS Strong Encryption: Trunk: How-To](https://httpd.apache.org/docs/trunk/ssl/ssl_howto.html)
- [SSL/TLS Strong Encryption: 2.4: How-To](https://httpd.apache.org/docs/2.4/ssl/ssl_howto.html)
- [SSL with Virtual Hosts Using SNI](https://wiki.apache.org/httpd/NameBasedSSLVHostsWithSNI)
- [Multi-Processing Modules (MPMs)](https://httpd.apache.org/docs/2.4/mpm.html)
- [FreeBSD handbook: 29.8. Apache HTTP Server](https://www.freebsd.org/doc/handbook/network-apache.html)
- [Recommended Steps To Harden Apache HTTP on FreeBSD 12.0](https://www.digitalocean.com/community/tutorials/recommended-steps-to-harden-apache-http-on-freebsd-12-0)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
