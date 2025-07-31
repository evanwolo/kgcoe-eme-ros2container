#!/bin/bash
# Host orchestration script: manages docker compose and containers
set -e

echo "=================================================="
echo "       Running ROS2 Research Launcher v1.0! "
echo "                  © emweee 2025"
echo "=================================================="

# Clean up any old containers
docker compose down --remove-orphans > /dev/null 2>&1 || true
docker rm -f ros-jazzy-container xserver-vnc ros 2>/dev/null || true

# Start all services (xserver, ros, etc.)
echo "Starting all required containers..."
docker compose up -d
sleep 2

echo "=================================================="
echo "All containers started successfully!"
echo "=================================================="



# Ensure ros-jazzy-container is running and build workspace if src exists
if docker ps --format '{{.Names}}' | grep -q '^ros-jazzy-container$'; then
  echo "To view GUI apps, connect your VNC client to localhost:5901 (password: password)"
echo "Or open http://localhost:6901 in your browser for noVNC web access."
echo "When you are finished, simply exit the shell."
  # Check if /root/ros_ws/src exists in the container
  if docker exec ros-jazzy-container test -d /root/ros_ws/src; then
    echo "Building ROS2 workspace in /root/ros_ws..."
    docker exec ros-jazzy-container bash -c 'cd /root/ros_ws && colcon build || true'
  else
    echo "No /root/ros_ws/src directory found in container. Skipping build."
  fi
  echo "Attaching to ROS2 development container..."

  docker exec -it ros-jazzy-container bash
else
  # Print error in red
  echo -e "\033[0;31mFailed to start ROS2 container. Please check docker compose logs.\033[0m"
  exit 1
fi

docker compose down
docker rm -f ros-jazzy-container xserver-vnc ros 2>/dev/null || true
echo "=================================================="
echo "All containers stopped and removed."
echo "=================================================="
echo "Thank you for using the ROS2 Research Launcher!"
