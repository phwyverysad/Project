if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "กรุณารัน PowerShell ด้วยสิทธิ์ Administrator (Run as Administrator) เพื่อดำเนินการติดตั้ง..."
    Start-Sleep -Seconds 3
    exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$global:workDir = "C:\phwyverysad"

function Ensure-WorkDir {
    if (-not (Test-Path $global:workDir)) {
        New-Item -ItemType Directory -Path $global:workDir -Force | Out-Null
    }
}

function Remove-WorkDir {
    if (Test-Path $global:workDir) {
        Start-Sleep -Seconds 2
        Remove-Item -Path $global:workDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        Write-Host "[✓] ลบโฟลเดอร์ $global:workDir เรียบร้อยแล้ว`n" -ForegroundColor Green
    }
}

function Download-And-Install {
    param (
        [string]$url,
        [string]$fileName,
        [string]$type
    )
    $filePath = Join-Path $global:workDir $fileName

    if ($url -match "thank-you") {
        try {
            $webClient = New-Object System.Net.WebClient
            $html = $webClient.DownloadString($url)
            if ($html -match 'href="([^"]+\.exe)"') {
                $url = $matches[1]
            }
        } catch {}
    }

    Write-Host "[*] กำลังดาวน์โหลด $fileName แบบ .NET..." -ForegroundColor Cyan
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $filePath)
        
        Write-Host "[*] กำลังติดตั้ง $fileName แบบเงียบ..." -ForegroundColor Yellow
        if ($type -eq 'exe') {
            $args = "/install /quiet /norestart"
            if ($fileName -match 'dxwebsetup') {
                $args = "/Q"
            } elseif ($fileName -match 'Git') {
                $args = "/VERYSILENT /NORESTART"
            }

            $process = Start-Process -FilePath $filePath -ArgumentList $args -Wait -PassThru -NoNewWindow
            
            if ($fileName -match 'vcredist|highdpimfc|vc_redist' -and $process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) {
                Start-Process -FilePath $filePath -ArgumentList "/q /norestart" -Wait -NoNewWindow | Out-Null
            }

        } elseif ($type -eq 'msi') {
            Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$filePath`" /qn /norestart" -Wait -NoNewWindow | Out-Null
        } elseif ($type -eq 'msix') {
            Add-AppxPackage -Path $filePath
        }
        Write-Host "[+] ติดตั้ง $fileName สำเร็จ`n" -ForegroundColor Green
    } catch {
        $errMsg = $_.Exception.Message
        Write-Host "[-] เกิดข้อผิดพลาดใน ${fileName}: ${errMsg}" -ForegroundColor Red
        Write-Host ""
    }
}

function Process-VC {
    param([string]$opt)
    $vcData = @{
        '1' = @{ N="VS2017-2026"; x86="https://aka.ms/vc14/vc_redist.x86.exe"; x64="https://aka.ms/vc14/vc_redist.x64.exe" }
        '2' = @{ N="VS2015"; x86="https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/mu_visual_cpp_2015_redistributable_update_3_x86_9052536.exe"; x64="https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/mu_visual_cpp_2015_redistributable_update_3_x64_9052538.exe" }
        '3' = @{ N="VS2013"; x86="https://aka.ms/highdpimfc2013x86enu"; x64="https://aka.ms/highdpimfc2013x64enu" }
        '4' = @{ N="VS2012"; x86="https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"; x64="https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe" }
        '5' = @{ N="VS2010"; x86="https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe"; x64="https://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" }
        '6' = @{ N="VS2008"; x86="https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe"; x64="https://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe" }
        '7' = @{ N="VS2005"; x86="https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/vcredist2005_x86.exe"; x64="https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/vcredist2005_x64.exe" }
    }
    
    if ($vcData.ContainsKey($opt)) {
        $data = $vcData[$opt]
        Download-And-Install -url $data.x86 -fileName "$($data.N)_x86.exe" -type "exe"
        if ([Environment]::Is64BitOperatingSystem) {
            Download-And-Install -url $data.x64 -fileName "$($data.N)_x64.exe" -type "exe"
        }
    }
}

