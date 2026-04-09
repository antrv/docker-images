#!/bin/bash

cd /opt/iventoy

# Start iventoy in background
./iventoy.sh -R start

# Give it a moment to start
sleep 5

# Find the PID of the iventoy process (assuming it's named 'iventoy')
IVENTOY_PID=$(pgrep -f "iventoy" | head -1)

if [ -z "$IVENTOY_PID" ]; then
  echo "Failed to find iventoy process"
  exit 1
fi

echo "Monitoring iventoy process with PID $IVENTOY_PID"

# Function to stop iventoy
stop_iventoy() {
  echo "Stopping iventoy..."
  ./iventoy.sh -R stop
  exit 0
}

# Trap signals to stop iventoy gracefully
trap stop_iventoy SIGTERM SIGINT

# Monitor the process
while kill -0 $IVENTOY_PID 2>/dev/null; do
  sleep 5
done

echo "iventoy process exited, stopping container"
exit 1
