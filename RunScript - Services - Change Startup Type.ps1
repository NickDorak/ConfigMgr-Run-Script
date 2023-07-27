# Services - Change Startup Type
# Service Action: Nothing, Start, Stop, Restart
# Startup Type: Automatic, AutomaticDelay, Manual, Disabled
Param(
    [Parameter(Mandatory=$True)]
    [string]$ServiceName,
    [Parameter(Mandatory=$True)]
    [string]$ServiceType,
    [Parameter(Mandatory=$True)]
    [string]$ServiceJob
)
Try {
    $Service = Get-Service $ServiceName
    If ($Service.Count -eq 1) {
        # Change Startup Type in Registry
        $Reg = Get-Item ("HKLM:\SYSTEM\CurrentControlSet\Services\" + $Service.Name)
        If ($ServiceType -eq "Automatic") {
            $Reg | Set-ItemProperty -Name "Start" -Value "2"
            $Reg | Remove-ItemProperty -Name "DelayedAutostart"
        } ElseIf ($ServiceType -eq "AutomaticDelay") {
            Set-ItemProperty -Path $Reg.Name -Name "Start" -Value "2"
            $Reg | New-ItemProperty -Name "DelayedAutostart" -Value "1" -PropertyType Dword -ErrorAction SilentlyContinue
            $Reg | Set-ItemProperty -Name "DelayedAutostart" -Value "1"
        } ElseIf ($ServiceType -eq "Manual") {
            $Reg | Set-ItemProperty -Name "Start" -Value "3"
            $Reg | Remove-ItemProperty -Name "DelayedAutostart"
        } ElseIf ($ServiceType -eq "Disabled") {
            $Reg | Set-ItemProperty -Name "Start" -Value "4"
            $Reg | Remove-ItemProperty -Name "DelayedAutostart"
        } 

        # Action if Required
        If ($ServiceJob -ne "Nothing") {
            $Command = ($ServiceJob + "-Service -Name " + $Service.Name)
            Invoke-Expression -Command $Command
        }     
        
        # Report
        $ServiceCIM = Get-CimInstance -ClassName Win32_Service -Filter "Name = '$($Service.Name)'"
        $ProcessCIM = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = '$($ServiceCIM.ProcessId)'"
        $ScriptOut = $Service.Name + ": " + $ServiceCIM.StartMode + " - " + $ServiceCIM.State + ", Last Start Time: " + $ProcessCIM.CreationDate
        Write-Output $ScriptOut.ToString()
    } ElseIf ($Service.Count -gt 1) {
        Write-Output "Too many $ServiceName services found, count: $($Service.Count) "
        Exit 3
    } Else {
        Write-Output "No service found with name: $ServiceName"
        Exit 2
    }
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}