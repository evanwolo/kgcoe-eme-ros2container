# SPICE Client Installation Guide

## What is SPICE?

SPICE (Simple Protocol for Independent Computing Environments) is a remote display protocol that provides better performance, audio support, and clipboard sharing compared to VNC.

## Installing SPICE Clients

### Windows

**Option 1: Virt-Manager (Recommended)**
1. Download from: https://github.com/virt-manager/virt-manager/releases
2. Install the Windows version
3. Use the SPICE viewer included with virt-manager

**Option 2: SPICE-GTK Client**
1. Download from: https://www.spice-space.org/download.html
2. Look for "Windows binaries" section
3. Install spice-gtk-tools package

**Option 3: Remote Viewer**
```powershell
# Using Chocolatey (if installed)
choco install virt-viewer
```

### macOS

**Using Homebrew:**
```bash
brew install virt-viewer
```

**Manual Installation:**
1. Download from: https://github.com/jeffreywildman/homebrew-virt-manager
2. Follow installation instructions

### Linux (Ubuntu/Debian)

```bash
# Install SPICE client tools
sudo apt update
sudo apt install virt-viewer spice-client-gtk

# Alternative clients
sudo apt install remmina  # Full-featured remote desktop client with SPICE support
```

### Linux (Fedora/RHEL/CentOS)

```bash
# Install SPICE client tools
sudo dnf install virt-viewer spice-gtk-tools

# Alternative
sudo dnf install remmina
```

## Connecting to the Container

Once you have a SPICE client installed:

1. **Start the container:**
   ```powershell
   .\launch.ps1
   ```

2. **Connect using your SPICE client:**
   - **Host:** `localhost` or `127.0.0.1`
   - **Port:** `5900`
   - **Password:** `password`

3. **Command line examples:**
   ```bash
   # Using remote-viewer
   remote-viewer spice://localhost:5900
   
   # Using spice-gtk-client
   spice-gtk-client --host localhost --port 5900
   ```

## Advantages of SPICE over VNC

- **Better Performance:** More efficient compression and caching
- **Audio Support:** Built-in audio redirection
- **Clipboard Sharing:** Copy/paste between host and container
- **USB Redirection:** Share USB devices (with proper configuration)
- **Multiple Monitors:** Better multi-monitor support
- **Encryption:** Built-in TLS encryption support

## Troubleshooting

### Connection Issues
- Ensure the container is running: `.\launch.ps1 -Status`
- Check if port 5900 is accessible: `netstat -an | findstr 5900`
- Verify firewall settings

### Performance Issues
- Try different SPICE clients (some perform better than others)
- Adjust display settings in your SPICE client
- Ensure hardware acceleration is enabled if available

### Client-Specific Issues

**Virt-Manager:**
- Make sure to select "SPICE" as the graphics type
- Enable clipboard sharing in viewer preferences

**Remote-viewer:**
- Use `--spice-debug` flag for troubleshooting
- Try `--full-screen` for better experience

## Notes

- SPICE provides better integration with modern desktop environments
- Some clients may require additional configuration for optimal experience
- Audio redirection works out of the box with most SPICE clients
