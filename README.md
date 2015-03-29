<h2>About overlay</h2>

Yarik-overlay contains patches and ebuilds for some packages from official tree that still havn't commited and some new packages (OpenERP 6, TypeTrainer, nouveau-firmware). Most of patches added in [Gentoo Bug tracking system](http://bugs.gentoo.org/).

**TrueCrypt** was restored in the official tree, but overlay still contains truecrypt-7.1a ebuild with fixed source url and removed fetch restriction.

<h2>How to add overlay</h2>
Yarik-overlay available in layman central overlays list.

```
# emerge -av layman
# layman -a yarik-overlay
