.. _ug_qa_inventory_flat:

Is it possible to create groups for duplicate inventory hosts?
--------------------------------------------------------------

.. index::
   single: inventory groups; Q&A

Details
^^^^^^^

Consider the following inventory::

  shell> ansible-inventory -i hosts --graph
  @all:
    |--@ungrouped:
    |--@pull_repos:
    |  |--repos
    |  |--repos_devel
    |--@state_up:
    |  |--repos
    |  |--repos_devel
    |  |--pkg_repo
    |  |--log_server_01
    |--@vmm_iocage_05:
    |  |--repos
    |  |--repos_devel
    |--@vmm_iocage_06:
    |  |--repos
    |  |--repos_devel
    |  |--pkg_repo
    |  |--log_server_01

The jail hosts ``repos`` and ``repos_devel`` run on both ``iocage_05`` and
``iocage_06`` (identified by the host variable ``iocage_tags.vmm``).

Can the ``constructed`` inventory plugin—specifically using ``groups`` and
``keyed_groups``—create separate groups like ``repos_05`` and ``repos_06`` to
isolate each host by its jail manager?

Answer
^^^^^^

**No.** In Ansible, host names within an inventory must be globally unique.

Because ``repos`` and ``repos_devel`` are defined only once by name:

* **Single host identity:** Ansible treats each as one unique target that
  happens to belong to multiple groups (``vmm_iocage_05`` and
  ``vmm_iocage_06``).
* **Variable collision:** Setting host variables like ``iocage_tags.vmm`` on
  the same host name causes one jail manager's value to overwrite the other
  according to inventory precedence rules.

To target these environments separately, assign unique host identifiers in the
base inventory (for example, ``repos_05`` and ``repos_06``) and map connection
parameters or jail names via host variables.