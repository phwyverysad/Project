function Show-MainMenu {
    clear
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "      is.gd Link Shortener (PowerShell) " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $url = Read-Host "กรุณาวางลิงก์ที่ต้องการย่อ"
    if ([string]::IsNullOrWhiteSpace($url)) {
        Write-Host "ข้อผิดพลาด: ลิงก์ห้ามว่าง!" -ForegroundColor Red
        Pause
        return
    }

    Write-Host "`nเลือกรูปแบบชื่อลิงก์:" -ForegroundColor Yellow
    Write-Host "1. สุ่มชื่อ (Random)"
    Write-Host "2. ตั้งชื่อเอง (Custom)"
    $choice = Read-Host "เลือก (1 หรือ 2)"

    if ($choice -eq "1") {
        Shorten-Link -longUrl $url
    }
    elseif ($choice -eq "2") {
        $customName = ""
        $success = $false
        
        while (-not $success) {
            $customName = Read-Host "ตั้งชื่อที่ต้องการ (Short Name)"
            if ([string]::IsNullOrWhiteSpace($customName)) {
                Write-Host "กรุณากรอกชื่อ!" -ForegroundColor Red
                continue
            }
            
            $result = Shorten-Link -longUrl $url -shortName $customName
            if ($result) { $success = $true }
        }
    }
    else {
        Write-Host "ตัวเลือกไม่ถูกต้อง กลับสู่หน้าแรก..." -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
}

function Shorten-Link {
    param (
        [string]$longUrl,
        [string]$shortName = ""
    )

    $apiBase = "https://is.gd/create.php?format=json&url=$([uri]::EscapeDataString($longUrl))"
    
    if ($shortName -ne "") {
        $apiBase += "&shorturl=$([uri]::EscapeDataString($shortName))"
    }

    try {
        $response = Invoke-RestMethod -Uri $apiBase -Method Get
        
        if ($null -ne $response.shorturl) {
            $shortLink = $response.shorturl
            Write-Host "`n----------------------------------------" -ForegroundColor Green
            Write-Host "สำเร็จ! ลิงก์ของคุณคือ: $shortLink" -ForegroundColor Green
            
            $shortLink | Set-Clipboard
            Write-Host "(คัดลอกลิงก์ไปยัง Clipboard เรียบร้อยแล้ว)" -ForegroundColor Gray
            Write-Host "----------------------------------------" -ForegroundColor Green
            
            Write-Host "`nกดปุ่มอะไรก็ได้เพื่อกลับไปหน้าแรก..."
            $null = [System.Console]::ReadKey($true)
            return $true
        }
        else {
            if ($response.errormessage -like "*Short URL already in use*") {
                Write-Host "ข้อผิดพลาด: ชื่อ '$shortName' ถูกใช้ไปแล้ว กรุณาตั้งชื่อใหม่" -ForegroundColor Yellow
                return $false
            } else {
                Write-Host "เกิดข้อผิดพลาด: $($response.errormessage)" -ForegroundColor Red
                Pause
                return $true
        }
    }
    catch {
        Write-Host "ไม่สามารถเชื่อมต่อกับ API ได้: $($_.Exception.Message)" -ForegroundColor Red
        Pause
        return $true
    }
}

while ($true) {
    Show-MainMenu
}
