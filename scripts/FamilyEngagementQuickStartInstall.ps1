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
Import-Module "$PSScriptRoot\modules\DemoDataScript" -Force

# TODO: Comment when done development:
$global:pathToBinaries = "C:\Ed-Fi\Bin\FamilyEngagement"
$global:pathToWorkingDir = "C:\Ed-Fi\QuickStarts\FamilyEngagement"

#
Function Install-FamilyPortalPrerequisites() {
    Install-Chocolatey
    Install-Nuget
    Install-Chrome
    Find-MsSQLServerDependency "."
    Install-MsSQLServerExpress
    Install-MsSSMS

}
function Install-FamilyPortalPostRequisities(){
    Install-NetFramework48
}
function Install-OdsDatabase{

    $urlODSDatabase = "https://www.myget.org/F/ed-fi/api/v2/package/EdFi.Suite3.Ods.Populated.Template/5.1.0"

    Write-HostInfo "Downloading ODS database"
    $wc = New-Object net.webclient
    $outputpath = "$global:pathToBinaries\EdFi.Suite3.Ods.Populated.Template.5.1.0.zip"
    $wc.Downloadfile($urlODSDatabase, $outputpath)

    Write-HostInfo "Unziping database"
    Expand-Archive -LiteralPath $outputpath -DestinationPath "$global:pathToWorkingDir\Db" -Force
}
function Restore-OdsDatabase(){
    $backupLocation = "$global:pathToWorkingDir\Db\"
    $db = @{
        src = "EdFi.Ods.Populated.Template"
        dest = "EdFi_Ods_Populated_Template_Test"
    }
    $dataFileDestination = Get-MsSQLDataFileDestination
    $logFileDestination = Get-MsSQLLogFileDestination

    Restore-Database  $db $db.dest $backupLocation $dataFileDestination $logFileDestination

}
function Add-DesktopAppLinks {
    # Get Public Desktop to install links to Apps
    Write-Verbose "Adding Solution Links to Ed-Fi Solutions Folder on common Desktop"
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
#Starting Install
# 1) Install prerequisites
Write-HostInfo "Installing Family Engagement Quick Start."
Write-HostStep "Step: Ensuring all Prerequisites are installed."

Install-FamilyPortalPrerequisites

# 2) Download the 5.1.0 ODS .
Write-HostInfo "Installing Ods Database."

Install-OdsDatabase

#Restore  ODS database
Write-HostStep "Step: MsSQL Restoring databases"

Restore-OdsDatabase

# # 2.1) Run the SQL update scripts.
Write-HostStep "Executing Sql scripts to populate Parent portal demo."

Add-DemoData

# # 3) Create shortcuts on user's desktop
Write-HostInfo "Creating desktop links"

Add-DesktopAppLinks

#Install Netframework 4.8 at the end to avoid re-run script
Install-FamilyPortalPostRequisities


$announcement = @"
***************************************************************
*                                                             *
* Please reboot your system now to apply updates any updates  *
*                                                             *
* The Ed-Fi Solution Installation is complete                 *
*                                                             *
* See Solution installation packages here:                    *
*                                                             *
*                                                             *
***************************************************************
"@

Write-Host $announcement