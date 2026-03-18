if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs;Exit}; $s="C:\scripts"; $f="$s\share_file.ps1"; if(!(Test-Path $s)){New-Item $s -Type Directory | Out-Null}; $c=@'
param($p)
if(!$p -or !(Test-Path $p)){exit}
try{
Write-Host "Connecting to Gofile..."; $v=Invoke-RestMethod "https://api.gofile.io/servers"
if($v.status -ne "ok"){throw "Server Error"}; $srv=$v.data.servers[0].name
Write-Host "Uploading: $(Split-Path $p -Leaf)..."; $t=[IO.Path]::GetTempFileName()
curl.exe -# -F "file=@$p" "https://$srv.gofile.io/contents/uploadfile" -o $t
$r=Get-Content $t -Raw | ConvertFrom-Json; Remove-Item $t
if($r.status -eq "ok"){$l=$r.data.downloadPage; Set-Clipboard $l; Write-Host "Done! Link: $l"; Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.MessageBox]::Show("Link: $l","Success")}else{Write-Host "Failed: $($r.status)"; pause}
}catch{Write-Host "Error: $_"; pause}
'@; Set-Content $f $c -Encoding UTF8; $r="HKCR\*\shell\CreateLink"; if(!(Test-Path "Registry::$r")){New-Item "Registry::$r" -Force | Out-Null}; Set-ItemProperty "Registry::$r" "(Default)" "Get Gofile Link"; Set-ItemProperty "Registry::$r" "Icon" "imageres.dll,-1024"; if(!(Test-Path "Registry::$r\command")){New-Item "Registry::$r\command" -Force | Out-Null}; Set-ItemProperty "Registry::$r\command" "(Default)" "powershell.exe -ExecutionPolicy Bypass -File `"$f`" `"%1`""; Write-Host "Setup Completed. Right-click any file to use."
