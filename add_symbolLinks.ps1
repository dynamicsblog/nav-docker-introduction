function New-DesktopShortcut {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Name, 
        [Parameter(Mandatory=$true)]
        [string]$TargetPath, 
        [string]$WorkingDirectory = "", 
        [string]$IconLocation = "", 
        [string]$Arguments = "",
        [ValidateSet('None','Desktop','StartMenu')]
        [string]$shortcuts = "Desktop",
        [switch]$RunAsAdministrator = $true
    )
    if ($shortcuts -ne "None") {
        
        if ($shortcuts -eq "Desktop") {
            $folder = [Environment]::GetFolderPath($shortcuts)
        } else {
            $folder = Join-Path ([Environment]::GetFolderPath($shortcuts)) "NavContainerHelper"
            if (!(Test-Path $folder -PathType Container)) {
                New-Item $folder -ItemType Directory | Out-Null
            }
        }

        $filename = Join-Path $folder "$Name.lnk"
        if (Test-Path -Path $filename) {
            Remove-Item $filename -force
        }
    
        $Shell =  New-object -comobject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($filename)
        $Shortcut.TargetPath = $TargetPath
        if (!$WorkingDirectory) {
            $WorkingDirectory = Split-Path $TargetPath
        }
        $Shortcut.WorkingDirectory = $WorkingDirectory
        if ($Arguments) {
            $Shortcut.Arguments = $Arguments
        }
        if ($IconLocation) {
            $Shortcut.IconLocation = $IconLocation
        }
        $Shortcut.save()
        if ($RunAsAdministrator) {
            $bytes = [System.IO.File]::ReadAllBytes($filename)
            $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
            [System.IO.File]::WriteAllBytes($filename, $bytes)
        }
    }
}
$programFilesFolder = 'X:\share\nav18cu1v2\navpfiles'
$shortcuts = 'Desktop'
$containerName = 'nav18cu1v2'


New-DesktopShortcut -Name "$containerName PowerShell Prompt" -TargetPath "CMD.EXE" -IconLocation "C:\Program Files\Docker\docker.exe, 0" -Arguments "/C docker.exe exec -it $containerName powershell -noexit c:\run\prompt.ps1" -Shortcuts $shortcuts
$winClientFolder = (Get-Item "$programFilesFolder\*\RoleTailored Client").FullName
New-DesktopShortcut -Name "$containerName Windows Client" -TargetPath "$WinClientFolder\Microsoft.Dynamics.Nav.Client.exe" -Shortcuts $shortcuts

Write-Host "Read CustomSettings.config from $containerName"
$ps = '$customConfigFile = Join-Path (Get-Item ''C:\Program Files\Microsoft Dynamics NAV\*\Service'').FullName "CustomSettings.config"
    [System.IO.File]::ReadAllText($customConfigFile)'
[xml]$customConfig = docker exec $containerName powershell $ps

$databaseInstance = $customConfig.SelectSingleNode("//appSettings/add[@key='DatabaseInstance']").Value
$databaseName = $customConfig.SelectSingleNode("//appSettings/add[@key='DatabaseName']").Value
$databaseServer = $customConfig.SelectSingleNode("//appSettings/add[@key='DatabaseServer']").Value
if ($databaseServer -eq "localhost") {
	$databaseServer = "$containerName"
}

if ($auth -eq "Windows") {
	$ntauth="1"
} 
	else {
		$ntauth="0"
	}
			
if ($databaseInstance) { $databaseServer += "\$databaseInstance" }
$csideParameters = "servername=$databaseServer, Database=$databaseName, ntauthentication=$ntauth"

$enableSymbolLoadingKey = $customConfig.SelectSingleNode("//appSettings/add[@key='EnableSymbolLoadingAtServerStartup']")
if ($enableSymbolLoadingKey -ne $null -and $enableSymbolLoadingKey.Value -eq "True") {
            $csideParameters += ", generatesymbolreference=1"
			}

New-DesktopShortcut -Name "$containerName CSIDE" -TargetPath "$WinClientFolder\finsql.exe" -Arguments $csideParameters -Shortcuts $shortcuts