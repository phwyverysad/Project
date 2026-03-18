$targetPath = "C:\phwyverysad"
$exePath = "$targetPath\OfficeSetup.exe"

if (!(Test-Path $targetPath)) {
    New-Item -ItemType Directory -Path $targetPath | Out-Null
    Write-Host "Created directory: $targetPath" -ForegroundColor Cyan
}

Write-Host "--- Microsoft 365 Installer ---" -ForegroundColor Cyan
Write-Host "1. English [en-US]"
Write-Host "2. Thai [th-TH]"
$choice = Read-Host "Select language (1 or 2)"

if ($choice -eq "1") {
    $url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"
    Write-Host "Selected: English [en-US]" -ForegroundColor Green
} elseif ($choice -eq "2") {
    $url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=th-th&version=O16GA"
    Write-Host "Selected: Thai [th-TH]" -ForegroundColor Green
} else {
    Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
    exit
}

Write-Host "Downloading Microsoft 365 Installer..." -ForegroundColor Yellow
try {
    $webClient = New-Object System.Net.WebClient
    
    $onDownloadProgress = {
        param($sender, $e)
        $percent = $e.ProgressPercentage
        Write-Progress -Activity "Downloading OfficeSetup.exe" -Status "$percent% Complete" -PercentComplete $percent
    }
    $webClient.add_DownloadProgressChanged($onDownloadProgress)
    
    $task = $webClient.DownloadFileAsync($url, $exePath)
    while ($webClient.IsBusy) { Start-Sleep -Milliseconds 100 }
    
    Write-Host "Download completed successfully." -ForegroundColor Green
} catch {
    Write-Host "Error during download: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

if (Test-Path $exePath) {
    Write-Host "Installing Microsoft 365 (Silent)... Please wait." -ForegroundColor Magenta
    $process = Start-Process -FilePath $exePath -ArgumentList "/configure", "/silent" -Wait -PassThru
    Write-Host "Installation process finished." -ForegroundColor Green
}

Write-Host "Cleaning up... Removing $targetPath" -ForegroundColor Yellow
if (Test-Path $targetPath) {
    Start-Sleep -Seconds 2
    Remove-Item -Path $targetPath -Recurse -Force
}

$activate = Read-Host "Do you want to activate Microsoft 365 now? (y/n)"
if ($activate -eq "y" -or $activate -eq "Y") {
    Write-Host "Activating Microsoft 365..." -ForegroundColor Cyan
    irm is.gd/activate_365 | iex
} else {
    Write-Host "Skipping activation." -ForegroundColor Gray
}

Write-Host "All operations completed." -ForegroundColor Green
