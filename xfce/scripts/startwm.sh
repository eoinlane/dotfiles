#!/bin/sh
export XDG_SESSION_TYPE=x11
export QT_QPA_PLATFORMTHEME=qt5ct
xrdb -merge ~/.Xresources 2>/dev/null
exec startxfce4
