# config_light

[![quality](https://img.shields.io/ansible/quality/27910)](https://galaxy.ansible.com/vbotka/config_light)
[![Build Status](https://travis-ci.org/vbotka/ansible-config-light.svg?branch=master)](https://travis-ci.org/vbotka/ansible-config-light)
[![Documentation Status](https://readthedocs.org/projects/docs/badge/?version=latest)](https://ansible-config-light.readthedocs.io/en/latest/)
[![GitHub tag](https://img.shields.io/github/v/tag/vbotka/ansible-config-light)](https://github.com/vbotka/ansible-config-light/tags)

This role is included in the collection [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/) as [vbotka.freebsd.config_light](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/content/role/config_light)

[Ansible role.](https://galaxy.ansible.com/vbotka/config_light/) Install packages, configure files, services, and handlers.

[Documentation at readthedocs.io](https://ansible-config-light.readthedocs.io).

Feel free to [share your feedback and report issues](https://github.com/vbotka/ansible-config-light/issues).

[Contributions are welcome](https://github.com/firstcontributions/first-contributions).


## Supported platforms

This role has been developed and tested with

* [Ubuntu Supported Releases](http://releases.ubuntu.com/)
* [FreeBSD Supported Production Releases](https://www.freebsd.org/releases/)


## Requirements and dependencies

### Collections

* [ansible.posix](https://galaxy.ansible.com/ui/repo/published/ansible/posix/)
* [community.general](https://galaxy.ansible.com/ui/repo/published/community/general/)
* [vbotka.freebsd](https://galaxy.ansible.com/ui/repo/published/vbotka/freebsd/)

### Optional packages

* yamllint

The utility *yamllint* is used by default to validate assembled
data. See the variables *cl_assemble_validate* and
*cl_handlers_validate* in *defaults/main.yml*


## Ansible lint

Use the configuration file *.ansible-lint.local* when running
*ansible-lint*. Some rules might be disabled and some warnings might
be ignored. See the notes in the configuration file.

```bash
shell> ansible-lint -c .ansible-lint.local
```


## License

[![license](https://img.shields.io/badge/license-BSD-red.svg)](https://www.freebsd.org/doc/en/articles/bsdl-gpl/article.html)


## Author Information

[Vladimir Botka](https://botka.info)
