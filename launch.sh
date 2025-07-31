#!/bin/bash
# Container entrypoint: VNC/GUI setup (runs as root inside container)
set -e
if [ -z "$VNC_PASSWORD" ]; then
  export VNC_PASSWORD="ros2"
fi
mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
vncserver :1 -geometry 1280x800 -depth 24
export DISPLAY=:1
startxfce4 &
echo "Container started. VNC server running on :1."
exec bash
