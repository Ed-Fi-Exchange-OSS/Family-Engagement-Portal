# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################
 
# Author: Douglas Loyo, Sr. Solutions Architect @ MSDF
 
# Description: Install script that downloads the repo zip en loads necesarry modules.

############################################################
#Requires -Version 5
#Requires -RunAsAdministrator

# 1) Ensure the working directories exists
$global:pathToBinaries = "C:\Ed-Fi\Bin\FamilyEngagement"
$global:pathToWorkingDir = "C:\Ed-Fi\QuickStarts\FamilyEngagement"
Write-Host "Step: Ensuring working path is accessible. ($global:pathToWorkingDir)"
New-Item -ItemType Directory -Force -Path $global:pathToWorkingDir
New-Item -ItemType Directory -Force -Path $global:pathToBinaries


# 2) Download and unzip the github powershell scripts (in zip format)
$packageUrl = "https://github.com/Ed-Fi-Exchange-OSS/Family-Engagement-Portal/archive/main.zip"
$outputpath = "$global:pathToBinaries\main.zip"
#Invoke-WebRequest -Uri $packageUrl -OutFile $outputpath
$wc = New-Object net.webclient
$wc.Downloadfile($packageUrl, $outputpath)
Expand-Archive -LiteralPath $outputpath -DestinationPath $global:pathToWorkingDir -Force

# 3) Execute script
$global:pathToAssets = "$global:pathToWorkingDir\Family-Engagement-Portal-main"
$pathToMainScript = "$global:pathToAssets\scripts\FamilyEngagementQuickStartInstall.ps1"
Invoke-Expression -Command $pathToMainScript