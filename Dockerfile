# Evan Wologodzew - emweee
# ROS2 Research Image Dockerfile

FROM osrf/ros:jazzy-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal system tools for ROS2 GUI with SPICE support
RUN apt-get update && apt-get install -y \
    neofetch \
    xfce4 xfce4-goodies \
    spice-vdagent \
    xserver-xspice \
    dbus-x11 \
    wget \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install ROS tooling
RUN apt-get update && apt-get install -y \
    python3-rosdep \
    python3-vcstool \
    python3-colcon-common-extensions \
    ros-jazzy-rviz2 \
    ros-jazzy-rqt ros-jazzy-rqt-common-plugins ros-jazzy-rqt-gui ros-jazzy-rqt-gui-py \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init || true && rosdep update || true

# Set workspace root and auto-source
WORKDIR /root/ros_ws

# Create a new ROS2 workspace
RUN mkdir -p /root/ros_ws/src

# Copy launch script
COPY launch.sh /root/launch.sh
RUN chmod +x /root/launch.sh

# Download wallpaper PNG
RUN mkdir -p /usr/share/backgrounds/custom
RUN wget -O /usr/share/backgrounds/custom/wall.png "http://kgcoe-bootstrap.rit.edu/eme-intune/Wallpapers/wallpaper_07_25.png" || \
    echo "Failed to download wallpaper, using default"

RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc && \
    echo '[ -f /root/ros_ws/install/setup.bash ] && source /root/ros_ws/install/setup.bash' >> /root/.bashrc && \
    echo 'echo "Welcome to the ROS2 Development Container! You are ready to build and run ROS2 workspaces."' >> /root/.bashrc && \
    echo 'neofetch' >> /root/.bashrc

EXPOSE 5900
# Set entrypoint to launch custom script
ENTRYPOINT ["/root/launch.sh"]

CMD ["/root/launch.sh"]

