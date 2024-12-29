.. _example_031:

(WIP) 031 Display iocage lists and dictionaries.
------------------------------------------------

.. contents:: Table of Contents
   :depth: 2

Tree
^^^^

::

   shell> tree .
   .
   ├── ansible.cfg
   ├── iocage-hosts.ini
   └── pb-iocage-display-lists.yml

Synopsis
^^^^^^^^

* On two iocage hosts:

  * iocage_01
  * iocage_02

  In the playbook *pb-iocage-display-lists.yml*, use the module
  *vbotka.freebsd.iocage* to:

  * create and display *iocage* lists and dictionaries.

Notes
^^^^^

Quoting from `man iocage <https://man.freebsd.org/cgi/man.cgi?query=iocage&sektion=8>`_:  ::

         list	 List  the  specified dataset type.  By	default, all jails are
		 listed.

		 Options:

		 [--http]	       Changes [-R | --remote] to use HTTP.

		 [-H | -h | --header]  Used in scripting.  Use tabs for	 sepa-
				       rators.

		 [-P | --plugins]      Shows plugins installed on the system.

		 [-PRO]		       Lists  official	plugins	 available for
				       download.

		 [-R | --remote]       Shows available RELEASE options for re-
				       mote.

		 [-b | -r | --base | --release | dataset_type]
				       List all	bases.

		 [-l | --long]	       Shows JID, NAME,	BOOT, STATE, TYPE, RE-
				       LEASE, IP4, IP6,	and TEMPLATE  informa-
				       tion.

		 [-q | --quick]	       Lists  all  jails  with less processing
				       and fields.

		 [-s | --sort TEXT]    Sorts the list by the given type.

		 [-t | --template | dataset_type]
				       Lists all templates.

    
Configuration *ansible.cfg*
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ansible.cfg
    :language: ini

Inventory *iocage-hosts.ini*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini
	       
Playbook *pb-iocage-display-lists.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-display-lists.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash
