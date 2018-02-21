# docker run -e accept_eula=Y `
#        -m 3G                                      
#        --name nav2018_ohneportoption                          <# Name #>`
# 	   --hostname nav2018_ohneportoption  <# Name Server #>`
#         microsoft/dynamics-nav:2018-cu1-at


# docker run -e accept_eula=Y `
# 	  -p 8080:8080 -p 80:80 -p 443:443 -p 7045-7049:7045-7049   <#specportmapping#>   `
#         -m 3G                `                       `
#         --name nav2018_spezportmapping                          <# Name #>`
# 	   --hostname nav2018_spezportmapping   <# Name Server #> `
#         microsoft/dynamics-nav:2018-cu1-at

# docker run -e accept_eula=Y `
# 	   -P                                       <# bind all ports#> `
# 	   -m 3G                 `                     `
# 	   --name nav2018_alleports                          <# Name  Container #>`
# 	   --hostname nav2018_alleports   <# Name Server #> `
#        microsoft/dynamics-nav:2018-cu1-at

# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)
# docker ps -a 
# docker ps --format "{{.Names}}: {{.Ports}}"
# docker ps  --no-trunc --format "{{.Command}}" 



