$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "กรุณาเปิด PowerShell แบบ 'Run as Administrator' เพื่อให้อนุญาตการดาวน์โหลดไฟล์ลง C:\Windows"
    break
}

$nircmdPath = "C:\Windows\nircmdc.exe"
if (-not (Test-Path $nircmdPath)) {
    try {
        $url = "https://is.gd/6jdccu"
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $nircmdPath)
    } catch {
        Write-Error "ไม่สามารถดาวน์โหลดไฟล์ได้ โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต"
        break
    }
}

while ($true) {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "          System Control Menu            " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host " 1. ล็อกเครื่อง (Lock)"
    Write-Host " 2. ปิดหน้าจอ (Monitor Off)"
    Write-Host " 3. สลีป (Standby)"
    Write-Host " 4. ปิดเครื่อง (Power off)"
    Write-Host " 5. เริ่มระบบของคอมพิวเตอร์ใหม่ (Reboot)"
    Write-Host " 6. เข้าหน้า Advanced Options"
    Write-Host " 7. เข้าหน้า System Restore"
    Write-Host " 8. เข้าหน้า Bios"
    Write-Host " 9. เข้าหน้า Boot menu (เช็ครุ่น + ปุ่มกด + รีสตาร์ท)"
    Write-Host " 0. ออกจากโปรแกรม"
    Write-Host "=========================================" -ForegroundColor Cyan

    $choice = Read-Host "กรุณาเลือกหมายเลข (0-9)"

    switch ($choice) {
        '1' { Start-Process -FilePath $nircmdPath -ArgumentList "lockws" }
        '2' { Start-Process -FilePath $nircmdPath -ArgumentList "monitor off" }
        '3' { Start-Process -FilePath $nircmdPath -ArgumentList "standby" }
        '4' { Start-Process -FilePath $nircmdPath -ArgumentList "exitwin poweroff"; break }
        '5' { Start-Process -FilePath $nircmdPath -ArgumentList "exitwin reboot"; break }
        '6' { shutdown.exe /r /o /f /t 0; break }
        '7' { Start-Process "rstrui.exe" }
        '8' { shutdown.exe /r /fw /t 0; break }
        '9' {
            $sys = (Get-CimInstance Win32_ComputerSystem).Manufacturer
            if ($sys -match "System manufacturer|To be filled|O.E.M|Default") {
                $sys = (Get-CimInstance Win32_BaseBoard).Manufacturer
            }

            $brand = switch -Regex ($sys) {
                '(?i)micro-star' { 'MSI' }
                '(?i)asus'       { 'ASUS' }
                '(?i)gigabyte'   { 'Gigabyte' }
                '(?i)asrock'     { 'ASRock' }
                '(?i)acer'       { 'Acer' }
                '(?i)lenovo'     { 'Lenovo' }
                '(?i)hewlett|hp' { 'HP' }
                '(?i)dell'       { 'Dell' }
                '(?i)biostar'    { 'Biostar' }
                default          { $sys.Split(' ')[0] }
            }

            $bootKey = switch ($brand) {
                'MSI'      { 'F11' }
                'ASUS'     { 'F8' }
                'Gigabyte' { 'F12' }
                'ASRock'   { 'F11' }
                'Acer'     { 'F12' }
                'Lenovo'   { 'F12 (หรือปุ่ม Novo)' }
                'HP'       { 'F9' }
                'Dell'     { 'F12' }
                'Biostar'  { 'F9' }
                default    { 'F8, F9, F11 หรือ F12' }
            }

            Write-Host "`n-----------------------------------------" -ForegroundColor Green
            Write-Host " ยี่ห้อเมนบอร์ด/เครื่องคือ : $brand" -ForegroundColor Yellow
            Write-Host " ปุ่มเข้า Boot Menu คือ    : กดรัวๆที่ปุ่ม $bootKey" -ForegroundColor Magenta
            Write-Host "-----------------------------------------`n" -ForegroundColor Green
            
            $rebootConfirm = Read-Host "คุณต้องการเริ่มระบบของคอมพิวเตอร์ใหม่ตอนนี้หรือไม่? (y/n)"
            if ($rebootConfirm -match '^[yY]') {
                Start-Process -FilePath $nircmdPath -ArgumentList "exitwin reboot"
                break
            }
        }
        '0' { break }
        default { 
            Write-Host "กรุณาเลือกให้ถูกต้อง!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
