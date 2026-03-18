# ==============================================================================
# Script: Automated Environment Setup for auto-py-to-exe
# Description: Checks and installs Git, Python, and auto-py-to-exe silently.
# ==============================================================================

$ErrorActionPreference = "Stop"

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warning-Custom { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }

Write-Info "กำลังตรวจสอบ Git..."
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Success "ตรวจพบ Git ในเครื่องแล้ว"
} else {
    Write-Warning-Custom "ไม่พบ Git กำลังดำเนินการติดตั้งแบบ Silent..."
    # ติดตั้ง Git ผ่าน Winget (--silent --accept-package-agreements --accept-source-agreements)
    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
    Write-Success "ติดตั้ง Git เรียบร้อยแล้ว (อาจต้องรีสตาร์ท PowerShell เพื่ออัปเดต Path)"
}

Write-Info "กำลังตรวจสอบ Python..."
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Success "ตรวจพบ Python ในเครื่องแล้ว"
} else {
    Write-Warning-Custom "ไม่พบ Python กำลังดำเนินการติดตั้งแบบ Silent..."
    winget install --id Python.Python.3 -e --source winget --silent --accept-package-agreements --accept-source-agreements
    Write-Success "ติดตั้ง Python เรียบร้อยแล้ว"
}

Write-Info "กำลังเตรียมการสำหรับ auto-py-to-exe..."

python -m pip install --upgrade pip --quiet

$checkPyToExe = python -m pip show auto-py-to-exe
if ($null -eq $checkPyToExe) {
    Write-Info "กำลังติดตั้ง auto-py-to-exe ผ่าน pip..."
    python -m pip install auto-py-to-exe
    Write-Success "ติดตั้ง auto-py-to-exe เรียบร้อย"
} else {
    Write-Success "ตรวจพบ auto-py-to-exe อยู่แล้ว ข้ามขั้นตอนการติดตั้ง"
}

Write-Info "กำลังเปิดโปรแกรม auto-py-to-exe..."
start-process python -ArgumentList "-m auto_py_to_exe"

Write-Success "เสร็จสิ้นขั้นตอนทั้งหมด"
pause
