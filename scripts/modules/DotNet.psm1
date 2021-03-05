Function IsNetVersionInstalled($major, $minor) {
    $DotNetInstallationInfo = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse
    $InstalledDotNetVersions = $DotNetInstallationInfo | Get-ItemProperty -Name 'Version' -ErrorAction SilentlyContinue
    $InstalledVersionNumbers = $InstalledDotNetVersions | ForEach-Object { $_.Version -as [System.Version] }
    #$InstalledVersionNumbers;
    $Installed3Point5Versions = $InstalledVersionNumbers | Where-Object { $_.Major -eq $major -and $_.Minor -eq $minor }
    $DotNet3Point5IsInstalled = $Installed3Point5Versions.Count -ge 1
    return $DotNet3Point5IsInstalled
}

Function Install-NetFramework48() {
    if (!(IsNetVersionInstalled 4 8)) {
        Write-Host "Installing: .Net Version 4.8"
        choco install dotnetfx -y
        # Will need to restart so lets give the user a message and exit here.
        Write-BigMessage ".Net Framework Requires a Restart" "Please restart this computer and re run the install."
        Write-Error "Please Restart" -ErrorAction Stop
    }
    else { Write-Host "Skiping: .Net Version 4.8 as it is already installed." }
}

Function Install-NetCore31() {
    if (!(IsNetCoreVersionInstalled "3.1.12")) {
        Write-Host "Installing: .Net Core Version 3.1.12"
        choco install dotnetcore-windowshosting -y
        # Will need to restart so lets give the user a message and exit here.
        Write-BigMessage ".Net Core Framework Requires a Restart" "Please restart this computer and re run the install."
        Write-Error "Please Restart" -ErrorAction Stop
    }
    else { Write-Host "Skiping: .Net Core Version 3.1.12 as it is already installed." }
}