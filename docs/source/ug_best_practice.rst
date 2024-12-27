.. _ug_best_practice:

Best Practice
*************

Topics:

* The *iocage* binary is very complex.

* The *iocage* module can't cover all use-cases. The maintenance of such complexity wouldn't be efficient.

* For use cases not covered by the module, use the *runner* tasks from the role *iocage*.

Installation:

* Install the package or port *sysutils/iocage*; (role:pkg)

* Activate the *iocage* binary; (role:activate)

* Configure *iocage*; (role:conf)

* Audit the installation; (role:sanity)

* Configure rc.conf and start/restart/stop/enable/disable *iocage*; (role:rcconf)

Workflow:

* Fetch release(s) and create basejail(s); (role:runner or module)

* Create template(s); (role:data, role:runner, role:clean or module)

* Clone and start jails; (role:runner or module)

* Create dynamic inventory; (role:stat and *ansible.builtin.add_host* or inventory plugin)

* Manage the jails by Ansible; (playbooks)
