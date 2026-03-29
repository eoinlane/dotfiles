#!/bin/sh
# Mount MyMedia SMB share from Raspberry Pi via gvfs (gio)
# Runs inside the XFCE desktop session where dbus is available

SHARE="smb://raspberrypi/MyMedia"
LINK="$HOME/MyMedia"
GVFS_PATH="$HOME/.gvfs/MyMedia on raspberrypi"

# Already mounted?
gio mount -l 2>/dev/null | grep -q "raspberrypi" && exit 0

# Mount via gio (will use credentials from gnome-keyring or prompt)
echo -e "eoin\nWORKGROUP\nel" | gio mount "$SHARE" 2>/dev/null

# Create a symlink for easy access
if [ -d "$GVFS_PATH" ] && [ ! -L "$LINK" ]; then
    ln -sf "$GVFS_PATH" "$LINK"
fi

# Also try the /run path (newer gvfs)
GVFS_RUN="/run/user/$(id -u)/gvfs/smb-share:server=raspberrypi,share=mymedia"
if [ -d "$GVFS_RUN" ] && [ ! -L "$LINK" ]; then
    ln -sf "$GVFS_RUN" "$LINK"
fi
