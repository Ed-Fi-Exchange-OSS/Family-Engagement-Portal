# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################

# Author: Douglas Loyo, Sr. Solutions Architect @ MSDF

# Description: Module contains a collection of utility functions that help check if software is installed and if powershell commands are available.

############################################################

Function Find-SoftwareInstalled($software)
{
    # To debug use this in your powershell
    # (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName
    return (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Contains $software
}

Function Find-PowershellCommand($command) {
    # Save the current Error Action Preference
    $currentErrorActionPreference=$ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try {if(Get-Command $command){return $true}}
    Catch {return $false}
    Finally {$ErrorActionPreference=$currentErrorActionPreference}
}
function Install-Chrome(){
    if(!(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe'))
    {
        Write-Host "Installing: Google Chrome..."
        choco install googlechrome -F -y --ignore-checksum
        #Refres env and reload path in the Shell
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        refreshenv

        ##Set as default brower
    } else {
        Write-Host "Skipping: google chrome there is already a google chrome version installed."
    }
}

function Install-Nuget(){
    Install-PackageProvider -Force -Name 'NuGet'
}