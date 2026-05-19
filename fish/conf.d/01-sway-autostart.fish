# Auto-launch sway when logging in at the first console TTY (ttyv0)
# Skip if already in a graphical session or non-interactive shell.
# `dbus-run-session` bootstraps a session bus and exports DBUS_SESSION_BUS_ADDRESS,
# so mako / xdg-desktop-portal / etc. can talk to D-Bus.
if status is-login
    if not set -q WAYLAND_DISPLAY; and not set -q DISPLAY
        if test (tty) = /dev/ttyv0
            exec dbus-run-session sway
        end
    end
end
