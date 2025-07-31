# Evan Wologodzew - emweee
# ROS2 Research Image Dockerfile

FROM osrf/ros:jazzy-desktop-full

ENV DEBIAN_FRONTEND=noninteractive

# Install system tools
RUN apt-get update && apt-get install -y \
    git \ 
    curl \ 
    wget \ 
    nano \ 
    net-tools \
    iputils-ping \
    iproute2 \
    lsb-release \
    bash-completion \
    sudo \
    fastfetch

# Install ROS tooling
RUN apt-get update && apt-get install -y \
    python3-rosdep \
    python3-vcstool \
    python3-colcon-common-extensions \
    ros-jazzy-rviz2 \
    ros-jazzy-rqt* \
 && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init || true

# Set workspace root and auto-source
WORKDIR /root/ros_ws
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc && \
    echo "source /root/ros_ws/install/setup.bash" >> /root/.bashrc && \
    echo 'fastfetch' >> /root/.bashrc && \
    echo 'echo "Welcome to KGCOE EME ROS2 Research Container"' >> /root/.bashrc

CMD ["bash"]

