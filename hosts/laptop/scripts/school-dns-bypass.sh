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

# Debug to stderr (captured by nm-dispatcher in journal)
echo "school-dns-bypass: iface=$IFACE action=$ACTION" >&2

# Detect the current SSID from the WiFi interface
# Use nmcli device show when the interface comes up (ACTION=up)
CURRENT_SSID=""
if [ "$ACTION" = "up" ]; then
    CURRENT_SSID=$(nmcli -t -f 802-11-wireless.ssid device show "$IFACE" 2>/dev/null | sed 's/^SSID: //i')
fi

# If not on the school SSID, do nothing
[ "$CURRENT_SSID" != "$SCHOOL_SSID" ] && exit 0

echo "school-dns-bypass: on SSID=$CURRENT_SSID, applying DNS bypass" >&2

apply_school_dns() {
    echo "school-dns-bypass: forcing public DNS + disabling Tailscale DNS" >&2
    # Stop Tailscale from overriding DNS
    tailscale set --accept-dns=false 2>/dev/null || true
    # Tell NM to use public DNS for the LT_OPEN connection
    nmcli connection modify "LT_OPEN" \
        ipv4.dns "1.1.1.1 8.8.8.8" \
        ipv4.ignore-auto-dns yes \
        ipv6.dns "2606:4700:4700::1111 2001:4860::8888" \
        ipv6.ignore-auto-dns yes \
        2>/dev/null || true
    # Reapply so the DNS change takes effect immediately
    nmcli connection up "LT_OPEN" 2>/dev/null || true
}

restore_dns() {
    echo "school-dns-bypass: leaving school SSID, restoring Tailscale DNS" >&2
    # Re-enable Tailscale DNS management
    tailscale set --accept-dns=true 2>/dev/null || true
    # Restore automatic DNS on LT_OPEN connection
    nmcli connection modify "LT_OPEN" \
        ipv4.dns "" \
        ipv4.ignore-auto-dns no \
        ipv6.dns "" \
        ipv6.ignore-auto-dns no \
        2>/dev/null || true
}

case "$ACTION" in
    up)
        if [ "$CURRENT_SSID" = "$SCHOOL_SSID" ]; then
            apply_school_dns
        fi
        ;;
    down|vpn-down)
        # When disconnecting, check if we were on the school SSID
        # CURRENT_SSID won't be set since ACTION!=up, but we saved the state
        # via the connection modify; just restore automatically
        restore_dns
        ;;
esac

exit 0