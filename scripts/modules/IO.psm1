# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################

# Author: Douglas Loyo, Sr. Solutions Architect @ MSDF

# Description: Module contains a collection of IO utility functions.

# Note: This powershell has to be ran with Elevated Permissions (As Administrator) and in a x64 environment.

############################################################
Function Write-SuccessInstallFile(){
    $path = $global:tempPathForBinaries + "Ed-Fi-BinInstall.txt"
    $content = 'Ed-Fi Installed Successfully on:'+ (Get-Date)
    Add-Content -Path $path -Value $content
}

Function Write-HostInfo($message) {
    $divider = "----"
    for($i=0;$i -lt $message.length;$i++){ $divider += "-" }
    Write-Host $divider -ForegroundColor Cyan
    Write-Host " " $message -ForegroundColor Cyan
    Write-Host $divider -ForegroundColor Cyan
}

Function Write-HostStep($message) {
    Write-Host "*** " $message " ***"-ForegroundColor Green
}

Function Write-BigMessage($title, $message) {
    $divider = "*** "
    for($i=0;$i -lt $message.length;$i++){ $divider += "*" }
    Write-Host $divider -ForegroundColor Green
    Write-Host "*"-ForegroundColor Green
    Write-Host "*** " $title " ***"-ForegroundColor Green
    Write-Host "*"-ForegroundColor Green
    Write-Host "* " $message " *"-ForegroundColor Green
    Write-Host "*"-ForegroundColor Green
    Write-Host $divider -ForegroundColor Green
}


Function Invoke-DownloadFile($url, $outputpath) {
    # Turn off the download progress bar as its faster this way.
    #$ProgressPreference = 'SilentlyContinue'
    #Invoke-WebRequest -Uri $url -OutFile $outputpath

    $wc = New-Object net.webclient
    $wc.Downloadfile($url, $outputpath)
}

Function Get-FileSize($file) {
    $fs = Get-Childitem -file $file | % {[int]($_.length / 1kb)}
    return $fs
}
function Add-DesktopAppLinks {
    [cmdletbinding(HelpUri="https://github.com/Ed-Fi-Exchange-OSS/Ed-Fi-Solution-Scripts")]
    param (
        $AppURIs,
        $solName=$null
    )
    # Example of what to pass in
    # $AppLinks = @(
    #               @{ name= "Link to a file"; type= "File"; URI="relative\\path\\file.ext" };
    #               @{ name= "WebLnk"; type= "URL"; URI="https://github.com/Ed-Fi-Alliance-OSS/Ed-Fi-ODS-AdminApp" }
    #             )
    #
    # Get Public Desktop to install links to Apps
    Write-Verbose "Adding Solution Links to Ed-Fi Solutions Folder on common Desktop"
    $pubDesktop=[Environment]::GetFolderPath("CommonDesktopDirectory")
    $EdFiSolFolder="$pubDesktop\Ed-Fi Solutions"
    if ($null -ne $solName) {
        $EdFiSolFolder="$pubDesktop\Ed-Fi Solutions\$solName"
    }
    $WScriptShell = New-Object -ComObject WScript.Shell
    if (! $(Try { Test-Path -ErrorAction SilentlyContinue $EdFiSolFolder } Catch { $false }) ) {
        $tooVerbose = New-Item -ItemType Directory -Force -Path $EdFiSolFolder
    }
    # Add URLs to public desktop
    foreach ($appInstall in $AppURIs | Where-Object {$_.type -eq "URL"}) {
        $Shortcut = $WScriptShell.CreateShortcut("$EdFiSolFolder\$($appInstall.name).url")
        $targetURL = $appInstall.URI
        if (!($targetURL -like "http*")) {
            $targetURL = $targetURL -Replace "^","https://localhost/"
        }
        $Shortcut.TargetPath = $targetURL
        $Shortcut.Save()
    }
    # Add File Links to public desktop, these can be regular files or programs
    foreach ($appInstall in $AppURIs | Where-Object {$_.type -eq "File"}) {
        $Shortcut = $WScriptShell.CreateShortcut("$EdFiSolFolder\$($appInstall.name).lnk")
        $Shortcut.TargetPath = $appInstall.URI
        $Shortcut.Save()
    }
    # Add File Links to public desktop, these can be regular files or programs
    foreach ($appInstall in $AppURIs | Where-Object {$_.type -eq "App"}) {
        $Shortcut = $WScriptShell.CreateShortcut("$EdFiSolFolder\$($appInstall.name).lnk")
        $Shortcut.TargetPath = "$($appInstall.command) $($appInstall.appfile)"
        $Shortcut.Save()
    }
}