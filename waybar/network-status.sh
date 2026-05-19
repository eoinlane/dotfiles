#!/bin/sh
# waybar custom-module: report rge0 IP + status (waybar's built-in network
# module isn't compiled into the FreeBSD port — no netlink shim).
iface=rge0
out=$(ifconfig "$iface" 2>/dev/null) || {
    printf '{"text":"\uf127 no %s","class":"disconnected","tooltip":"%s missing"}\n' "$iface" "$iface"
    exit 0
}
status=$(printf '%s' "$out" | awk '/status:/ {print $2}')
ip=$(printf '%s' "$out" | awk '/inet / {print $2; exit}')
if [ "$status" = "active" ] && [ -n "$ip" ]; then
    printf '{"text":"\uf6ff %s","class":"connected","tooltip":"%s: %s"}\n' "$ip" "$iface" "$ip"
else
    printf '{"text":"\uf127 offline","class":"disconnected","tooltip":"%s: status %s"}\n' "$iface" "${status:-unknown}"
fi
