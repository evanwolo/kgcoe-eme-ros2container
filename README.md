
# KGCOE EME ROS2 Research Container

This project provides a ready-to-use Docker environment for ROS2 research at KGCOE (RIT). It is designed for users with **ROS2 experience but no prior Docker or Linux experience** and enables you to run ROS2 and GUI applications on any device, including Windows, macOS, and Linux.

---

## Table of Contents

1. [What is this?](#what-is-this)
2. [Prerequisites](#prerequisites)
3. [Installation & Setup](#installation--setup)
4. [Running the Container](#running-the-container)
5. [Accessing the Desktop (VNC)](#accessing-the-desktop-vnc)
6. [Persisting Your Work](#persisting-your-work)
7. [Stopping and Cleaning Up](#stopping-and-cleaning-up)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Usage](#advanced-usage)
10. [Packages Installed](#packages-installed)
11. [Ports Used](#ports-used)

---

## What is this?

This repository provides a **Docker-based ROS2 development environment** with a full Linux desktop (XFCE) accessible via VNC. It is ideal for research, prototyping, and coursework. You should be familiar with ROS2 concepts and workflows, but no Linux or Docker expertise is required.

---

## Prerequisites

1. **Install Docker Desktop**
   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop/) for your operating system (Windows, macOS, or Linux).
   - Follow the installation instructions for your platform.
   - After installation, **start Docker Desktop** and ensure it is running (look for the whale icon in your system tray).

2. **(Windows only) Enable WSL2**
   - Docker Desktop will prompt you to enable WSL2 if it is not already enabled. Follow the prompts or see [Microsoft's WSL2 guide](https://docs.microsoft.com/en-us/windows/wsl/install) for help.

---

## Installation & Setup

1. **Clone this repository**
   - Open a terminal (Command Prompt, PowerShell, or Terminal app).
   - Run:
     ```sh
     git clone https://github.com/evanwolo/kgcoe-eme-ros2container.git
     cd kgcoe-eme-ros2container/eme-ros-container
     ```

2. **Build the Docker image**
   - In the `eme-ros-container` directory, run:
     ```sh
     docker build -t eme-ros2-container .
     ```
   - This may take several minutes the first time.

---

## Running the Container

You can use the provided **host launcher script** (recommended for beginners) or run Docker commands manually.

### Option 1: Using the Host Launcher Script (Recommended)

1. **Run the script:**
   - On Windows: Open PowerShell, navigate to the `eme-ros-container` folder, and run:
     ```sh
     ./host_launcher.sh
     ```
     - If you get a permissions error, run: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
   - On macOS/Linux: Open Terminal, navigate to the folder, and run:
     ```sh
     bash host_launcher.sh
     ```
2. The script will:
   - Start all required containers
   - Build your ROS2 workspace (if any packages are present)
   - Print instructions for connecting via VNC
   - Attach you to a shell inside the container

### Option 2: Manual Docker Commands

1. **Start the containers:**
   ```sh
   docker compose up -d
   ```
2. **Access the container shell:**
   ```sh
   docker exec -it ros-jazzy-container bash
   ```

---

## Accessing the Desktop (VNC)

Once the container is running, you can access the Linux desktop environment in two ways:

1. **VNC Client (Recommended):**
   - Download a VNC client (e.g., [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)).
   - Connect to `localhost:5901`.
   - **Password:** `password` (default)

2. **Web Browser (noVNC):**
   - Open your browser and go to: [http://localhost:6901](http://localhost:6901)
   - **Password:** `password`

You will see a full Linux desktop where you can run ROS2 tools and GUIs.

---

## Persisting Your Work

By default, any files you create inside the container will be lost when the container is deleted. To save your work:

**Mount a local folder as your ROS2 workspace:**

```sh
docker run -it -p 5901:5901 -v /your/local/dir:/root/ros_ws eme-ros2-container
```

Replace `/your/local/dir` with the path to a folder on your computer. All files in `/root/ros_ws` inside the container will be saved to your local folder.

---

## Stopping and Cleaning Up

To stop all containers and clean up resources:

```sh
docker compose down
```

If you used the launcher script, it will automatically stop and remove containers when you exit.

---

## Troubleshooting

- **Docker not found:** Make sure Docker Desktop is installed and running.
- **VNC connection refused:** Wait a few seconds after starting the container, then try again.
- **Permission errors on Windows:** Try running PowerShell as Administrator, or use `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`.
- **Workspace not building:** Ensure you have a `src` folder inside `/root/ros_ws` (or your mounted directory) with ROS2 packages.

For more help, see the [Docker documentation](https://docs.docker.com/get-started/) or contact your research group lead.

---

## Advanced Usage

- **Customizing the image:** Edit the `Dockerfile` to add or remove packages.
- **Modifying services:** Edit `docker-compose.yml` to change ports or add services.
- **Running GUI apps:** Any Linux GUI app installed in the container can be run from the desktop.

---

## Packages Installed

| Category      | Package Names |
|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| System Tools | `git`, `curl`, `wget`, `nano`, `net-tools`, `iputils-ping`, `iproute2`, `lsb-release`, `bash-completion`, `sudo`, `fastfetch` |
| Desktop      | `xfce4`, `xfce4-goodies`, `tigervnc-standalone-server`, `dbus-x11`                                                                                         |
| ROS 2 Tools  | `python3-rosdep`, `python3-vcstool`, `python3-colcon-common-extensions`, `ros-jazzy-rviz2`, `ros-jazzy-rqt`, `ros-jazzy-rqt-common-plugins`, `ros-jazzy-rqt-gui`, `ros-jazzy-rqt-gui-py` |

---


## Ports Used

| Port   | Description           |
|--------|-----------------------|
| 5901   | Desktop VNC Client    |
| 6901   | Web VNC (noVNC)       |

---

## Connecting to Blue Robotics Tether (USB)

To use a Blue Robotics tether (or any USB device) with the ROS2 container, you need to pass the USB device from your host computer into the Docker container. This allows ROS2 nodes inside the container to communicate with hardware such as the Blue Robotics Pixhawk or other serial devices.

### Steps (Linux/macOS/WSL2)

1. **Identify the USB device**
   - Plug in the Blue Robotics tether interface (e.g., Fathom-X or Pixhawk).
   - Run `ls /dev/tty*` before and after plugging in the device to find the new device (commonly `/dev/ttyUSB0` or `/dev/ttyACM0`).

2. **Run the container with device passthrough**
   - Add the `--device` flag to your `docker run` command:
     ```sh
     docker run -it --device=/dev/ttyUSB0 -p 5901:5901 -v /your/local/dir:/root/ros_ws eme-ros2-container
     ```
   - Replace `/dev/ttyUSB0` with the correct device name if different.

3. **Check permissions**
   - If you get a permissions error, add your user to the `dialout` group or run Docker as root (not recommended for production).

### Steps (Windows)

1. **Install the USB driver**
   - Make sure the Blue Robotics device driver is installed on Windows.

2. **Expose the USB device to WSL2 (if using Docker Desktop with WSL2 backend)**
   - Open Windows Terminal as Administrator and run:
     ```sh
     wsl --shutdown
     ```
   - Start Docker Desktop, then plug in the USB device.
   - Use the Docker Desktop settings to enable "Expose hardware devices to the container" (if available).
   - Alternatively, use a tool like [usbipd-win](https://github.com/dorssel/usbipd-win) to attach the USB device to your WSL2 instance. See the [usbipd-win guide](https://github.com/dorssel/usbipd-win/wiki/WSL-support) for details.

3. **Run the container with device passthrough**
   - Once the device is visible in WSL2 (e.g., `/dev/ttyUSB0`), use the same `--device` flag as above.

### Inside the Container

- The device (e.g., `/dev/ttyUSB0`) will be available inside the container. You can use it with ROS2 nodes (e.g., `micro-ros-agent`, MAVROS, etc.) as you would on a native Linux system.

---


## Glossary

**Container:** A lightweight, isolated environment that packages software and its dependencies so it runs the same everywhere. In this project, the container runs Ubuntu Linux and ROS2 tools. Containers are ephemeral by default, meaning changes inside are lost unless persisted.

**Docker:** A platform for building, running, and managing containers. Docker provides the `docker` CLI and Docker Engine, which runs containers as isolated processes on your host OS.

**Docker Image:** A read-only template (built from a `Dockerfile`) that defines the filesystem, installed packages, and configuration for a container. Images are versioned and can be shared via registries like Docker Hub.

**Docker Compose:** A tool for defining and running multi-container Docker applications using a YAML file (`docker-compose.yml`). It allows you to start, stop, and manage related services (e.g., ROS2, VNC desktop) as a group.

**VNC (Virtual Network Computing):** A remote desktop protocol that lets you view and control the Linux desktop running inside the container from your own computer, using a VNC client or web browser (noVNC).

**noVNC:** An open-source VNC client that runs in your web browser, allowing you to access the container's desktop without installing extra software.

**Volume Mount:** A way to link a folder on your computer to a folder inside the container, so your work is saved outside the container. Specified with the `-v` flag in Docker commands.

**Workspace:** The ROS2 workspace directory (`/root/ros_ws` in the container) where you build and store your ROS2 packages and code. This is typically a `colcon` workspace.

**colcon:** The build tool used for ROS2 workspaces. Run `colcon build` inside your workspace to build all packages.

**rosdep:** A command-line tool for installing system dependencies required by ROS2 packages. Run `rosdep install` to resolve dependencies before building.

**Entrypoint:** The default command or script that runs when a container starts. In this project, the entrypoint is typically a shell or a script that launches the desktop environment and VNC server.

**Environment Variable:** A variable set in the container's environment, often used to configure ROS2, the desktop, or other tools (e.g., `ROS_DOMAIN_ID`, `DISPLAY`).

**Port Mapping:** The process of exposing a port from the container to your host machine (e.g., `-p 5901:5901`), allowing you to connect to services like VNC.

**YAML:** A human-readable data serialization format used for configuration files like `docker-compose.yml` and ROS2 launch files.

**Root User:** The default user in this container is `root`, which has full administrative privileges. This simplifies development but should be used with care in production.

**Networking:** By default, containers use a bridge network. You can communicate with the container via mapped ports or Docker's internal networking features.

---

---

---

## Frequently Asked Questions (FAQ)

**Q: I have never used Docker before. Is it safe to install?**

A: Yes, Docker Desktop is widely used in research and industry. It is safe to install and does not affect your existing files or programs. You can uninstall it at any time.


**Q: Do I need to know Linux or Docker to use this container?**

A: No. The provided scripts and instructions are designed for users with ROS2 experience but no Linux or Docker experience. You will interact with a graphical Linux desktop, similar to Windows or macOS, and use familiar ROS2 tools.

**Q: How do I save my work?**

A: By default, files inside the container are temporary. To save your work, use the volume mounting instructions in the "Persisting Your Work" section. This links a folder on your computer to the container.

**Q: The VNC password is not working. What should I do?**

A: The default password is `password`. If you changed it or forgot it, rebuild the container or contact your group lead.

**Q: I get a permissions error running the script on Windows.**

A: Open PowerShell as Administrator and run:
```sh
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
Then try running the script again.

**Q: How do I install more ROS2 packages or system tools?**

A: Edit the `Dockerfile` to add packages, then rebuild the image with `docker build -t eme-ros2-container .`.

**Q: How do I stop everything and clean up?**

A: Use `docker compose down` or simply exit the shell if you used the launcher script. This will stop and remove all containers.

**Q: Who do I contact for help?**

A: Contact your research group lead or the repository maintainer listed in the project.
