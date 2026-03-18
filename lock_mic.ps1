if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
    exit
}

New-Item -Path "C:\phwyverysad" -ItemType Directory -Force | Out-Null

Write-Host "`n=== Lock Mic Volume Tool ===" -ForegroundColor Cyan
Write-Host "1. Install"
Write-Host "2. Uninstall"
$mainChoice = Read-Host "Enter your choice (1 or 2)"

switch ($mainChoice) {
    "1" {
        $zipPath = "C:\phwyverysad\lock_mic_volume.zip"
       
        Invoke-WebRequest -Uri "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/lock_mic_volume.zip" -OutFile $zipPath -UseBasicParsing
       
        Set-Location "C:\phwyverysad"
        Expand-Archive -Path $zipPath -DestinationPath "." -Force
        
        $innerFolder = "C:\phwyverysad\lock_mic_volume"
        if (Test-Path $innerFolder) {
            Write-Host "Moving percentage folders to C:\phwyverysad ..." -ForegroundColor Green
            Get-ChildItem -Path $innerFolder -Directory | Move-Item -Destination "C:\phwyverysad" -Force
            Remove-Item -Path $innerFolder -Recurse -Force
        }
        
        Remove-Item -Path $zipPath -Force
        
        Write-Host "`nSelect lock volume percentage:" -ForegroundColor Cyan
        Write-Host "1. 100%"
        Write-Host "2. 75%"
        Write-Host "3. 50%"
        Write-Host "4. 25%"
        $percentChoice = Read-Host "Enter your choice (1-4)"
        
        $folderName = switch ($percentChoice) {
            "1" { "100%" }
            "2" { "75%" }
            "3" { "50%" }
            "4" { "25%" }
            default { Write-Host "Invalid choice! Exiting." -ForegroundColor Red; exit }
        }
        
        $targetFolder = "C:\phwyverysad\$folderName"
        if (-not (Test-Path $targetFolder)) {
            Write-Host "Folder '$folderName' not found! Exiting." -ForegroundColor Red
            exit
        }
        
        Set-Location $targetFolder
        $process = Start-Process -FilePath ".\Run_atomatically.bat" -PassThru
        
        Start-Sleep -Seconds 0
        
        if (-not $process.HasExited) {
            Stop-Process -InputObject $process -Force -ErrorAction SilentlyContinue
        }
        
        Set-Location "C:\"
        $deleted = $false
        for ($i = 1; $i -le 5; $i++) {
            try {
                Remove-Item -Path "C:\phwyverysad" -Recurse -Force -ErrorAction Stop
                $deleted = $true
                break
            } catch {
                Start-Sleep -Seconds 0
            }
        }
       
        Write-Host "`nInstallation completed successfully!" -ForegroundColor Green

    }
   
    "2" {
        Write-Host "`nKilling nircmdc.exe ..." -ForegroundColor Yellow
        taskkill /IM nircmdc.exe /F 2>$null
       
        $filesToDelete = @(
            "C:\Windows\lock_mic_vol.bat",
            "C:\Windows\hide_cmd_window2.vbs",
            "C:\Windows\nircmdc.exe",
            "$([Environment]::GetFolderPath('Startup'))\start_lock_mic_vol.bat"
        )
       
        foreach ($file in $filesToDelete) {
            if (Test-Path $file) {
                Write-Host "Force deleting: $file" -ForegroundColor Green
                Remove-Item -Path $file -Force -ErrorAction SilentlyContinue
            }
        }
       
        Write-Host "`nUninstallation completed successfully!" -ForegroundColor Green
    }
    default {
        Write-Host "Invalid choice! Exiting." -ForegroundColor Red
    }
}

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


