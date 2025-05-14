.. code-block:: bash
   :emphasize-lines: 1

   shell> ansible-playbook playbook.yml --list-tags
   
   playbook: playbook.yml

   play #1 (images.example.com): images.example.com TAGS: []
      TASK TAGS: [cimage_customize, cimage_debug, cimage_download,
      cimage_loaderconf, cimage_mdconfig, cimage_mount, cimage_mount_points,
      cimage_packages, cimage_rcconf, cimage_sanity, cimage_umount,
      cimage_unpack, cimage_wpasupconf]
