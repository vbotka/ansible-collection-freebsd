# List of jails incl. properties

## In a play, get the inventory by running ansible-inventory

```yaml
    - name: Query iocage2 inventory plugin
      delegate_to: localhost
      ansible.builtin.command:
        cmd: "ansible-inventory -i hosts --list --export"
      register:
        iocage_jails: (_task.result.stdout
                       | from_yaml
                       | vbotka.freebsd.clean_unsafe)._meta.hostvars
      changed_when: false
```

Note: The configuration file or dir *host* must be in the same
directory as the playbook.
