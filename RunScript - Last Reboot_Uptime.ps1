# Script Name: Last Reboot/Uptime

Try {
    Get-WmiObject -Class Win32_PerfFormattedData_PerfOS_System | 
        Select-Object @{Name = "ComputerName"; Expression = {$_.__SERVER}},
        @{Name = "LastReboot"; Expression = {(Get-Date) - (New-TimeSpan -Seconds $_.SystemUpTime)}},
        @{Name = "SystemUpTime"; Expression = {New-TimeSpan -Seconds $_.SystemUpTime}}
    Write-Output
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}