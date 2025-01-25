.. _example_201:

201 Display iocage lists and dictionaries.
------------------------------------------

Extending example 200.

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

* *root* is not needed to run *'iocage list ...'* on the iocage hosts.

* Quoting from `man iocage <https://man.freebsd.org/cgi/man.cgi?query=iocage&sektion=8>`_:  ::

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

Lists at iocage_01
^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-02.txt
    :language: bash

Lists at iocage_02
^^^^^^^^^^^^^^^^^^

.. literalinclude:: out/out-03.txt
    :language: bash

Inventory iocage-hosts.ini
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: iocage-hosts.ini
    :language: ini

.. note::

   * The escalation *become=true* is not necessary.

   * *root* is not needed to run *'iocage list ...'*

   * *admin* executes the module *vbotka.freebsd.iocage* on the iocage
     hosts and creates the variables *iocage_\**
	       
Playbook *pb-iocage-display-lists.yml*
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: pb-iocage-display-lists.yml
    :language: yaml

Playbook output
^^^^^^^^^^^^^^^

.. literalinclude:: out/out-01.txt
    :language: bash
