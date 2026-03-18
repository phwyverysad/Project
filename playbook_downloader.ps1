<#
.SYNOPSIS
#>

$ErrorActionPreference = "Stop"

if ($MyInvocation.MyCommand.Path) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $ScriptDir = $PWD
}
Set-Location $ScriptDir

$AME_URL = "https://github.com/Ameliorated-LLC/trusted-uninstaller-cli/releases/download/0.8.4/AME-Beta-v0.8.4.exe"
$REVI_URL = "https://github.com/meetrevision/playbook/releases/download/25.10/Revi-PB-25.10.apbx"

Function Download-File {
    param([string]$Url, [string]$Name)
    if ($Url -eq $null -or $Url -eq "") { return }
    Write-Host ">>> Downloading: $Name..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $Url -OutFile "$ScriptDir\$Name" -UseBasicParsing
}

Clear-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "             OS PLAYBOOK DOWNLOADER" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "[1] AME Beta + AtlasOS + ReviOS"
Write-Host "[2] AtlasOS"
Write-Host "[3] ReviOS"
Write-Host "[4] AME Beta"
Write-Host "==================================================="
$main_choice = Read-Host "Select an option (1-4)"

$filesToDownload = @()

if ($main_choice -match '^[1-4]$') {
   
    if ($main_choice -in @('1', '2')) {
        Clear-Host
        Write-Host "Select Windows Version for AtlasOS:" -ForegroundColor Yellow
        Write-Host "[1] Windows 11 25H2"
        Write-Host "[2] Windows 11 24H2"
        Write-Host "[3] Windows 11 23H2 or older"
        Write-Host "[4] Windows 10 22H2"
        $ver = Read-Host "Selection"
        
        $atlas_map = @{
            "1" = @("https://github.com/Atlas-OS/Atlas/releases/download/0.5.0-hotfix/AtlasPlaybook_v0.5.0-hotfix.apbx", "AtlasPlaybook_v0.5.0-hotfix.apbx")
            "2" = @("https://github.com/Atlas-OS/Atlas/releases/download/0.4.1/AtlasPlaybook_v0.4.1.apbx", "AtlasPlaybook_v0.4.1.apbx")
            "3" = @("https://github.com/Atlas-OS/Atlas/releases/download/0.4.0/AtlasPlaybook_v0.4.0.apbx", "AtlasPlaybook_v0.4.0.apbx")
            "4" = @("https://github.com/Atlas-OS/Atlas/releases/download/0.4.0/AtlasPlaybook_v0.4.0.apbx", "AtlasPlaybook_v0.4.0.apbx")
        }
        $atlas = $atlas_map[$ver]
        
        if ($null -eq $atlas) {
            Write-Host "Invalid Version Selection!" -ForegroundColor Red
            return
        }
    }

   
    if ($main_choice -eq '1') {
        $filesToDownload += ,@($AME_URL, "AME-Beta-v0.8.4.exe")
        $filesToDownload += ,@($atlas[0], $atlas[1])
        $filesToDownload += ,@($REVI_URL, "Revi-PB-25.10.apbx")
    }
    elseif ($main_choice -eq '2') {
        $filesToDownload += ,@($atlas[0], $atlas[1])
    }
    elseif ($main_choice -eq '3') {
        $filesToDownload += ,@($REVI_URL, "Revi-PB-25.10.apbx")
    }
    elseif ($main_choice -eq '4') {
        $filesToDownload += ,@($AME_URL, "AME-Beta-v0.8.4.exe")
    }

   
    Clear-Host
    foreach ($file in $filesToDownload) {
        Download-File -Url $file[0] -Name $file[1]
    }

    Write-Host "`n===================================================" -ForegroundColor Green
    Write-Host "                DOWNLOAD COMPLETED!" -ForegroundColor Green
    Write-Host "  Files saved to: $ScriptDir"
    Write-Host "===================================================" -ForegroundColor Green
    explorer $ScriptDir
}
else {
    Write-Host "Invalid Selection!" -ForegroundColor Red
    Start-Sleep -Seconds 2
}
