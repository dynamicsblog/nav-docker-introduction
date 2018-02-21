<#
	Falls die Docker Hostmaschine auch bereits schon virtualisiert ist z.B Windows 10 physische Maschine mit Hyper-V und Virtuelle Maschine Server 2016 (Docker Host) dann
	muss man nested virtualization enablen und auch MacAddressSpoofing erlauben.
#>
#	enable nested virtualization auf der physischen Maschine zB. Windows 10
# set-VMProcessor -VMName "DevEnv 2016 (Docker/NAV 2018)" -ExposeVirtualizationExtensions $true

#	disable nested virtualization
# set-VMProcessor -VMName "DevEnv 2016 (Docker/NAV 2018)" -ExposeVirtualizationExtensions $false

#	enable MacAddressSpoofing auf der physischen Maschine zB. Windows 10
# Get-VMNetworkAdapter -VMName "DevEnv 2016 (Docker/NAV 2018)" | Set-VMNetworkAdapter -MacAddressSpoofing On

#	more infos
# https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting


<#
	Erstellen eines Containers mit EXTERNEN SQL Server
	am SQL Server muss dann natürlich die Datenbank erstellt werden (Restore Demo DB z.B "Demo Database NAV (11-0).bak")
	nicht vergessen den Benutzer "databaseUserName" die notwendigen Rechte zu geben 
	
	 --isolation hyperv ' ist Standard (und die einzige Option) unter Windows 10 und unter 
						' Server 2016 optional (bietet mehr isolation vom Betriebssystem startet aber langsamer)
#>
# docker run -e accept_eula=Y `
#	   -e DatabaseServer="W16-DC" `
#	   -e DatabaseInstance="NAV" `
#	   -e DatabaseName="Demo Database NAV (11-0)" `
#	   -e encryptionPassword="abc123ABC$%&abc123" <# kann auch weggelassen werden dann wird ein zufälliges erzeugt #>`
#	   -e databaseUserName="sa" `
#	   -e databasePassword="sa_passwort" `
#	   -e username="nav_user"                     <# NAV Benutzer #>`
#	   -e password="nav_user_pw_laut_passwortrichtlinie" `
#	   -e licensefile="c:\run\my\NAV2018_AT_Lizenz.flf" `
#	   -e ClickOnce=Y                             <# ClickOnce auch installieren optional#>`
#	   -v x:\share\nav18cu1v2:c:\run\my           <# Mapping eines vorhanden Verzeichnisses vom Host (x:\share\nav18cu1v2)in den Container (c:\run\my) #>`
#	   -m 2G                                      <# 2GB RAM reichen wenn SQL Server extern ist #>`
#	   --name nav18cu1v2                          <# Name des Container #>`
#	   --hostname nav18cu1v2 <# Name des Servers #>`
#	   --network=docker_lan --ip=10.0.1.203 --dns-search dev16.loc <# Wenn erwünscht optionales Netzwerk angeben mit fixer IP #>`
#	   --no-healthcheck=true                      <# healthcheck abschalten da viele fehlermeldungen im log des hosts #>`
#	   --isolation hyperv                         <# wenn angegeben ist der isolationsmodus hyperv dazu muss aber auch hyper-v installiert sein #>`
#	microsoft/dynamics-nav:2018-cu1-at
