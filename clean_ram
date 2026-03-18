# Script to manage Memory Cleaning using EmptyStandbyList.exe
# Run this script as Administrator

function Show-Menu {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "   Memory Cleaner Utility Tool (Admin)" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "1. สร้างทางลัด (Create Shortcut)"
    Write-Host "2. ตั้งเวลาเคลียร์อัตโนมัติ (Schedule Auto Clean)"
    Write-Host "3. ยกเลิกการตั้งเวลาอัตโนมัติ (Remove Schedule)"
    Write-Host "4. ออก (Exit)"
    Write-Host "==========================================" -ForegroundColor Cyan
}

function Download-EmptyStandbyList {
    $url = "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/EmptyStandbyList.exe"
    $dest = "C:\Windows\System32\EmptyStandbyList.exe"
    
    if (-not (Test-Path $dest)) {
        Write-Host "กำลังดาวน์โหลด EmptyStandbyList.exe..." -ForegroundColor Yellow
        try {
            # Use .NET WebClient for download as requested
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($url, $dest)
            Write-Host "ดาวน์โหลดเสร็จสมบูรณ์ที่: $dest" -ForegroundColor Green
        }
        catch {
            Write-Error "ดาวน์โหลดล้มเหลว: $($_.Exception.Message)"
            return $false
        }
    } else {
        Write-Host "ตรวจพบไฟล์ EmptyStandbyList.exe อยู่ในระบบแล้ว" -ForegroundColor Gray
    }
    return $true
}

function Remove-TempFile {
    $tempPath = "C:\phwyverysad"
    if (Test-Path $tempPath) {
        Write-Host "กำลังลบไฟล์ชั่วคราว: $tempPath" -ForegroundColor DarkGray
        Remove-Item -Path $tempPath -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Check Admin Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "กรุณารัน PowerShell ในฐานะ Administrator เพื่อการทำงานที่สมบูรณ์"
    pause
    exit
}

do {
    Show-Menu
    $choice = Read-Host "กรุณาเลือกตัวเลือก (1-4)"

    switch ($choice) {
        "1" {
            if (Download-EmptyStandbyList) {
                $Shell = New-Object -ComObject WScript.Shell
$TargetFile = "C:\Windows\System32\cmd.exe"
$Arguments = '/c EmptyStandbyList.exe workingsets && EmptyStandbyList.exe standbylist && EmptyStandbyList.exe modifiedpagelist'
$ShortcutName = "Clear Memory.lnk"
$DesktopPaths = @(
    [System.IO.Path]::Combine($env:USERPROFILE, "Desktop", $ShortcutName),
    [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive", "Desktop", $ShortcutName)
)
foreach ($Path in $DesktopPaths) {
    try {
        # Check if directory exists before creating shortcut
        $Dir = Split-Path $Path
        if (Test-Path $Dir) {
            $Shortcut = $Shell.CreateShortcut($Path)
            $Shortcut.TargetPath = $TargetFile
            $Shortcut.Arguments = $Arguments
            $Shortcut.WorkingDirectory = "C:\Windows\System32" # Assuming the exe is here or in PATH
            $Shortcut.IconLocation = "C:\Windows\System32\cmd.exe"
            $Shortcut.Description = "Clear Standby List and Working Sets"
            $Shortcut.Save()
            $bytes = [System.IO.File]::ReadAllBytes($Path)
            $bytes[21] = $bytes[21] -bor 0x20
            [System.IO.File]::WriteAllBytes($Path, $bytes)
            Write-Host "Successfully created shortcut at: $Path" -ForegroundColor Green
        } else {
            Write-Warning "Directory not found, skipping: $Dir"
        }
    }
    catch {
        Write-Error "Failed to create shortcut at $Path : $($_.Exception.Message)"
    }
}

Write-Host "`nScript execution finished." -ForegroundColor Cyan
                pause
            }
        }

        "2" {
            $minutes = Read-Host "ระบุจำนวนเวลาที่ต้องการเคลียร์ (หน่วยนาที)"
            if ($minutes -as [int]) {
                if (Download-EmptyStandbyList) {
                    Write-Host "กำลังตั้งเวลาทำงานทุกๆ $minutes นาที..." -ForegroundColor Yellow
                    $taskCmd = "cmd.exe /c EmptyStandbyList.exe workingsets && EmptyStandbyList.exe standbylist && EmptyStandbyList.exe modifiedpagelist"
                    
                    # Create Scheduled Task
                    schtasks /create /tn "AutoCleanRAM" /sc MINUTE /mo $minutes /rl HIGHEST /ru SYSTEM /tr $taskCmd /f
                    
                    Write-Host "ตั้งเวลาสำเร็จ! ระบบจะเคลียร์ RAM ทุก $minutes นาทีในเบื้องหลัง" -ForegroundColor Green
                    Remove-TempFile
                    pause
                }
            } else {
                Write-Host "รูปแบบเวลาไม่ถูกต้อง กรุณาใส่เฉพาะตัวเลข" -ForegroundColor Red
                pause
            }
        }

        "3" {
            Write-Host "กำลังยกเลิกการตั้งเวลาอัตโนมัติ..." -ForegroundColor Yellow
            schtasks /delete /tn "AutoCleanRAM" /f 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "ยกเลิกการตั้งเวลาสำเร็จ" -ForegroundColor Green
            } else {
                Write-Host "ไม่พบการตั้งเวลา AutoCleanRAM ในระบบ" -ForegroundColor Gray
            }
            pause
        }

        "4" {
            exit
        }
    }
} while ($choice -ne "4")
