# Requirements Windows Server 2016
# Set-ExecutionPolicy -ExecutionPolicy unrestricted
# Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
# Install-Package -Name docker -ProviderName DockerMsftProvider
# Restart-Computer -Force

# optional configuration for images and container 
# New-Item C:\ProgramData\docker\config\daemon.json -Force -Value '{"data-root": "IhrLaufwerk:\\IhrVerzeichnis"}'
# Windows 10 New-Item C:\ProgramData\docker\config\daemon.json -Force -Value '{"graph": "x:\\docker"}'

# Stop-Service Docker -Force
# Start-Service Docker

# images  
# docker pull  microsoft/windowsservercore
# docker pull microsoft/dynamics-nav:2018-cu1-at # 
# docker run -e accept_eula=Y -m 3G microsoft/dynamics-nav:2018-cu1-at
# docker run -e accept_eula=Y `
#	   -e username="nav_user"                     <# NAV Benutzer #>`
# 	   -e password="nav_user_pw_laut_passwortrichtlinie" `
#      -e ClickOnce=Y                             <# ClickOnce optional#>`
#	   -v D:\docker\dateien:c:\run\my            <# Mapping Host  #>`
#	   -m 3G                                      <# RAM #>`
#	   --name nav18cu1v2                          <# Name des Container #>`
#	   --hostname nav18cu1v2 <# Name des Servers #>`
#	microsoft/dynamics-nav:2018-cu1-at


