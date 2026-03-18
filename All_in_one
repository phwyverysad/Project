[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# รายการเมนูทั้งหมด
$menuItems = @{
    1  = @{ Name = "ล็อกไมค์ (Lock Mic)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/lock_mic | iex" }
    2  = @{ Name = "เสกเกมสตรีม (Steam)"; Cmd = "irm https://raw.githubusercontent.com/plathx/-/refs/heads/main/add_games_steam | iex" }
    3  = @{ Name = "ติดตั้ง PowerPlan (KernelOS)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/Install_powerplan | iex" }
    4  = @{ Name = "ติดตั้ง Spotify Premium"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/spotify_premium | iex" }
    5  = @{ Name = "โหลด OS ทับ (Atlas/ReviOS)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/playbook_downloader | iex" }
    6  = @{ Name = "แปลงไฟล์ .py เป็น .exe"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/py_to_exe | iex" }
    7  = @{ Name = "ติดตั้ง Minecraft for Windows"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/minecraft_for_windows | iex" }
    8  = @{ Name = "ติดตั้ง Discord 3 ตัว"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/rwm_discord | iex" }
    9  = @{ Name = "Clean Ram (คล้าย RamMap)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/clean_ram | iex" }
    10 = @{ Name = "ปรับแต่ง Windows (WinUtil)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/winutil | iex" }
    11 = @{ Name = "สร้างลิ้งก์ดาวน์โหลดไฟล์"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/setup_share | iex" }
    12 = @{ Name = "สร้างจุดย้อนระบบ (Restore)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/system_restore | iex" }
    13 = @{ Name = "เมนูทางลัด Power/BIOS"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/menu_options | iex" }
    14 = @{ Name = "ติดตั้ง Lossless Scaling"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/lossless_scaling | iex" }
    15 = @{ Name = "ถอนการติดตั้ง (Revo Unin)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/revo_uninstaller_pro | iex" }
    16 = @{ Name = "จัดการไดรเวอร์ (Driver Easy)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/driver_easy_pro | iex" }
    17 = @{ Name = "ติดตั้งส่วนเสริม Windows"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/dev_tools | iex" }
    18 = @{ Name = "ย่อลิ้งก์ให้สั้น (Short Link)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/cut_link | iex" }
    19 = @{ Name = "ติดตั้ง IDM (โหลดไว)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/idm_build | iex" }
    20 = @{ Name = "เปิดใช้งาน Microsoft 365"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/activate_365 | iex" }
    21 = @{ Name = "เปิดใช้งาน Windows (แท้)"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/activate_windowsall | iex" }
    22 = @{ Name = "เปลี่ยนรุ่น Windows"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/change_windows_edition | iex" }
    23 = @{ Name = "เช็คสถานะ Activate"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/check_status_windows | iex" }
    24 = @{ Name = "ติดตั้ง Avast Premium"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/avast_premium_security | iex" }
    25 = @{ Name = "ติดตั้ง Malwarebytes Pre"; Cmd = "irm http://raw.githubusercontent.com/plathx/-/refs/heads/main/malwarebytes_premium | iex" }
}

function Show-Menu {
    Clear-Host
    Write-Host "  __________________________________________________________________________________________________________________" -ForegroundColor DarkGray
    Write-Host " /                                                                                                                  \" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "    █████╗ ██╗     ██╗      ██╗███╗   ██╗     ██████╗ ███╗   ██╗███████╗                                   " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "   ██╔══██╗██║     ██║      ██║████╗  ██║    ██╔═══██╗████╗  ██║██╔════╝                                   " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "   ███████║██║     ██║      ██║██╔██╗ ██║    ██║   ██║██╔██╗ ██║█████╗                                     " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "   ██╔══██║██║     ██║      ██║██║╚██╗██║    ██║   ██║██║╚██╗██║██╔══╝                                     " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "   ██║  ██║███████╗███████╗ ██║██║ ╚████║    ╚██████╔╝██║ ╚████║███████╗                                   " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " |" -NoNewline -ForegroundColor DarkGray; Write-Host "   ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═╝╚═╝  ╚═══╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝                                   " -ForegroundColor Cyan -NoNewline; Write-Host " |" -ForegroundColor DarkGray
    Write-Host " \__________________________________________________________________________________________________________________/" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "   [ VERSION 2.0 ] - POWERED BY PLATHX" -ForegroundColor DarkYellow
    Write-Host "   ------------------------------------------------------------------------------------------------------------------" -ForegroundColor DarkGray

    for ($i = 1; $i -le 9; $i++) {
        $cols = @()
        for ($j = 0; $j -lt 3; $j++) {
            $index = $i + ($j * 9)
            if ($menuItems.ContainsKey($index)) {
                $num = "[" + $index.ToString().PadLeft(2) + "]"
                $name = $menuItems[$index].Name
                $itemStr = "   " + "$num " + "$name"
                # คำนวณความยาวเพื่อจัดช่องไฟ (ลบสระไทยออกชั่วคราวเพื่อวัดความกว้าง)
                $cleanLen = ($itemStr -replace '\p{M}', '').Length
                $padding = " " * ([Math]::Max(0, 40 - $cleanLen))
                $cols += "$itemStr$padding"
            }
        }
        Write-Host ($cols -join "") -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "   ------------------------------------------------------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "   [0] EXIT PROGRAM" -ForegroundColor Red
}

while ($true) {
    Show-Menu
    Write-Host ""
    Write-Host "   [#] SELECT OPTION: " -NoNewline -ForegroundColor Yellow
    $choice = Read-Host
    
    if ($choice -eq '0') {
        Write-Host "`n   [!] TERMINATING SESSIONS..." -ForegroundColor Red
        Start-Sleep -Seconds 1
        Stop-Process -Name "WindowsTerminal" -Force -ErrorAction SilentlyContinue
        Stop-Process -Id $PID -Force
        exit
    }

    $selected = $choice -as [int]
    
    if ($selected -and $menuItems.ContainsKey($selected)) {
        $selectedItem = $menuItems[$selected]
        Write-Host "`n   [>] INITIALIZING: " -NoNewline -ForegroundColor Cyan
        Write-Host "$($selectedItem.Name)" -ForegroundColor Green
        Write-Host "   ------------------------------------------------------------------------------------------" -ForegroundColor DarkGray
        
        try {
            Invoke-Expression $selectedItem.Cmd
            Write-Host "`n   [+] OPERATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        } catch {
            Write-Host "`n   [-] ERROR DETECTED IN COMMAND EXECUTION" -ForegroundColor Red
        }

        Write-Host "`n   PRESS ANY KEY TO RETURN TO MAIN MENU..." -ForegroundColor DarkYellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } else {
        Write-Host "`n   [!] INVALID SELECTION - PLEASE TRY AGAIN" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
}
