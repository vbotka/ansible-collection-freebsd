# freebsd_nginx

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-freebsd-nginx)](https://github.com/vbotka/ansible-freebsd-nginx/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.nginx](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/nginx)

[Ansible role.](https://galaxy.ansible.com/vbotka/freebsd_nginx/) FreeBSD. Install, configure, and run Nginx.


## Requirements

### Collections

- community.general
- vbotka.freebsd


## Variables

Review defaults and examples in vars.


## Workflow

1) Change shell to /bin/sh

```bash
shell> ansible webserver -e 'ansible_shell_type=csh ansible_shell_executable=/bin/csh' -a 'sudo pw usermod freebsd -s /bin/sh'
```

2) Install the role and collections

```bash
shell> ansible-galaxy role install vbotka.freebsd_nginx
shell> ansible-galaxy collection install community.general
shell> ansible-galaxy collection install vbotka.freebsd
```

3) Change variables

- Review *defaults*
- Customize variables

4) Create the playbook *nginx.yml*

```yaml
- hosts: webserver
  roles:
    - vbotka.freebsd_nginx
```

and the inventory file *hosts*

```ini
[webserver]
<webserver-ip-or-fqdn>
[webserver:vars]
ansible_connection=ssh
ansible_user=freebsd
ansible_become=yes
ansible_become_method=sudo
ansible_python_interpreter=auto_silent
```

5) Install and configure Nginx

```bash
shell> ansible-playbook nginx.yml
```

6) Test the webserver

   - http://validator.w3.org
   - https://www.ssllabs.com
		

## References

- [nginx.org Documentation](http://nginx.org/en/docs/)
- [nginx.com Wiki](https://www.nginx.com/resources/wiki/)
- [nginx.com Linode Tutorial](https://www.linode.com/docs/web-servers/nginx/)
- [nginx.com Documentation](https://docs.nginx.com/)
- [nginx.com Documentation - Full Example Configuration](https://www.nginx.com/resources/wiki/start/topics/examples/full/)
- [digitalocean.com How to Install Nginx on FreeBSD 11.2](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-freebsd-11-2)
- [digitalocean.com How To Secure Nginx with Let's Encrypt on FreeBSD](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-letsencrypt-freebsd)
- [FreeBSD Nginx performance](https://devinteske.com/wp/freebsd-nginx-performance/)


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
