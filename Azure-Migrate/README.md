# Azure Migrate

When using Azure Migrate to assess your environment for a move to the cloud there are two components that you should install on each of your servers to get the full picture of what they do, how they interact with other servers within your environment, etc.  Those components are the Microsoft Monitoring Agent (MMA) and the  Microsoft Dependency Agent. 

The Microsoft Monitoring Agent is a service that is used to watch and report on application and system health on your server. 

The Microsoft Dependency Agent feeds information into [Service Map](https://docs.microsoft.com/en-us/azure/monitoring/monitoring-service-map). 

This PowerShell script can be run on a Windows machine and it will download the correct component (32 bit or 64 bit) and then install it. 

The script needs your Log Analytics WorkSpace ID and Primary Key for the WorkSpace. 


## Credits

Written by: Sarah Lean

Find me on:

* My Blog: <https://www.techielass.com>
* Twitter: <https://twitter.com/techielass>
* LinkedIn: <http://uk.linkedin.com/in/sazlean>
* Github: <https://github.com/weeyin83>