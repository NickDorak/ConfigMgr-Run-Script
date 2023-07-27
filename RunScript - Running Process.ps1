# Running Process
# Gets Running Process Details & Can Terminate if Needed
# Varriables...
#     Name:   Enter the name of the process (can use '*')
#     Kill:   Should the process be terminated?

Param(
    [Parameter(Mandatory=$True)]
    [string]$Name,
    [Parameter(Mandatory=$False)]
    [string]$Kill = "No"
)
# $Name = "Sentinel*"

$Processes = Get-Process ($Name -replace ".exe")
$Output = @()
ForEach ($Process in $Processes) {
    # Write-Output $Process.Id
    $ProcPath = ((Get-Counter "\Process(*)\ID Process").CounterSamples | Where-Object {$_.RawValue -eq $($Process.Id)}).Path
    $ProcTime = Get-Counter ($ProcPath -replace "\\id process$","\% Processor Time")
    $Output += [pscustomobject]@{
        'Name'        = $Process.ProcessName
        'PID'         = $Process.Id
        'CPU%'        = $ProcTime.CounterSamples.CookedValue
        'RAM(MB)'     = ($Process.WorkingSet /1MB).ToString('N2')
        'StartDate'   = $Process.StartTime.ToString()
        'Computer'    = ($ProcPath -Replace '^\\+','' -Split '\\')[0]
    }
}
If ($Kill -eq "Yes") {
    ForEach ($Process in $Processes) {
        Stop-Process -Id $Process.Id -Force
    }
}

Write-Output $Output | ConvertTo-CSV -NoTypeInformation