<#
.SYNOPSIS
This simple PowerShell script asks you to select the Virtual Machine (VM) that you want to resize within Azure, tells you the current size and then prompts you to select a new size from the available sizes for that VM.  Then goes ahead and resizes the VM.

.DESCRIPTION 
This simple PowerShell script asks you to select the Virtual Machine (VM) that you want to resize within Azure, tells you the current size and then prompts you to select a new size from the available sizes for that VM.  Then goes ahead and resizes the VM.

.OUTPUTS


.NOTES
Written by: Sarah Lean

Find me on:

* My Blog:	https://www.techielass.com
* Twitter:	https://twitter.com/techielass
* LinkedIn:	http://uk.linkedin.com/in/sazlean
* GitHub:   https://www.github.com/weeyin83


.EXAMPLE



Change Log
V1.00, 02/04/2019 - Initial version

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

# Gather the VM name to be resized
$VM = Read-Host -Prompt 'Input the name of the VM you wish to resize'

# Collect information about the VM that will be used later on for the resizing
$VMInfo = Get-AzVM -Name $VM

# Tell the end user what size the VM is currently
Write-Host "The current size of the VM is $($VMInfo.HardwareProfile.VmSize)" -Foregroundcolor Yellow

# Advise the user a pop up box is going to start and to select a size from it
Write-Host "Please select the new size for the VM, please note a pop up selection menu will display." -Foregroundcolor Yellow
write-Host "Press any key to continue..." -Foregroundcolor Yellow
[void][System.Console]::ReadKey($true) 

# Give the user the list to choice from
$Newsize = Get-AzVMSize -ResourceGroupName $VMinfo.resourcegroupname -VMName $VMinfo.name | Out-GridView -PassThru

# Output what size was choosen
Write-Host "$($Newsize.Name) selected" -Foregroundcolor Yellow
	
# Set the new VM size
$VMInfo.HardwareProfile.VmSize = $Newsize.name
Update-AzVM -VM $vminfo -ResourceGroupName $VMinfo.resourcegroupname

# Feedback to the user about the new size
Write-Host "The VM is now sized as $($VMInfo.HardwareProfile.VmSize)" -Foregroundcolor Yellow


