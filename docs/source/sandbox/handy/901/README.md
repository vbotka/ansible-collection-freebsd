# Indirect Node Counts in Ansible Collections

This example prepares the JSON query for the "Indirect Node Counting". This
query will be used in the file extensions/audit/event_query.yml

See:
- The Future of Ansible Resource Management ...
  https://forum.ansible.com/t/the-future-of-ansible-resource-management-help-shape-our-new-standardized-taxonomy/45595
- Indirect Node Counts in Ansible Collections
  https://github.com/ansible-collections/amazon.aws/tree/main/extensions/audit#readme
- Implementing Indirect Node Counting and Resource Taxonomy
  https://connect.redhat.com/sites/default/files/2026-03/Indirect-Node-Counting-Taxonomy-Guide-v2.pdf

## Example

List of jails at `iocage_05`

```console
shell> ssh admin@iocage_05 iocage list -l
+------+----------+------+-------+------+--------------+--------------------+-----+----------------+----------+
| JID  |   NAME   | BOOT | STATE | TYPE |   RELEASE    |        IP4         | IP6 |    TEMPLATE    | BASEJAIL |
+======+==========+======+=======+======+==============+====================+=====+================+==========+
| None | cb040eb9 | off  | down  | jail | 15.0-RELEASE | DHCP (not running) | -   | ansible_client | no       |
+------+----------+------+-------+------+--------------+--------------------+-----+----------------+----------+
| None | dd911c4f | off  | down  | jail | 15.0-RELEASE | DHCP (not running) | -   | ansible_client | no       |
+------+----------+------+-------+------+--------------+--------------------+-----+----------------+----------+
| None | f20ab29e | off  | down  | jail | 15.0-RELEASE | DHCP (not running) | -   | ansible_client | no       |
+------+----------+------+-------+------+--------------+--------------------+-----+----------------+----------+
```

The playbook `pb-test-query.yml` get the iocage data sets

```yaml
    - name: Create Ansible facts iocage_*
      register: module_output
      vbotka.freebsd.iocage:
```

and store the module output in the file

```yaml
    - name: Copy module_output to file module_output.json
      delegate_to: localhost
      copy:
        dest: "{{ playbook_dir }}/module_output_{{ inventory_hostname }}.json"
        content: |
          {{ module_output | to_json }}
```

Test the query stored in the file event_query.json

```console
shell> cat module_output_iocage_05.json | jq -f event_query.json
```


```yaml
{
  "name": "cb040eb9",
  "canonical_facts": {
    "hostid": "4c4c4544-0057-3810-8046-b2c04f4a5232"
  },
  "facts": {
    "device_type": "jail",
    "basejail": "no",
    "template": "ansible_client",
    "boot": "off",
    "notes": "vmm=iocage_05 swarm=sw_01"
  }
}
{
  "name": "dd911c4f",
  "canonical_facts": {
    "hostid": "4c4c4544-0057-3810-8046-b2c04f4a5232"
  },
  "facts": {
    "device_type": "jail",
    "basejail": "no",
    "template": "ansible_client",
    "boot": "off",
    "notes": "vmm=iocage_05 swarm=sw_01"
  }
}
{
  "name": "f20ab29e",
  "canonical_facts": {
    "hostid": "4c4c4544-0057-3810-8046-b2c04f4a5232"
  },
  "facts": {
    "device_type": "jail",
    "basejail": "no",
    "template": "ansible_client",
    "boot": "off",
    "notes": "vmm=iocage_05 swarm=sw_01"
  }
}
```
