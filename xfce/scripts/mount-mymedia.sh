#!/bin/sh
# Mount MyMedia NFS share from FreeBSD Plex server
# Works on Linux (XFCE/FreeBSD desktop) — macOS uses mount_nfs directly

SHARE="192.168.0.14:/zroot/mymedia"
MOUNT="/home/$(whoami)/MyMedia"

# Already mounted?
mount | grep -q "$SHARE" && exit 0

# Create mount point
mkdir -p "$MOUNT"

# Mount via NFS
sudo mount -t nfs -o resvport "$SHARE" "$MOUNT" 2>/dev/null || \
    mount -t nfs "$SHARE" "$MOUNT" 2>/dev/null

echo "Mounted $SHARE at $MOUNT"
