﻿# Enter-NavContainer navcontainer

# Source Microsoft C:\run 

function Restore-SQLBackup {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$bakFile, 
        [Parameter(Mandatory=$true)]
        [string]$databaseServer, 
        [Parameter(Mandatory=$true)]
        [string]$databaseInstance = "", 
        [Parameter(Mandatory=$true)]
        [string]$DatabaseName = "",
        [Parameter(Mandatory=$true)]
        [int]$SqlTimeout 
    )

# INPUT
#     $restartingInstance (optional)
#     $bakFile (optional)
#     $appBacpac and tenantBacpac (optional)
#     $databaseCredentials (optional)
#
# OUTPUT
#     $databaseServer
#     $databaseInstance
#     $databaseName
#

if ($restartingInstance) {

    # Nothing to do

} elseif ($bakfile -ne "") {

    # .bak file specified - restore and use
    # if bakfile specified, download, restore and use
    
    if ($bakfile.StartsWith("https://") -or $bakfile.StartsWith("http://"))
    {
        $bakfileurl = $bakfile
        $databaseFile = (Join-Path $runPath "mydatabase.bak")
        Write-Host "Downloading database backup file '$bakfileurl'"
        (New-Object System.Net.WebClient).DownloadFile($bakfileurl, $databaseFile)
    
    } else {

        Write-Host "Using Database .bak file '$bakfile'"
        if (!(Test-Path -Path $bakfile -PathType Leaf)) {
        	Write-Error "ERROR: Database Backup File not found."
            Write-Error "The file must be uploaded to the container or available on a share."
            exit 1
        }
        $databaseFile = $bakFile
    }

    # Restore database
    $databaseFolder = "c:\databases"
    
    if (!(Test-Path -Path $databaseFolder -PathType Container)) {
        New-Item -Path $databaseFolder -itemtype Directory | Out-Null
    }

    New-NAVDatabase -DatabaseServer $databaseServer `
                    -DatabaseInstance $databaseInstance `
                    -DatabaseName "$databaseName" `
                    -FilePath "$databaseFile" `
                    -DestinationPath "$databaseFolder" `
                    -Timeout $SqlTimeout | Out-Null

    if ($multitenant) {
        Copy-NavDatabase -SourceDatabaseName $databaseName -DestinationDatabaseName "tenant"
        Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName "tenant" -Force | Out-Null
    }

} elseif ("$appBacpac" -ne "" -and "$tenantBacpac" -ne "") {

    # appBacpac and tenantBacpac specified - restore and use
    
    $dbName = "app"
    $appBacpac, $tenantBacpac | % {
        if ($_.StartsWith("https://") -or $_.StartsWith("http://"))
        {
            $databaseFile = (Join-Path $runPath "${dbName}.bacpac")
            Write-Host "Downloading ${dbName}.bacpac"
            (New-Object System.Net.WebClient).DownloadFile($_, $databaseFile)
        } else {
            if (!(Test-Path -Path $_ -PathType Leaf)) {
        	    Write-Error "ERROR: Database Backup File not found."
                Write-Error "The file must be uploaded to the container or available on a share."
                exit 1
            }
            $databaseFile = $_
        }
        Restore-BacpacWithRetry -Bacpac $databaseFile -DatabaseName $dbName
        $dbName = "tenant"
    }

    $databaseServer = "localhost"
    $databaseInstance = "SQLEXPRESS"
    $databaseName = "app"

    if ("$licenseFile" -eq "") {
        $licenseFile = Join-Path $serviceTierFolder "Cronus.flf"
    }

} elseif ($databaseCredentials) {

    if (Test-Path $myPath -PathType Container) {
        $EncryptionKeyFile = Join-Path $myPath 'DynamicsNAV.key'
    } else {
        $EncryptionKeyFile = Join-Path $runPath 'DynamicsNAV.key'
    }
    if (!(Test-Path $EncryptionKeyFile -PathType Leaf)) {
        New-NAVEncryptionKey -KeyPath $EncryptionKeyFile -Password $EncryptionSecurePassword -Force | Out-Null
    }

    Set-NAVServerConfiguration -ServerInstance "NAV" -KeyName "EnableSqlConnectionEncryption" -KeyValue "true" -WarningAction SilentlyContinue
    Set-NAVServerConfiguration -ServerInstance "NAV" -KeyName "TrustSQLServerCertificate" -KeyValue "true" -WarningAction SilentlyContinue

    Write-Host "Import Encryption Key"
    Import-NAVEncryptionKey -ServerInstance NAV `
                            -ApplicationDatabaseServer $databaseServer `
                            -ApplicationDatabaseCredentials $DatabaseCredentials `
                            -ApplicationDatabaseName $DatabaseName `
                            -KeyPath $EncryptionKeyFile `
                            -Password $EncryptionSecurePassword `
                            -WarningAction SilentlyContinue `
                            -Force
    
    Set-NavServerConfiguration -serverinstance "NAV" -databaseCredentials $DatabaseCredentials -WarningAction SilentlyContinue

} elseif ($databaseServer -eq "localhost" -and $databaseInstance -eq "SQLEXPRESS" -and $multitenant) {
    
    Copy-NavDatabase -SourceDatabaseName $databaseName -DestinationDatabaseName "tenant"
    Remove-NAVApplication -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName "tenant" -Force | Out-Null

}
}