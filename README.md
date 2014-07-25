Installation
============

Run `./bootstrap <profile>` to install all packages and configuration files
for specified profile. It should bring system to the desired consistent state.

Ultimate feature
================

Unlike many other dotfiles installation scripts, this one provides not only
one-way installation process, but can join changes made back to the repo.

Just invoke `./dotfiles rejoin` and all changes made in local configuration
will be merged back to the repo. It smart enough to join changes even to the
template files!

Bootstraping and configuring
============================

There are two installation scripts called `./bootstrap` and `./dotfiles`.

`./dotfiles` is exist to work with configuration.

`./bootstrap` brings system to consistent state.

All changes that should be done on new branded fresh installed system are
described in `./profiles.txt` so look at them, they are pretty
descriptive by they own.

Assumed workflow is:

* once on fresh installed system: `./bootstrap <profile>`;
* every next time when update is needed: `./boostrap`;
* every next time when full upgrade is needed: `./bootstrap <profile>` (it will also update AUR packages);
* every next time when local configuration changed: `./dotfiles rejoin`;

Agreements
==========

Directory structure is the same that under home dir (~/). Exception is rootfs/
directory, that contains global system configuration files that are located
in /.

All missing directories would be created.
All missing files would by symlinked (files under rootds will be copied).

If filename ends on `.template`, then same file without `.template` would be
created and all `{{PLACEHOLDER}}` strings in that file would be replaced with
user prompted values.

If filename ends on `.$profile`, then file without `.$profile` would be created
with contents taked from file, that name ends in specified profile name.
Example: if there are files:

* xorg.conf.$profile,
* xorg.conf.laptop,
* xorg.conf.work,
* xorg.conf.home,

then  filename, that evaluated from `xorg.conf.$profile` would be linked/copied
into `xorg.conf`.
