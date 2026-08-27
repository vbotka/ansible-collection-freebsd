# Template ansible-init-devel

Extends example 918.

Test the port sysutils/ansible-init-firstboot
Install package ansible-init-firstboot-1.0.pkg

## Test the new port

1) Prepare Your Local Ports Tree. Make sure you have a local clone of the
   FreeBSD ports Git repository. If you haven't already cloned it:
   
   git clone https://git.FreeBSD.org/ports.git ~/freebsd-ports
   cd ~/freebsd-ports

2) Download the Patch. Go to the Bugzilla PR:
   https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=296507. Locate the patch
   attachment and download the raw patch file (e.g., save it as
   ansible-init-firstboot.patch in your home directory or working directory).

3) Apply the Patch with Git from the root of your ports tree ~/freebsd-ports

   git am /path/to/ansible-init-firstboot.patch
   Applying: sysutils/ansible-init-firstboot: New port: Firstboot ansible-pull initialization rc script

4) Create the package

   cd freebsd-portswork/pkg/ansible-init-firstboot-1.0.pkg/sysutils/ansible-init-firstboot/
   make package
   
   Use the package work/pkg/ansible-init-firstboot-1.0.pkg
