# Registry Key Check-Change
# Gets Value of RegKey and Changes (if select) for both System or User hives
# Varriables...
#     Key:    Software\Policies\Microsoft\MicrosoftEdge\Internet Settings
#     Name:   ProvisionedHomePages
#     Value: 
#     Action: Check, Change
#     Hive:   HKEY_LOCAL_MACHINE, HKEY_CLASSES_ROOT, HKEY_CURRENT_USER
#     Type:   DWord, String, ExpandString, QWord, Binary
Param(
    [Parameter(Mandatory=$True)]
    [string]$Key,
    [Parameter(Mandatory=$True)]
    [string]$Name,
    [Parameter(Mandatory=$True)]
    [string]$Action,
    [Parameter(Mandatory=$True)]
    [string]$Hive,
    [Parameter(Mandatory=$False)]
    [string]$Value,
    [Parameter(Mandatory=$False)]
    [string]$Type
)

Try {
    # Normalize User Input
    $Keys = @()
    IF ($Hive -eq "HKEY_LOCAL_MACHINE") {
        $Keys = [PSCustomObject]@{Path = "Registry::" + $Hive + "\" + $Key}
    } ElseIf ($Hive -eq "HKEY_CLASSES_ROOT") {
        $Keys = [PSCustomObject]@{Path = "Registry::" + $Hive + "\" + $Key}
    } ElseIf ($Hive -eq "HKEY_CURRENT_USER") {
        $Keys += (Get-ChildItem Registry::HKEY_USERS -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' }).PSChildName | 
            Select-Object @{N="Path";E={"Registry::HKEY_USERS\" + $_ + "\" + $Key}},@{N="SID";E={$_}},
            @{N="User";E={((Get-ItemProperty ("Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" + $_ ) -ErrorAction SilentlyContinue).ProfileImagePath -Split "\\")[-1]}}
    }
    # @{N="User";E={((Get-ItemProperty ("Registry::HKEY_USERS\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" + $_ + "\Volatile Environment") -ErrorAction SilentlyContinue).PSObject.Properties | Where-Object {$_.Name -eq "USERNAME"} | Select-Object Value).Value}}
    
    # Change Key
    IF ($Action -eq "Change") {
        ForEach ($FullKey in $Keys) {
            If (!(Get-Item -Path $FullKey.Path -ErrorAction SilentlyContinue)) {
                New-Item -Path $FullKey.Path -Force
            }
            Set-ItemProperty -Path $FullKey.Path -Name $Name -Value $Value -Type $Type
        }
    }

    # Check Key
    $RegValues = @() 
    ForEach ($FullKey in $Keys) {
        $RegValues += (Get-ItemProperty -Path $FullKey.Path -ErrorAction SilentlyContinue).PSObject.Properties | Where-Object {$_.Name -eq $Name} | Select-Object Name, TypeNameOfValue, Value, @{N="User";E={$FullKey.User}}
    }

    # Output Results
    ForEach ($RegValue in $RegValues) {
        If ($RegValue.User) {$UserScript = ($RegValue.User + " - ")} Else {$UserScript = ""}
        $ScriptOut = $UserScript.ToString() + $RegValue.Name.ToString()  + " = " + $RegValue.Value.ToString() + " (Reg Type = " + $RegValue.TypeNameOfValue.ToString() + ")"
        Write-Output $ScriptOut.ToString()
    }
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}