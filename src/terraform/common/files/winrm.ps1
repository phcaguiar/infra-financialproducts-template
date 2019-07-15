Write-Host "Open WinRM Firewall Port"
netsh advfirewall firewall add rule name="Windows Remote Management (HTTP-In)" dir=in action=allow protocol=TCP localport=5985
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow

Write-Host "Enable PSRemoting"
Enable-PSRemoting -Force

Write-Host "Enabling Basic Authentication.."
winrm set winrm/config/service/Auth "@{Basic=`"true`"}"

Write-Host "Re-starting the WinRM Service"
net stop winrm
net start winrm