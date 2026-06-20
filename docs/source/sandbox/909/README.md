# iocage plugin ansible-pull-test

## Troubleshooting

* Run the batch.

* Open console to the jail. For example,

```
shell > iocage console caaf20a2-9744-4792-ac58-dd259f2cb617
```

* Test ansible-pull in the jail created from the iocage plugin ansible-pull-test.

```
root@caaf20a2-9744-4792-ac58-dd259f2cb617:~/ansible-conf-test # cd ansible-conf-test/

root@caaf20a2-9744-4792-ac58-dd259f2cb617:~/ansible-conf-test # ansible-pull -i hosts -U https://github.com/vbotka/ansible-conf-test.git -d /root/ansible-conf-test pb-test.yml
Starting Ansible Pull at 2026-06-20 11:35:33
/usr/local/bin/ansible-pull -i hosts -U https://github.com/vbotka/ansible-conf-test.git -d /root/ansible-conf-test pb-test.yml
[WARNING]: Could not match supplied host pattern, ignoring:
caaf20a2-9744-4792-ac58-dd259f2cb617
localhost.my.domain | SUCCESS => {
    "after": "48d2c9ea01ece7a9af3e29b5bf18f7df53fd203c",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/local/bin/python3.11"
    },
    "before": "48d2c9ea01ece7a9af3e29b5bf18f7df53fd203c",
    "changed": false,
    "remote_url_changed": false
}
[WARNING]: Could not match supplied host pattern, ignoring:
caaf20a2-9744-4792-ac58-dd259f2cb617

PLAY [ansible-test] ************************************************************

TASK [Hello world!] ************************************************************
ok: [localhost.my.domain]

PLAY RECAP *********************************************************************
localhost.my.domain        : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
Look at the file

```
root@caaf20a2-9744-4792-ac58-dd259f2cb617:~/ansible-conf-test # cat /tmp/ansible-hello-world.txt 
[ansible-test] Hello world!
```
