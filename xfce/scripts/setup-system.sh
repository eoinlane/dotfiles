#!/bin/sh
# Run this as: sudo sh ~/.local/bin/setup-system.sh
# Sets up doas, tmpfs, Linuxulator, and WireGuard

set -e

echo "=== Setting up doas ==="
echo "permit persist eoin" > /usr/local/etc/doas.conf
chmod 600 /usr/local/etc/doas.conf
echo "Done. You can now use 'doas' instead of 'sudo'."

echo ""
echo "=== Setting up tmpfs for /tmp ==="
if grep -q "tmpfs.*/tmp" /etc/fstab 2>/dev/null; then
    echo "Already configured."
else
    echo 'tmpfs	/tmp	tmpfs	rw,mode=1777	0	0' >> /etc/fstab
    echo "Added to /etc/fstab. Will take effect on next reboot (or run: mount -t tmpfs tmpfs /tmp)"
fi

echo ""
echo "=== Enabling Linuxulator ==="
kldload linux64 2>/dev/null || true
sysrc linux_enable=YES
sysrc kld_list+="linux64"
# Install Linux base system
pkg install -y linux_base-rl9 2>/dev/null || echo "linux_base-rl9 may need manual install"
echo "Done."

echo ""
echo "=== WireGuard ==="
kldload if_wg 2>/dev/null || true
sysrc kld_list+="if_wg"
echo "WireGuard kernel module enabled. Configure tunnels in /usr/local/etc/wireguard/"

echo ""
echo "=== FUSE + smbnetfs for SMB shares ==="
kldload fusefs 2>/dev/null || true
sysrc kld_list+="fusefs"
# Enable user mounts
sysctl vfs.usermount=1
if grep -q "vfs.usermount" /etc/sysctl.conf 2>/dev/null; then
    echo "vfs.usermount already in sysctl.conf"
else
    echo "vfs.usermount=1" >> /etc/sysctl.conf
    echo "Added vfs.usermount=1 to /etc/sysctl.conf"
fi
echo "Done. smbnetfs can now be used as regular user."

echo ""
echo "=== ZFS auto-snapshots ==="
pkg install -y zfs-auto-snapshot 2>/dev/null || echo "zfs-auto-snapshot may need manual install"
# Enable hourly, daily, weekly snapshots
sysrc -f /etc/cron.d/zfs-auto-snapshot cron_enable=YES 2>/dev/null || true
echo "Configure snapshot retention in /usr/local/etc/zfs-auto-snapshot"

echo ""
echo "All done! Reboot recommended for tmpfs and Linuxulator."
