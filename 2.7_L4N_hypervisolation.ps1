# Install-WindowsFeature -Name Hyper-V -ComputerName localhost -IncludeManagementTools -Restart

# docker run -it -e accept_eula=Y `
       # --name windowsservercontainer                         <# Name  #> `
       # microsoft/windowsservercore
# get-process ping #sichtbar auf Host


# docker run -it -e accept_eula=Y `
       # --isolation hyperv                         <# hyperv isolation mode #>`          `
       # --name windowshypervcontainer                         <# Name Container #> `
       # microsoft/windowsservercore

# get-process ping # process isolated - not visible on the host 


