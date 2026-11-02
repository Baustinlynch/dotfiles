#!/bin/sh
# NetworkManager dispatcher script: bypass school/Tailscale DNS on LT_OPEN WiFi.
#
# When connecting to the school network (SSID: LT_OPEN), force public DNS
# (Cloudflare + Google) and disable Tailscale DNS management, so Tailscale's
# magic DNS (100.100.100.100) doesn't hijack resolution and break when the
# captive portal blocks Tailscale DERP.
# When leaving the school network, restore Tailscale DNS management.

IFACE="$1"
ACTION="$2"

# Only act on the WiFi interface
[ "$IFACE" != "wlp2s0" ] && exit 0

SCHOOL_SSID="LT_OPEN"

# Get the active connection name on this interface
ACTIVE_CONN=$(nmcli -t -f NAME,DEVICE connection show --active 2>/dev/null \
    | grep ":${IFACE}$" | head -1 | cut -d: -f1)

# Debug output to stderr (captured by nm-dispatcher in journal)
echo "school-dns-bypass: iface=$IFACE action=$ACTION active=$ACTIVE_CONN" >&2

apply_school_dns() {
    echo "school-dns-bypass: on $SCHOOL_SSID, forcing public DNS + disabling Tailscale DNS" >&2
    # Stop Tailscale from overriding DNS
    tailscale set --accept-dns=false 2>/dev/null || true
    # Tell NM to use public DNS for this connection
    nmcli connection modify "$SCHOOL_SSID" \
        ipv4.dns "1.1.1.1 8.8.8.8" \
        ipv4.ignore-auto-dns yes \
        ipv6.dns "2606:4700:4700::1111 2001:4860::8888" \
        ipv6.ignore-auto-dns yes \
        2>/dev/null || true
    # Reapply so the DNS change takes effect immediately
    nmcli connection up "$SCHOOL_SSID" 2>/dev/null || true
}

restore_dns() {
    echo "school-dns-bypass: leaving $SCHOOL_SSID, restoring Tailscale DNS" >&2
    # Re-enable Tailscale DNS management
    tailscale set --accept-dns=true 2>/dev/null || true
    # Restore automatic DNS on the connection
    nmcli connection modify "$SCHOOL_SSID" \
        ipv4.dns "" \
        ipv4.ignore-auto-dns no \
        ipv6.dns "" \
        ipv6.ignore-auto-dns no \
        2>/dev/null || true
}

case "$ACTION" in
    up)
        if [ "$ACTIVE_CONN" = "$SCHOOL_SSID" ]; then
            apply_school_dns
        fi
        ;;
    down|vpn-down)
        if [ "$ACTIVE_CONN" = "$SCHOOL_SSID" ]; then
            restore_dns
        fi
        ;;
esac

exit 0
