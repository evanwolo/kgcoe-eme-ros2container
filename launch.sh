#!/bin/bash
# Container entrypoint: SPICE/GUI setup (runs as root inside container)
set -e

# Source ROS2 environment
source /opt/ros/jazzy/setup.bash
[ -f /root/ros_ws/install/setup.bash ] && source /root/ros_ws/install/setup.bash

# Set up SPICE password
if [ -z "$SPICE_PASSWORD" ]; then
  export SPICE_PASSWORD="ros2"
fi

# Create SPICE configuration
mkdir -p /root/.spice
cat > /root/.spice/spice.conf << EOF
[spice]
port=5900
password=$SPICE_PASSWORD
disable-ticketing=false
EOF

# Start SPICE X server
export DISPLAY=:1
Xspice --port 5900 --password $SPICE_PASSWORD --disable-ticketing false :1 &

# Wait a moment for X server to start
sleep 3

# Start XFCE4
startxfce4 &

# Wait for XFCE4 to start and set wallpaper in background
(
  sleep 5
  # Try multiple times with different monitor configurations
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVNC-0/workspace0/last-image -s /usr/share/backgrounds/custom/wall.png 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/custom/wall.png 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s /usr/share/backgrounds/custom/wall.png 2>/dev/null || true
  # Force refresh desktop
  xfdesktop --reload 2>/dev/null || true
) &

echo "Container started. VNC server running on :1."
exec bash
