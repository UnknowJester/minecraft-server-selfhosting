@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "seleziona-mondo.ps1"
pause
