# setup directories and parameters
# $ountedContainerDir = "c:\run\my"
# $mountedHostDir = "D:\docker\Dateien"
# $clientInstallScripts = "C:\Users\vmadmin\Desktop\Docker\Learn4NAV_NAVClientInstall\"
# container must exist
# $containerName = "navcontainer"
# $containerHostname = "navcontainer"

# Copy-Item -Path "$clientInstallScripts\create_clientusersettings.ps1" -Destination $mountedHostDir -Recurse -Force -ErrorAction Ignore 
# docker exec $containerName powershell 'C:\run\my\create_clientusersettings.ps1'
# powershell "$($clientInstallScripts)add_symbolLinks.ps1"




 



