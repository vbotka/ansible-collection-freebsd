# Create limited collection

For example, create limited collection used in the repos

* ansible-conf-syslogng-server
* ansible-conf-syslogng-client

1) Export VBOTKA_FREEBSD_COLLECTION_PATH to the collection

```
shell > export VBOTKA_FREEBSD_COLLECTION_PATH=/scratch/collections/ansible_collections/vbotka/freebsd
```

2) Create the directory where you want to copy the limited collection and create the dir setup/sync

```
shell > mkdir -p ${HOME}/tmp/vbotka.freebsd/setup/sync
```
3) Copy the list of files and sync them

```
shell > cd ${HOME}/tmp/vbotka.freebsd
shell > cp ${VBOTKA_FREEBSD_COLLECTION_PATH}/setup/sync/ansible-conf-syslogng.txt setup/sync
shell > rsync -avL --delete-excluded --include-from='setup/sync/ansible-conf-syslogng.txt' --exclude='*' ${VBOTKA_FREEBSD_COLLECTION_PATH}/ .
```

4) Go to the repo of ansible-conf-syslogng-server, export the path, and install (update) the limited collection

```
shell > cd /scratch/vbotka/vbotka.ansible-conf-syslogng-server
shell > export ANSIBLE_COLLECTIONS_PATH=./collections
shell > ansible-galaxy collection install -U ${HOME}/tmp/vbotka.freebsd
```

5) Add, commit, and push the changes

```
shell > git add .
shell > git commit -a -S -m "Upgrade the limited collection to 8.21"
shell > git push
```
6) Repeat the steps 4 and 5 in the repo ansible-conf-syslogng-client
