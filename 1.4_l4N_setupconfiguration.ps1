# setup path for images and container - difference W10 und WS2016
# New-Item C:\ProgramData\docker\config\daemon.json -Force -Value '{"data-root": "x:\\docker"}'
# New-Item C:\ProgramData\docker\config\daemon.json -Force -Value '{"graph": "x:\\docker"}'
# Stop-Service Docker -Force
# Start-Service Docker