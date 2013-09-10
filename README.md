Installation
============

Run `sudo -E profile=work|home|laptop ./dotfiles install` to install all
configuration file for specified profile.

Agreements
==========

Directory structure is the same that under home dir (~/). Exception is rootfs/
directory, that contains global system configuration files that are located
in /.

All missing directories will be created.
All missing files would by symlinked.

If filename ends on `.template`, than same file without `.template` will be
created and all `{{PLACEHOLDER}}` strings in that file will be replaced with
user prompted values.

If filename ends on `.$placeholder`, then `placeholder=value` should be specified
as environment variable on invokation of `./dotfiles.sh` (see usage for more info),
and file, that ends on specified `.value` will be symlinked. Example: if
there are files:

* xorg.conf.$profile,
* xorg.conf.laptop,
* xorg.conf.work,
* xorg.conf.home,

then `$profile` variable will be requested and filename, that evaluated from
`xorg.conf.$profile` will be symlinked into `xorg.conf`.
