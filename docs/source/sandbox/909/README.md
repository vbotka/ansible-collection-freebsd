# iocage plugin ansible-pull-test

* Run the batch.

* Open console to the jail. For example,

```
shell > iocage console c6f15d2e-d612-44dd-8c4c-7334541d78d9
```

* Test ansible-pull in the jail created from the iocage plugin ansible-pull-test.

```
root@c6f15d2e-d612-44dd-8c4c-7334541d78d9:~ # ansible-pull -U https://github.com/vbotka/ansible-conf-test.git \
                                                           -d /root/ansible-conf-test \
														   pb-test.yml

[WARNING]: Could not match supplied host pattern, ignoring:
c6f15d2e-d612-44dd-8c4c-7334541d78d9
[WARNING]: Could not match supplied host pattern, ignoring: localhost.my.domain
localhost | CHANGED => {
    "after": "db2af8a89d18bcfcc2d81f5002dc06e42541953b",
    "before": null,
    "changed": true
}
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'
[WARNING]: Could not match supplied host pattern, ignoring:
c6f15d2e-d612-44dd-8c4c-7334541d78d9
[WARNING]: Could not match supplied host pattern, ignoring: localhost.my.domain

PLAY [Test ansible-pull] *******************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [Hello world!] ************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

```
Look at the file

```
root@c6f15d2e-d612-44dd-8c4c-7334541d78d9:~ # cat /tmp/ansible-hello-world.txt 
Hello world!
```
