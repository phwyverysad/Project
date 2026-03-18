$steamDir = $null
try {
    $steamDir = (Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -ErrorAction Stop).InstallPath
} catch {
    $steamDir = "C:\Program Files (x86)\Steam" # ค่าเริ่มต้นถ้าหา Registry ไม่เจอ
}

$steamExe = Join-Path $steamDir "Steam.exe"
$steamToolsDll = Join-Path $steamDir "xinput1_4.dll"

$hasSteam = Test-Path $steamExe
$hasSteamTools = Test-Path $steamToolsDll

if ((-not $hasSteam) -and (-not $hasSteamTools)) {
    # กรณี: ไม่มีทั้งคู่
    Write-Host "ยังไม่มี steam และ steamtool กรุณาติดตั้ง steam และ steamtool และล็อกอินให้เรียบร้อย -ForegroundColor Red
    Write-Host "กำลังเปิดหน้าเว็บติดตั้ง Steam และ Steamtools ใน 3 วินาที..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    Start-Process "https://store.steampowered.com/about/"
    Start-Process "https://www.steamtools.net/download"

} elseif (-not $hasSteam) {
    # กรณี: ขาดแค่ Steam (กรณีนี้อาจเกิดขึ้นได้ยาก แต่ดักไว้ก่อน)
    Write-Host "ยังไม่มี steam กรุณาติดตั้ง steam และล็อกอินให้เรียบร้อย ก่อนรัน -ForegroundColor Red
    Write-Host "กำลังเปิดหน้าเว็บติดตั้ง Steam ใน 3 วินาที..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    Start-Process "https://store.steampowered.com/about/"

} elseif (-not $hasSteamTools) {
    # กรณี: มี Steam แล้ว แต่ขาด Steamtools
    Write-Host "ยังไม่มี steamtool กรุณาติดตั้ง steamtool ก่อนรัน -ForegroundColor Red
    Write-Host "กำลังเปิดหน้าเว็บติดตั้ง Steamtools ใน 3 วินาที..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
    Start-Process "https://www.steamtools.net/download"

} else {
    # กรณี: มีครบทั้ง 2 อย่าง
    Write-Host "พบ Steam และ Steamtools ครบถ้วน! กำลังรันสคริปต์หลัก..." -ForegroundColor Green
    irm "https://raw.githubusercontent.com/plathx/-/refs/heads/main/install-plugin.ps1" | iex
}
