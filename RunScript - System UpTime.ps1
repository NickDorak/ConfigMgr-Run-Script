# Script Name: System UpTime

Try {
    $OSLastBoot = Get-WmiObject Win32_OperatingSystem | select @{n='LastBootUpTime'; e={$_.ConverttoDateTime($_.LastBootUpTime)}}
    $OSUptime = (Get-Date) - $OSLastBoot.LastBootUpTime
    $ScriptOut = "" + $OSUptime.Days + " Days, " + $OSUptime.Hours + " Hours, " + $OSUptime.Minutes + " Minutes, " + $OSUptime.Seconds + " Seconds"
    Write-Output  $ScriptOut
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}