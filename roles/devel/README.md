# devel

Ansible role. Manage collection vbotka.freebsd
Collection: vbotka.freebsd

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-collection-freebsd/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Requirements and dependencies

### Collections

- [community.general](https://galaxy.ansible.com/community/general)

### Packages

- [iocage](https://www.freshports.org/sysutils/iocage/)
- [uclcmd](https://www.freshports.org/devel/uclcmd/)


## Role Variables

- See default variables in *defaults/main.yml*
- See examples in *vars/main.yml*


## Workflow

- Install the collection and dependencies

- Create playbook

```
shell> cat playbook.yml
- hosts: srv.example.com
  collections:
    - vbotka.freebsd
  roles:
    - devel
```

- Display help

```
shell> ansible-playbook playbook.yml
```


- Manage modules

```
shell> ansible-playbook playbook.yml -t devel_module
```


## References


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author

[Vladimir Botka](https://botka.link)
