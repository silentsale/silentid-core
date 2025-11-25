@echo off
REM Start Azurite for SilentID Local Development

echo Starting Azurite...
echo.
echo This will start Azure Blob Storage emulator on:
echo - Blob Service: http://127.0.0.1:10000
echo.
echo Press Ctrl+C to stop Azurite
echo.

REM Create azurite directory if it doesn't exist
if not exist "C:\azurite" mkdir "C:\azurite"

REM Start Azurite
azurite --silent --location "C:\azurite" --blobPort 10000

echo.
echo Azurite stopped.
pause
