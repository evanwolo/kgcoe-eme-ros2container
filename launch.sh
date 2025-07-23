#!/bin/bash
set -e

xhost +local:root

IMG=ros-jazzy-dev
ROS_WS_DIRECTORY=$(realpath ./ros_packages)

# Check for mounted ROS workspace
if [ ! -d "$ROS_WS_DIRECTORY" ]; then
    echo "The ros_packages directory at $ROS_WS_DIRECTORY does not exist"
    exit 1
fi

# NVIDIA GPU passthrough
if test -c /dev/nvidia0; then
    docker run --rm -it \
      --gpus all \
      --runtime=nvidia \
      --privileged \
      --device /dev/dri:/dev/dri \
      --env="DISPLAY=$DISPLAY" \
      --env="QT_X11_NO_MITSHM=1" \
      -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      -v "$ROS_WS_DIRECTORY:/root/ros_ws:rw" \
      --name ros-jazzy-container \
      --network host \
      $IMG \
      bash
else
    docker run --rm -it \
      --privileged \
      -e DISPLAY="$DISPLAY" \
      --device=/dev/dri:/dev/dri \
      -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
      -v "$ROS_WS_DIRECTORY:/root/ros_ws:rw" \
      --name ros-jazzy-container \
      $IMG \
      bash
fi