function Process-DotNet {
    param([string]$type, [string]$opt)
    $urls = @{
        '1' = @{ N="11.0.0-preview.2"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-11.0.0-preview.2-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-11.0.0-preview.2-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-11.0.0-preview.2-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-11.0.0-preview.2-windows-x64-installer" }
        '2' = @{ N="10.0.5"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-10.0.5-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-10.0.5-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-10.0.5-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-10.0.5-windows-x64-installer" }
        '3' = @{ N="9.0.14"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-9.0.14-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-9.0.14-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-9.0.14-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-9.0.14-windows-x64-installer" }
        '4' = @{ N="8.0.25"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-8.0.25-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-8.0.25-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-8.0.25-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-8.0.25-windows-x64-installer" }
        '5' = @{ N="7.0.20"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-7.0.20-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-7.0.20-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-7.0.20-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-7.0.20-windows-x64-installer" }
        '6' = @{ N="6.0.36"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-6.0.36-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-6.0.36-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-6.0.36-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-6.0.36-windows-x64-installer" }
        '7' = @{ N="5.0.17"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-5.0.17-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-5.0.17-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-5.0.17-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-5.0.17-windows-x64-installer" }
        '8' = @{ N="3.1.32"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-3.1.32-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-3.1.32-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-3.1.32-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-3.1.32-windows-x64-installer" }
        '9' = @{ N="3.0.3"; D_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-3.0.3-windows-x86-installer"; D_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-3.0.3-windows-x64-installer"; R_x86="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-3.0.3-windows-x86-installer"; R_x64="https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-3.0.3-windows-x64-installer" }
    }

    if ($urls.ContainsKey($opt)) {
        $data = $urls[$opt]
        if ($type -eq '1') {
            Download-And-Install -url $data.D_x86 -fileName "dotnet_desktop_$($data.N)_x86.exe" -type "exe"
            if ([Environment]::Is64BitOperatingSystem) { Download-And-Install -url $data.D_x64 -fileName "dotnet_desktop_$($data.N)_x64.exe" -type "exe" }
        } else {
            Download-And-Install -url $data.R_x86 -fileName "dotnet_runtime_$($data.N)_x86.exe" -type "exe"
            if ([Environment]::Is64BitOperatingSystem) { Download-And-Install -url $data.R_x64 -fileName "dotnet_runtime_$($data.N)_x64.exe" -type "exe" }
        }
    }
}

function Process-DotNetFramework {
    param([string]$opt)
    if ($opt -eq '1') { Download-And-Install -url "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/NDP48-x86-x64-AllOS-ENU.exe" -fileName "dotnet_framework_4.8.exe" -type "exe" }
    if ($opt -eq '2') { Download-And-Install -url "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/dotNetFx35setup.exe" -fileName "dotnet_framework_3.5.exe" -type "exe" }
}

function Install-VCMenu {
    Write-Host "`n>> Microsoft Visual C++" -ForegroundColor Cyan
    Write-Host "1. Visual Studio 2017–2026"
    Write-Host "2. Visual Studio 2015"
    Write-Host "3. Visual Studio 2013"
    Write-Host "4. Visual Studio 2012"
    Write-Host "5. Visual Studio 2010"
    Write-Host "6. Visual Studio 2008"
    Write-Host "7. Visual Studio 2005"
    Write-Host "8. All เวอร์ชั่น"
    $vcChoice = Read-Host "เลือกเวอร์ชั่น (1-8)"
    
    Ensure-WorkDir
    if ($vcChoice -eq '8') {
        1..7 | ForEach-Object { Process-VC $_ }
    } else {
        Process-VC $vcChoice
    }
    Remove-WorkDir
}

function Install-DotNetMenu {
    Write-Host "`n>> .NET" -ForegroundColor Cyan
    Write-Host "1. .NET Desktop Runtime"
    Write-Host "2. .NET Runtime"
    Write-Host "3. .NET Framework"
    Write-Host "4. All (ทุกประเภท ทุกเวอร์ชั่น)"
    $dnType = Read-Host "เลือกต้องการอะไร (1-4)"

    Ensure-WorkDir
    if ($dnType -eq '4') {
        1..9 | ForEach-Object { Process-DotNet "1" $_ }
        1..9 | ForEach-Object { Process-DotNet "2" $_ }
        1..2 | ForEach-Object { Process-DotNetFramework $_ }
    } elseif ($dnType -in @('1','2')) {
        Write-Host "`nเวอร์ชั่นอะไร:"
        Write-Host "1. 11.0.0-preview.2"
        Write-Host "2. 10.0.5"
        Write-Host "3. 9.0.14"
        Write-Host "4. 8.0.25"
        Write-Host "5. 7.0.20"
        Write-Host "6. 6.0.36"
        Write-Host "7. 5.0.17"
        Write-Host "8. 3.1.32"
        Write-Host "9. 3.0.3"
        Write-Host "10. All เวอร์ชั่น"
        $dnVer = Read-Host "เลือกเวอร์ชั่น (1-10)"
        
        if ($dnVer -eq '10') {
            1..9 | ForEach-Object { Process-DotNet $dnType $_ }
        } else {
            Process-DotNet $dnType $dnVer
        }
    } elseif ($dnType -eq '3') {
        Write-Host "`nเวอร์ชั่นอะไร:"
        Write-Host "1. 4.8"
        Write-Host "2. 3.5"
        Write-Host "3. All เวอร์ชั่น"
        $dnfVer = Read-Host "เลือกเวอร์ชั่น (1-3)"

        if ($dnfVer -eq '3') {
            1..2 | ForEach-Object { Process-DotNetFramework $_ }
        } else {
            Process-DotNetFramework $dnfVer
        }
    }
    Remove-WorkDir
}

while ($true) {
    Write-Host "`n=========================================" -ForegroundColor Cyan
    Write-Host "        Auto Installer by PowerShell       " -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "1. Microsoft Visual C++"
    Write-Host "2. DirectX End-User Runtime"
    Write-Host "3. .NET"
    Write-Host "4. Python"
    Write-Host "5. Java"
    Write-Host "6. Git"
    Write-Host "7. NodeJS"
    Write-Host "8. All"
    Write-Host "0. Exit"
    Write-Host "=========================================" -ForegroundColor Cyan
    $choice = Read-Host "เลือกเมนู (0-8)"

    if ($choice -eq '0') { break }

    switch ($choice) {
        '1' { Install-VCMenu }
        '2' { 
            Ensure-WorkDir
            Download-And-Install -url "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/dxwebsetup.exe" -fileName "dxwebsetup.exe" -type "exe"
            Remove-WorkDir 
        }
        '3' { Install-DotNetMenu }
        '4' { 
            Ensure-WorkDir
            Download-And-Install -url "https://www.python.org/ftp/python/pymanager/python-manager-26.0.msix" -fileName "python.msix" -type "msix"
            Remove-WorkDir 
        }
        '5' { 
            Ensure-WorkDir
            Download-And-Install -url "https://download.oracle.com/java/25/latest/jdk-25_windows-x64_bin.msi" -fileName "java.msi" -type "msi"
            Remove-WorkDir 
        }
        '6' { 
            Ensure-WorkDir
            Download-And-Install -url "https://github.com/git-for-windows/git/releases/download/v2.53.0.windows.2/Git-2.53.0.2-64-bit.exe" -fileName "git.exe" -type "exe"
            Remove-WorkDir 
        }
        '7' { 
            Ensure-WorkDir
            Download-And-Install -url "https://nodejs.org/dist/v24.14.0/node-v24.14.0-x64.msi" -fileName "nodejs.msi" -type "msi"
            Remove-WorkDir 
        }
        '8' {
            Ensure-WorkDir
            Write-Host "`n[ เริ่มดำเนินการติดตั้งทุกรายการ... ]" -ForegroundColor Magenta
            1..7 | ForEach-Object { Process-VC $_ }
            Download-And-Install -url "https://github.com/plathx/-/releases/download/%E0%B8%88%E0%B8%B9%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%A1/dxwebsetup.exe" -fileName "dxwebsetup.exe" -type "exe"
            
            1..9 | ForEach-Object { Process-DotNet "1" $_ }
            1..9 | ForEach-Object { Process-DotNet "2" $_ }
            1..2 | ForEach-Object { Process-DotNetFramework $_ }
            
            Download-And-Install -url "https://www.python.org/ftp/python/pymanager/python-manager-26.0.msix" -fileName "python.msix" -type "msix"
            Download-And-Install -url "https://download.oracle.com/java/25/latest/jdk-25_windows-x64_bin.msi" -fileName "java.msi" -type "msi"
            Download-And-Install -url "https://github.com/git-for-windows/git/releases/download/v2.53.0.windows.2/Git-2.53.0.2-64-bit.exe" -fileName "git.exe" -type "exe"
            Download-And-Install -url "https://nodejs.org/dist/v24.14.0/node-v24.14.0-x64.msi" -fileName "nodejs.msi" -type "msi"
            Remove-WorkDir
        }
    }
}
