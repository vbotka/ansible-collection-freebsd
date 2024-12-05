.. _example_001:

Clone jails and create inventory
--------------------------------

Inventory *iocage-hosts.ini*
	       
.. literalinclude:: iocage-hosts.ini
    :language: ini

host_vars/iocage_01/iocage.yml
	       
.. literalinclude:: host_vars/iocage_01/iocage.yml
    :language: yaml

host_vars/iocage_02/iocage.yml
	       
.. literalinclude:: host_vars/iocage_02/iocage.yml
    :language: yaml

Playbook *pb-iocage-fetch-base-clone-list.yml*

.. literalinclude:: pb-iocage-fetch-base-clone-list.yml
    :language: yaml

.. literalinclude:: out/out-01.txt
    :language: bash

Inventory *iocage.yml*
	       
.. literalinclude:: iocage.yml
    :language: yaml

Playbook *pb-test-01.yml*

.. literalinclude:: pb-test-01.yml
    :language: yaml
	       
.. literalinclude:: out/out-02.txt
    :language: bash
