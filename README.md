An experimental build of the core20 snap, solely using snapcraft.yaml

to build this snap just clone the tree into a 20.04 lxd container and run

    snapcraft --destructive-mode

TODO: the following hook scripts will need to be ported from the old code still:
  - 029-fix-ld-so-symlink.chroot 
  - 013-add-mdns-hostname-resolution.chroot 
  - 012-add-foreign-libc6.chroot 

TODO: all tests will needd to be ported and adjusted for the new set up
