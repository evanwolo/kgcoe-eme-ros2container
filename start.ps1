# PowerShell script to start the ROS2 container
Write-Host "Starting ROS2 Development Container..." -ForegroundColor Green

# Build and start the container
docker-compose up --build -d

Write-Host ""
Write-Host "Container started successfully!" -ForegroundColor Green
Write-Host "Access options:" -ForegroundColor Yellow
Write-Host "  VNC Viewer: localhost:5901 (password: password)" -ForegroundColor Cyan
Write-Host "  Web VNC: http://localhost:6901 (if noVNC is configured)" -ForegroundColor Cyan
Write-Host ""
Write-Host "To check ROS2 version inside the container:" -ForegroundColor Yellow
Write-Host "  1. Connect via VNC" -ForegroundColor White
Write-Host "  2. Open terminal in XFCE" -ForegroundColor White
Write-Host "  3. Run: ros2 --version" -ForegroundColor White
Write-Host ""
Write-Host "To access container shell directly:" -ForegroundColor Yellow
Write-Host "  docker exec -it ros-jazzy-gui-container bash" -ForegroundColor White
