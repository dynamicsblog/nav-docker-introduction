# different options: 
# docker cp D:\DateienLokal\MeinObjekt.txt WindowsSDateienKopieren:C:\Dateien
# docker cp D:\DateienLokal\. WindowsSDateienKopieren:C:\Dateien
# docker run -it --name WindowsSMapping `
            # -v D:\ContainerMapping:C:\docker\HostDateien `
            # microsoft/windowsservercore
