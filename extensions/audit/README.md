# Indirect Node Counts in Ansible Collections

This query is tested in docs/source/sandbox/handy/901

TODO: At the playbook level a callback should be created to create “enhanced
resource reporting”. Quoting 1):

```
Specifically, AWX’s indirect_instance_count.py scrapes these files from
installed collections and uses the jq expressions to count indirectly
managed nodes — resources that modules automate but that aren’t represented
in your inventory.
```

See the source:
https://github.com/ansible/awx/blob/devel/awx/playbooks/library/indirect_instance_count.py

SEE ALSO:
1) The Future of Ansible Resource Management ...
   https://forum.ansible.com/t/the-future-of-ansible-resource-management-help-shape-our-new-standardized-taxonomy/45595
2) Indirect Node Counts in Ansible Collections
   https://github.com/ansible-collections/amazon.aws/tree/main/extensions/audit#readme
3) Implementing Indirect Node Counting and Resource Taxonomy
   https://connect.redhat.com/sites/default/files/2026-03/Indirect-Node-Counting-Taxonomy-Guide-v2.pdf
