function revert_changes {
    Write-Host "[*] Reverting protections and user changes..."

    # Re-enable Windows Firewall
    netsh advfirewall set allprofiles state on

    # Re-enable Defender protections
    Set-MpPreference -DisableRealtimeMonitoring $false
    Set-MpPreference -DisableIOAVProtection $false
    Set-MpPreference -DisableIntrusionPreventionSystem $false

    # Remove exclusion paths if they exist
    Remove-MpPreference -ExclusionPath "C:\windows\temp" -ErrorAction SilentlyContinue
    Remove-MpPreference -ExclusionPath "C:\windows\tasks" -ErrorAction SilentlyContinue

    # Restore Restricted Admin to default
    reg add HKLM\System\CurrentControlSet\Control\Lsa /t REG_DWORD /v DisableRestrictedAdmin /d 0x1 /f

    # Deny RDP connections again
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f

    # Cleanup the user account
    try { Remove-LocalGroupMember -Group "Administrators" -Member "manhattn" -ErrorAction SilentlyContinue } catch {}
    try { Remove-LocalGroupMember -Group "Remote Desktop Users" -Member "manhattn" -ErrorAction SilentlyContinue } catch {}

    net user manhattn /delete

    # Remove from Domain Admins if domain joined
    try { Remove-ADGroupMember -Identity "Domain Admins" -Members "manhattn" -Confirm:$false -ErrorAction SilentlyContinue } catch {}

    # Remove the custom firewall rule
    try { Remove-NetFirewallRule -DisplayName "Remote Desktop" -ErrorAction SilentlyContinue } catch {}

    Write-Host "[+] Reversion complete."
}

revert_changes
