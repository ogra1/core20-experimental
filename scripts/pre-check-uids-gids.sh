#!/bin/sh

# We *must* ensure that uid/gid never changes in the core image because
# the UIDs will (potentially) leak out into the filesystem and /etc/passwd
# and friends are part of the readonly part of the core snap so they can
# be replaced.
#
# If the order ever changes we need to manually resolve this here and construct
# the files here manually.

# First we check if passwd and group have expected contents after bootstrapping

echo "Ensure passwd file is in a sane state and did not change"
diff -u $SNAPCRAFT_PART_INSTALL/etc/passwd - <<EOF
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
EOF
rc=$?; [ "$rc" != "0" ] && MISMATCH=1

echo "Ensure group file is in a sane state and did not change"
diff -u $SNAPCRAFT_PART_INSTALL/etc/group - <<EOF
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:
floppy:x:25:
tape:x:26:
sudo:x:27:
audio:x:29:
dip:x:30:
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
EOF
rc=$?; [ "$rc" != "0" ] && MISMATCH=1

if [ -n "$MISMATCH" ]; then
    echo "There were changes to the password database."
    echo "Please check the differences printed above and adjust the values here and in the final versions."
    exit 1
fi

# We're now providing our own version of /etc/passwd and others since we want
# to remain compatible with UIDs and GIDs from core 16.

echo "Providing the final passwd file"
cat > $SNAPCRAFT_PART_INSTALL/etc/passwd <<EOF
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
messagebus:x:100:103::/var/run/dbus:/bin/false
snappypkg:x:101:104:Reserved:/nonexistent:/bin/false
sshd:x:102:65534::/var/run/sshd:/usr/sbin/nologin
systemd-timesync:x:103:108:Reverved:/run/systemd:/bin/false
systemd-network:x:104:109:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:105:110:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:106:111:Reserved:/run/systemd:/bin/false
_apt:x:117:65534:Reserved:/nonexistent:/bin/false
syslog:x:108:114:Reserved:/home/syslog:/bin/false
dnsmasq:x:109:65534:Reserved:/var/lib/misc:/bin/false
tss:x:110:116:Reserved:/var/lib/tpm:/bin/false
EOF
cp $SNAPCRAFT_PART_INSTALL/etc/passwd $SNAPCRAFT_PART_INSTALL/etc/passwd.orig # We make a copy for a later sanity-compare

echo "Providing the final shadow file"
cat > $SNAPCRAFT_PART_INSTALL/etc/shadow <<EOF
root:*:16329:0:99999:7:::
daemon:*:16329:0:99999:7:::
bin:*:16329:0:99999:7:::
sys:*:16329:0:99999:7:::
sync:*:16329:0:99999:7:::
games:*:16329:0:99999:7:::
man:*:16329:0:99999:7:::
lp:*:16329:0:99999:7:::
mail:*:16329:0:99999:7:::
news:*:16329:0:99999:7:::
uucp:*:16329:0:99999:7:::
proxy:*:16329:0:99999:7:::
www-data:*:16329:0:99999:7:::
backup:*:16329:0:99999:7:::
list:*:16329:0:99999:7:::
irc:*:16329:0:99999:7:::
gnats:*:16329:0:99999:7:::
nobody:*:16329:0:99999:7:::
messagebus:*:16413:0:99999:7:::
snappypkg:*:16413:0:99999:7:::
sshd:*:16413:0:99999:7:::
systemd-timesync:*:16413:0:99999:7:::
systemd-network:*:16413:0:99999:7:::
systemd-resolve:*:16413:0:99999:7:::
systemd-bus-proxy:*:16413:0:99999:7:::
_apt:*:16780:0:99999:7:::
syslog:*:16521:0:99999:7:::
dnsmasq:*:16644:0:99999:7:::
tss:*:16701:0:99999:7:::
EOF
cp $SNAPCRAFT_PART_INSTALL/etc/shadow $SNAPCRAFT_PART_INSTALL/etc/shadow.orig # We make a copy for a later sanity-compare

echo "Providing the final group file"
cat > $SNAPCRAFT_PART_INSTALL/etc/group <<EOF
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:
floppy:x:25:
tape:x:26:
sudo:x:27:
audio:x:1005:
dip:x:30:
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
netdev:x:101:
crontab:x:102:
messagebus:x:103:
snappypkg:x:104:
ssh:x:105:
systemd-journal:x:106:
systemd-timesync:x:108:
systemd-network:x:109:
systemd-resolve:x:110:
systemd-bus-proxy:x:111:
kvm:x:112:
syslog:x:114:
pkcs11:x:115:
tss:x:116:
input:x:107:
render:x:117:
EOF
cp $SNAPCRAFT_PART_INSTALL/etc/group $SNAPCRAFT_PART_INSTALL/etc/group.orig # We make a copy for a later sanity-compare

echo "Providing the final gshadow file"
cat > $SNAPCRAFT_PART_INSTALL/etc/gshadow <<EOF
root:*::
daemon:*::
bin:*::
sys:*::
adm:*::
tty:*::
disk:*::
lp:*::
mail:*::
news:*::
uucp:*::
man:*::
proxy:*::
kmem:*::
dialout:*::
fax:*::
voice:*::
cdrom:*::
floppy:*::
tape:*::
sudo:*::
audio:*::
dip:*::
www-data:*::
backup:*::
operator:*::
list:*::
irc:*::
src:*::
gnats:*::
shadow:*::
utmp:*::
video:*::
sasl:*::
plugdev:*::
staff:*::
games:*::
users:*::
nogroup:*::
netdev:!::
crontab:!::
messagebus:!::
snappypkg:!::
ssh:!::
systemd-journal:!::
systemd-timesync:!::
systemd-network:!::
systemd-resolve:!::
systemd-bus-proxy:!::
kvm:!::
syslog:!::
pkcs11:!::
tss:!::
input:!::
render:!::
EOF
cp $SNAPCRAFT_PART_INSTALL/etc/gshadow $SNAPCRAFT_PART_INSTALL/etc/gshadow.orig # We make a copy for a later sanity-compare
