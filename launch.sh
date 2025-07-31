# Evan Wologodzew - emweee
# ROS2 Research Image Docker Compose Launcher

#!/bin/bash
set -e

echo "=================================================="
echo "       Running ROS2 Research Launcher v0.0! "
echo "                  © emweee 2025"
echo "=================================================="

docker rm -f ros-jazzy-container xserver-vnc 2>/dev/null || true

echo "Launching X11+VNC server and ROS multicontainer setup..."
docker compose up -d xserver
sleep 5
echo "To view GUI apps, connect your VNC client to localhost:5901 (password: password)"
echo "Or open http://localhost:6901 in your browser for noVNC web access."
docker compose run --rm --service-ports -it ros


#blocked by container run, will run on exit
echo "Stopping containers..."
docker compose down
