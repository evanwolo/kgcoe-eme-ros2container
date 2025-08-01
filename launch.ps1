#!/usr/bin/env pwsh
# Unified ROS2 Container Launch Script
# Author: Evan Wologodzew - emweee

param(
    [switch]$Stop,
    [switch]$Restart,
    [switch]$Shell,
    [switch]$Status,
    [switch]$Logs,
    [switch]$Help
)

$ContainerName = "ros-jazzy-gui-container"

function Show-Help {
    Write-Host "ROS2 Container Management Script" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\launch.ps1           - Start the container (default)" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Stop     - Stop the container" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Restart  - Restart the container" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Shell    - Open shell in running container" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Status   - Show container status" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Logs     - Show container logs" -ForegroundColor White
    Write-Host "  .\launch.ps1 -Help     - Show this help" -ForegroundColor White
    Write-Host ""
    Write-Host "Access Methods:" -ForegroundColor Yellow
    Write-Host "  SPICE Client: localhost:5900 (password: password)" -ForegroundColor Cyan
    Write-Host "  Recommended clients: Virt-Manager, remote-viewer, spice-gtk-client" -ForegroundColor Gray
    Write-Host ""
}

function Test-ContainerRunning {
    $running = docker ps --filter "name=$ContainerName" --format "{{.Names}}" 2>$null
    return $running -eq $ContainerName
}

function Test-ContainerExists {
    $exists = docker ps -a --filter "name=$ContainerName" --format "{{.Names}}" 2>$null
    return $exists -eq $ContainerName
}

function Start-Container {
    Write-Host "🚀 Starting ROS2 Development Container..." -ForegroundColor Green
    Write-Host ""
    
    if (Test-ContainerRunning) {
        Write-Host "✅ Container is already running!" -ForegroundColor Yellow
        Show-AccessInfo
        return
    }
    
    # Build and start the container
    Write-Host "📦 Building and starting container..." -ForegroundColor Blue
    docker-compose up --build -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Container started successfully!" -ForegroundColor Green
        Start-Sleep -Seconds 3  # Give VNC time to start
        Show-AccessInfo
        Show-RosCommands
    } else {
        Write-Host "❌ Failed to start container!" -ForegroundColor Red
        exit 1
    }
}

function Stop-Container {
    Write-Host "🛑 Stopping ROS2 Container..." -ForegroundColor Yellow
    
    if (-not (Test-ContainerExists)) {
        Write-Host "ℹ️  Container doesn't exist." -ForegroundColor Blue
        return
    }
    
    docker-compose down
    Write-Host "✅ Container stopped." -ForegroundColor Green
}

function Restart-Container {
    Write-Host "🔄 Restarting ROS2 Container..." -ForegroundColor Yellow
    Stop-Container
    Start-Sleep -Seconds 2
    Start-Container
}

function Open-Shell {
    if (-not (Test-ContainerRunning)) {
        Write-Host "❌ Container is not running! Start it first with: .\launch.ps1" -ForegroundColor Red
        return
    }
    
    Write-Host "🐚 Opening shell in container..." -ForegroundColor Blue
    Write-Host "   Type 'exit' to return to host shell" -ForegroundColor Gray
    Write-Host ""
    
    docker exec -it $ContainerName bash
}

function Show-Status {
    Write-Host "📊 Container Status" -ForegroundColor Green
    Write-Host "==================" -ForegroundColor Green
    Write-Host ""
    
    if (Test-ContainerRunning) {
        Write-Host "Status: " -NoNewline -ForegroundColor Yellow
        Write-Host "🟢 RUNNING" -ForegroundColor Green
        
        # Show container info
        $info = docker inspect $ContainerName --format "{{.State.StartedAt}}" 2>$null
        if ($info) {
            Write-Host "Started: $info" -ForegroundColor Gray
        }
        
        # Show port mappings
        Write-Host ""
        Write-Host "Port Mappings:" -ForegroundColor Yellow
        docker port $ContainerName 2>$null
        
        Show-AccessInfo
        
    } elseif (Test-ContainerExists) {
        Write-Host "Status: " -NoNewline -ForegroundColor Yellow
        Write-Host "🔴 STOPPED" -ForegroundColor Red
        Write-Host "Use '.\launch.ps1' to start the container" -ForegroundColor Gray
    } else {
        Write-Host "Status: " -NoNewline -ForegroundColor Yellow
        Write-Host "⚫ NOT CREATED" -ForegroundColor Gray
        Write-Host "Use '.\launch.ps1' to create and start the container" -ForegroundColor Gray
    }
}

function Show-Logs {
    if (-not (Test-ContainerExists)) {
        Write-Host "❌ Container doesn't exist!" -ForegroundColor Red
        return
    }
    
    Write-Host "📋 Container Logs (last 50 lines)" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
    
    docker logs --tail 50 $ContainerName
}

function Show-AccessInfo {
    Write-Host ""
    Write-Host "🔗 Access Methods:" -ForegroundColor Yellow
    Write-Host "  SPICE Client: " -NoNewline -ForegroundColor White
    Write-Host "localhost:5900" -ForegroundColor Cyan -NoNewline
    Write-Host " (password: " -ForegroundColor White -NoNewline
    Write-Host "password" -ForegroundColor Green -NoNewline
    Write-Host ")" -ForegroundColor White
    Write-Host "  Recommended clients: " -NoNewline -ForegroundColor White
    Write-Host "Virt-Manager, remote-viewer, spice-gtk-client" -ForegroundColor Gray
    Write-Host "  Shell Access: " -NoNewline -ForegroundColor White
    Write-Host ".\launch.ps1 -Shell" -ForegroundColor Cyan
    Write-Host ""
}

function Show-RosCommands {
    Write-Host "🤖 ROS2 Commands (use in VNC terminal or shell):" -ForegroundColor Yellow
    Write-Host "  Check ROS version: " -NoNewline -ForegroundColor White
    Write-Host "printenv ROS_DISTRO" -ForegroundColor Cyan
    Write-Host "  List packages: " -NoNewline -ForegroundColor White
    Write-Host "ros2 pkg list" -ForegroundColor Cyan
    Write-Host "  List topics: " -NoNewline -ForegroundColor White
    Write-Host "ros2 topic list" -ForegroundColor Cyan
    Write-Host "  Launch RViz: " -NoNewline -ForegroundColor White
    Write-Host "rviz2" -ForegroundColor Cyan
    Write-Host "  Launch rqt: " -NoNewline -ForegroundColor White
    Write-Host "rqt" -ForegroundColor Cyan
    Write-Host ""
}

# Main script logic
if ($Help) {
    Show-Help
    exit 0
}

if ($Stop) {
    Stop-Container
    exit 0
}

if ($Restart) {
    Restart-Container
    exit 0
}

if ($Shell) {
    Open-Shell
    exit 0
}

if ($Status) {
    Show-Status
    exit 0
}

if ($Logs) {
    Show-Logs
    exit 0
}

# Default action: Start container
Start-Container
