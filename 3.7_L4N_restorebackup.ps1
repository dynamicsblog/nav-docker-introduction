# Restore-SQLBackup required

# docker run -e accept_eula=Y `
           # -v D:\docker\Dateien:c:\run\my           `
           # -m 3G          `
           # --name navcontainer  `
           #  --hostname navcontainer   `
 # microsoft/dynamics-nav:2018-cu1-at

# Enter-NavContainer navcontainer

# Restore-SQLBackup -bakfile C:\run\my\dbbak\meinbackup.bak -databaseserver localhost -databaseinstance SQLEXPRESS -databaseName MeineDB -SQLtimeout 100000