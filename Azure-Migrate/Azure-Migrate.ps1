<#
.SYNOPSIS
Deploys the Azure Migrate Dependency Agent and Microsoft Monitoring Agent (MMA). 

.DESCRIPTION 
This script installs the Depdency Agent and MMA component to allow full discover and assessment to take place of your servers in conjunction with Azure Migrate.  

The script requires PowerShell version 2.0 or above. 

Tested on the following platforms:

- Windows Server 2008 R2, Version 6.1 (Build 7601: Service Pack 1)
- Windows Server 2012 R2, Version 6.3 (Build 9600)
- Windows Server 2016, Version 1607 (OS Build 14393.2363)

.OUTPUTS


.NOTES
Written by: Sarah Lean

Find me on:

* My Blog:	https://www.techielass.com
* Twitter:	https://twitter.com/techielass
* LinkedIn:	http://uk.linkedin.com/in/sazlean
* GitHub:   https://www.github.com/weeyin83


.EXAMPLE

The below example will run the script without any on screen feedback.
.\Azure-Migrate.ps1 -WorkSpaceID 123456789 -WorkSpaceKey 123456789

The below example will run the script with onscreen feedback as to what it is doing. 
.\Azure-Migrate.ps1 -WorkSpaceID 123456789 -WorkSpaceKey 123456789 -Verbose

Change Log
V1.00, 02/10/2018 - Initial version

License:

The MIT License (MIT)

Copyright (c) 2018 Sarah Lean

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.

#>

#
# Parameters
#

param(
[parameter(Mandatory=$true, HelpMessage="OMS Log Analytics Workspace ID")]
[ValidateNotNullOrEmpty()]
[string]$WorkSpaceID,
[parameter(Mandatory=$true, HelpMessage="OMS Log Analytics Workspace Key")]
[ValidateNotNullOrEmpty()]
[string]$WorkSpaceKey
)

# Set the parameters
$64FileName = "MMASetup-AMD64.exe"
$32FileName = "MMASetup-i386.exe"
$SMFileName = "InstallDependencyAgent-Windows.exe"
$StorageFolder = 'C:\MigrateInstallSource'
$64MMAFile = $StorageFolder + "\" + $64FileName
$32MMAFile = $StorageFolder + "\" + $32FileName
$SMFile = $StorageFolder + "\" + $SMFileName

# Check if folder exists, if not, create it
Write-Verbose "Create folder $StorageFolder..."
New-Item $StorageFolder -type Directory -Force | Out-Null
Write-Verbose "Folder Created!"
# Change the location to the specified folder
Set-Location $StorageFolder



#
# This section tries to determine if the Operating System is 32 bit or 64 bit. 
#
function OSBitness64
{
    if (Test-Path -Path "C:\Program Files (x86)")
    {
        return $true;
    }
    else 
    {
        return $false;
    }
}

if (OSBitness64 -eq $true)
{
    # Download OMS Log Analytics monitoring agent
    Write-Verbose "Downloading 64 bit Monitoring Agent..."
    $URL = "https://go.microsoft.com/fwlink/?LinkId=828603"
    Invoke-WebRequest -Uri $URl -OutFile $64MMAFile | Out-Null
    Write-Verbose "64 bit Montioring Agent Downloaded!"

    # Download OMS Log Analytics dependency agent
    Write-Verbose "Downloading Dependency Agent..."
    $URL = "https://aka.ms/dependencyagentwindows"
    Invoke-WebRequest -Uri $URl -OutFile $SMFile | Out-Null
    Write-Verbose "Dependency Agent Downloaded!"

    # Install the Microsoft Monitoring Agent
    Write-Verbose "Installing Microsoft Monitoring Agent.."
    $ArgumentList = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+ "OPINSIGHTS_WORKSPACE_ID=$WorkspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$WorkSpaceKey " +'AcceptEndUserLicenseAgreement=1"'
    Start-Process $64FileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
    Write-Verbose "Microsoft Monitoring Agent installed!"

    # Install the Service Map Agent
    Write-Verbose "Installing Dependency Agent.."
    $ArgumentList = '/C:"InstallDependencyAgent-Windows.exe /S /AcceptEndUserLicenseAgreement:1"'
    Start-Process $SMFileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
    Write-Verbose "Dpendency Agent installed!"

    # Change the location to C: to remove the created folder
    Set-Location -Path "C:\"
    # Remove the folder with the agent files
    Write-Verbose "Removing the folder $StorageFolder ..."
    Remove-Item $StorageFolder -Force -Recurse | Out-Null
    Write-Verbose "Folder removed!"
}
else
{
    # Download OMS Log Analytics monitoring agent
    Write-Verbose "Downloading 32 bit Monitoring Agent..."
    $URL = "https://go.microsoft.com/fwlink/?LinkId=828604"
    Invoke-WebRequest -Uri $URl -OutFile $MMAFile | Out-Null
    Write-Verbose "64 bit Montioring Agent Downloaded!"

    # Download OMS Log Analytics dependency agent
    Write-Verbose "Downloading Dependency Agent..."
    $URL = "https://aka.ms/dependencyagentwindows"
    Invoke-WebRequest -Uri $URl -OutFile $SMFile | Out-Null
    Write-Verbose "Dependency Agent Downloaded!"

    # Install the Microsoft Monitoring Agent
    Write-Verbose "Installing Microsoft Monitoring Agent.."
    $ArgumentList = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+ "OPINSIGHTS_WORKSPACE_ID=$WorkspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$WorkSpaceKey " +'AcceptEndUserLicenseAgreement=1"'
    Start-Process $32FileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
    Write-Verbose "Microsoft Monitoring Agent installed!"

    # Install the Service Map Agent
    Write-Verbose "Installing Dependency Agent.."
    $ArgumentList = '/C:"InstallDependencyAgent-Windows.exe /S /AcceptEndUserLicenseAgreement:1"'
    Start-Process $SMFileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null
    Write-Verbose "Dpendency Agent installed!"

    # Change the location to C: to remove the created folder
    Set-Location -Path "C:\"
    # Remove the folder with the agent files
    Write-Verbose "Removing the folder $StorageFolder ..."
    Remove-Item $StorageFolder -Force -Recurse | Out-Null
    Write-Verbose "Folder removed!"
}