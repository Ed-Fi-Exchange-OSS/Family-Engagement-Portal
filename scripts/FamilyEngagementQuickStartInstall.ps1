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

Write-Host $PSScriptRoot

Import-Module "$PSScriptRoot\modules\IO" -Force
Import-Module "$PSScriptRoot\modules\Software" -Force
Import-Module "$PSScriptRoot\modules\Chocolatey" -Force
Import-Module "$PSScriptRoot\modules\DotNet" -Force
Import-Module "$PSScriptRoot\modules\MsSQLServer" -Force

# TODO: Comment when done development: 
$global:pathToBinaries = "C:\Ed-Fi\Bin\FamilyEngagement"
$global:pathToWorkingDir = "C:\Ed-Fi\QuickStarts\FamilyEngagement"

#
Function Install-FamilyPortalPrerequisites() {
    Find-MsSQLServerDependency "."
    Install-MsSQLServerExpress
    Install-MsSSMS
    Install-NetFramework48
}

#Starting Install
# 1) Install prerequisits
Write-HostInfo "Installing Family Engagement Quick Start."
Write-HostStep "Step: Ensuring all Prerequisites are installed."
Install-FamilyPortalPrerequisites


# 2) Download the 5.1.0 ODS and restore it.
# 2.1) Run the SQL update scripts.

# 3) Create shortcuts on user's desktop
