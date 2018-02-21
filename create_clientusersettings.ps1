Copy-Item -Path "C:\Program Files (x86)\Microsoft Dynamics NAV\*" -Destination "REPLACE" -Recurse -Force -ErrorAction Ignore
$destFolder = (Get-Item "REPLACE\*\RoleTailored Client").FullName
$ClientUserSettingsFileName = "c:\run\ClientUserSettings.config"
[xml]$ClientUserSettings = Get-Content $clientUserSettingsFileName
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""Server""]").value = "REPLACE"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ServerInstance""]").value="NAV"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ServicesCertificateValidationEnabled""]").value="false"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ClientServicesPort""]").value="7046"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ACSUri""]").value = ""
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""DnsIdentity""]").value = "REPLACE"
$clientUserSettings.SelectSingleNode("//configuration/appSettings/add[@key=""ClientServicesCredentialType""]").value = "NavUserPassword"
$clientUserSettings.Save("$destFolder\ClientUserSettings.config")
