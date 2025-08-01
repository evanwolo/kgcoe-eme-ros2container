@echo off
REM Batch wrapper for the PowerShell launch script
REM Usage: launch.bat [options]

if "%1"=="" (
    powershell -ExecutionPolicy Bypass -File "%~dp0launch.ps1"
) else (
    powershell -ExecutionPolicy Bypass -File "%~dp0launch.ps1" %*
)
