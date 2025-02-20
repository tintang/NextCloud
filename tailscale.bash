#!/bin/sh

# Stop any existing Tailscale services
tailscale down
tailscale funnel reset

# Start Tailscale in userspace networking mode
tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
sleep 5

# Configure Tailscale with the desired hostname
tailscale set --hostname=nextcloud
tailscale up
sleep 5

# Enable Tailscale Funnel
tailscale funnel --bg http://127.0.0.1:11000
sleep 10
# Health check watchdog script
HEALTHCHECK_URL="http://nextcloud.tail3092be.ts.net/login"

while true; do
    # Check if Nextcloud is reachable
    wget --spider -q "$HEALTHCHECK_URL"

    # If wget fails (exit code not 0), the health check failed
    if [ $? -ne 0 ]; then
        echo "[$(date)] Nextcloud is unreachable! Stopping container..."
        exit 1  # Force the container to stop
    fi

    # Sleep before next check
    sleep 10
done
