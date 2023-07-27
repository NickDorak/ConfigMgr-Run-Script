# Services - Stop/Start/Restart
Param(
    [Parameter(Mandatory=$True)]
    [string]$ServiceName,
    [Parameter(Mandatory=$True)]
    [string]$ServiceJob
)
Try {
    $Service = Get-Service $ServiceName
    If ($Service.Count -eq 1) {
        $Command = ($ServiceJob + "-Service -Name " + $Service.Name)
        Invoke-Expression -Command $Command
        $ServiceCIM = Get-CimInstance -ClassName Win32_Service -Filter "Name = '$($Service.Name)'"
        $ProcessCIM = Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = '$($ServiceCIM.ProcessId)'"
        $ScriptOut = $Service.Name + ": " + $ServiceCIM.State + ", Last Start Time: " + $ProcessCIM.CreationDate
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