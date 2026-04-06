#!/bin/sh

set -eu

# Use environment variables set in Dockerfile
CONFIG_DIR=$VPN_CONFIG_DIR
INSTALL_DIR=$VPN_INSTALL_DIR

# Space-separated config file names
CONFIG_FILES="vpn_bridge.config vpn_client.config vpn_server.config"

for cfg in $CONFIG_FILES; do
	if [ -f "$CONFIG_DIR/$cfg" ]; then
		cp "$CONFIG_DIR/$cfg" "$INSTALL_DIR/"
	fi
done

# Start SoftEther VPN Server in background
$INSTALL_DIR/vpnserver execsvc &
VPN_PID=$!

# Check if VPN_INTERFACES is set and not empty
if [ "${VPN_INTERFACES:-}" ]; then
	# Parse comma-separated list into positional parameters
	set -- $(echo "$VPN_INTERFACES" | tr ',' ' ')
	while [ $# -ge 2 ]; do
		iface="$1"
		addr="$2"
		shift 2
		# Wait for the interface to appear
		while ! ip link show "$iface" >/dev/null 2>&1; do
			echo "Waiting for interface $iface..."
			sleep 1
		done
		echo "Adding address $addr to interface $iface"
		ip addr add "$addr" dev "$iface"
	done
fi

# Cleanup function for trap
cleanup() {
	for cfg in $CONFIG_FILES; do
		if [ -f "$INSTALL_DIR/$cfg" ]; then
			cp "$INSTALL_DIR/$cfg" "$CONFIG_DIR/"
		fi
	done
	kill $VPN_PID
	wait $VPN_PID
	exit
}

trap cleanup SIGTERM SIGINT

# Bring vpnserver process to foreground
wait $VPN_PID
