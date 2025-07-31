# Copilot Instructions for kgcoe-eme-ros2container

## Project Overview
This repository provides a Docker-based development environment for ROS 2 (Jazzy) research, with optional GPU passthrough and workspace mounting. The main entry point is the `launch.sh` script, which manages container startup and environment setup.

## Key Components
- **Dockerfile**: Defines the ROS 2 development image (`ros-jazzy-dev`).
- **launch.sh**: Bash script to launch the Docker container, handle workspace mounting, and (optionally) GPU passthrough.
- **ros_packages/**: (Expected) Local ROS workspace directory, mounted into the container at `/root/ros_ws`.

## Developer Workflows
- **Launching the Container**: Run `launch.sh` from a Bash-compatible shell. On Windows, use Git Bash or WSL. The script checks for the `ros_packages` directory and mounts it.
- **X11 GUI Apps on Windows**: Use VcXsrv as the X server. Set `DISPLAY=host.docker.internal:0.0` in your environment before running the script. Remove `/tmp/.X11-unix` mounts from the Docker run command for Windows.
- **GPU Passthrough**: The script contains a block (commented out by default) for NVIDIA GPU passthrough using `--gpus all` and `--runtime=nvidia`.

## Project Conventions
- All container configuration is managed via `launch.sh`—do not run `docker run` manually unless debugging.
- The ROS workspace is always expected at `./ros_packages` relative to the repo root.
- The container is named `ros-jazzy-container` for easy management.
- The script uses `set -e` for fail-fast behavior.

## Integration Points
- **X11 Forwarding**: Integrates with host X server (VcXsrv on Windows, native X11 on Linux).
- **GPU**: Optional NVIDIA GPU support if `/dev/nvidia0` is present.
- **Host Networking**: Uses `--network host` for GPU block (Linux only).

## Example: Launching on Windows
1. Start VcXsrv with access control disabled.
2. In PowerShell: `$env:DISPLAY="host.docker.internal:0.0"`
3. Run `bash launch.sh` from the project directory.

## Key Files
- `Dockerfile`: Container build definition
- `launch.sh`: Container launch logic

## Tips
- If you see `xhost: command not found`, comment out or remove the `xhost` line in `launch.sh` (not needed on Windows).
- For headless GUI testing, consider adding Xvfb to the Dockerfile.

---
For questions or unclear workflows, see the top of `launch.sh` for author contact or open an issue.
