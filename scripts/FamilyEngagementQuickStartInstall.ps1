# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################

# Authors:
# Douglas Loyo, Sr. Solutions Architect @ MSDF
# Luis Perez, Sr. Developer @ NearShoreDevs.com

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
Import-Module "$PSScriptRoot\modules\DemoDataScript" -Force

# TODO: Comment when done development:
$global:pathToBinaries = "C:\Ed-Fi\Bin\FamilyEngagement"
$global:pathToWorkingDir = "C:\Ed-Fi\QuickStarts\FamilyEngagement"

#
function Install-FamilyPortalPrerequisites() {
    Install-Chocolatey
    Install-NugetPackageProvider
    Install-SQLServerModule
    Install-MsSQLServerExpress
}

function Install-RecommendedTools{
    Install-Chrome
    Install-MsSSMS
}

function Install-FamilyPortalPostrequisities(){
    Install-VisualStudioCommunity
    Install-NetFramework471
    Install-RecommendedTools
}

function Install-OdsDatabase{

    $urlODSDatabase = "https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template/5.1.0"

    Write-Host "Downloading ODS database"
    $outputpath = "$global:pathToBinaries\EdFi.Suite3.Ods.Populated.Template.5.1.0.zip"
    Invoke-DownloadFile $urlODSDatabase $outputpath

    Write-Host "Unziping database"
    Expand-Archive -LiteralPath $outputpath -DestinationPath "$global:pathToWorkingDir\Db" -Force
}

function Restore-OdsDatabase(){
    Write-Host "Restoring database"
    $backupLocation = "$global:pathToWorkingDir\Db\"
    $db = @{
        src = "EdFi.Ods.Populated.Template"
        dest = "Ed-Fi_v5.1.0_ODS_FamilyEngagementQuickStart"
    }
    $dataFileDestination = Get-MsSQLDataFileDestination
    $logFileDestination = Get-MsSQLLogFileDestination

    Restore-Database  $db $db.dest $backupLocation $dataFileDestination $logFileDestination
}

function Add-DesktopAppLinks {
    # Get Public Desktop to install links to Apps
    Write-Host "Adding Solution Links to Ed-Fi Solutions Folder on common Desktop"
    $publicDesktop=[Environment]::GetFolderPath("CommonDesktopDirectory")
    $EdFiSolFolder="$publicDesktop\Ed-Fi Solutions\FamilyPortalQuickStart"

    $WScriptShell = New-Object -ComObject WScript.Shell
    New-Item -ItemType Directory -Force -Path $EdFiSolFolder

    $AppLinks = @{
            name= "Open ParentPortal Project in Visual Studio Community";
            URI = "$global:pathToWorkingDir\ParentPortal-main\Student1.ParentPortal.sln"
        }


    $Shortcut = $WScriptShell.CreateShortcut("$EdFiSolFolder\$($AppLinks.name).lnk")
    $Shortcut.TargetPath = $AppLinks.URI
    $Shortcut.Save()
}

# Starting Install
# 1) Install prerequisites
Write-HostInfo "Installing Family Engagement Quick Start."
Write-HostStep "Step: Ensuring all Prerequisites are installed."
Install-FamilyPortalPrerequisites

# 2) Download the 5.1.0 ODS .
Write-HostStep "Step: Installing Populated Ods Database"
Install-OdsDatabase
Restore-OdsDatabase
Add-DemoData

# 3) Create shortcuts on user's desktop
Write-HostStep "Step: Creating desktop links"
Add-DesktopAppLinks

# 4) Install Postrequisities
Write-HostStep "Step: Installing Family Engagement Postrequisities"
Install-FamilyPortalPostrequisities

$announcement = @"
***************************************************************
*                                                             *
*         The Ed-fi Family Portal   installation is complete  *
*                                                             *
***************************************************************
"@

Write-Host $announcement