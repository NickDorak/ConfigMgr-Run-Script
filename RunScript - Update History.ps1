# Update History
# Lists all updates installed on system
# Varriables...
#     Type:   All, Successful, CurrentOnly
# More: https://social.technet.microsoft.com/wiki/contents/articles/4197.windows-how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx

Param(
    [Parameter(Mandatory=$True)]
    [string]$Type
)

Try {
    If ($Type -eq "CurrentOnly") {
        $Updates = Get-WmiObject -Class "win32_quickfixengineering"
        
        # Output Results
        $Updates | Select-Object -Property @{name="Title"; expression={$_.HotfixID}}, 
            @{Name="Date"; Expression={([DateTime]($_.InstalledOn)).ToLocalTime()}}, 
            @{name="Result"; expression={"Currently Installed"}},
            @{name="Category"; expression={$_.Description}} 

    } ElseIf ($Type -eq "Successful") {
        $Session = New-Object -ComObject "Microsoft.Update.Session"
        $Searcher = $Session.CreateUpdateSearcher()
        $HistoryCount = $Searcher.GetTotalHistoryCount()
        $Updates = $Searcher.QueryHistory(0, $historyCount) | Where-Object {$_.Operation -eq 1 -and $_.ResultCode -eq 2}
        
        # Output Results
        $Updates | Select-Object Title, Date,
            @{name="Result"; expression={If($_.ResultCode -eq 2){"Success"}else{$_.HResult}}},
            @{name="Category"; expression={$_.Categories[0].Name}}

    } Else {
        $Session = New-Object -ComObject "Microsoft.Update.Session"
        $Searcher = $Session.CreateUpdateSearcher()
        $HistoryCount = $Searcher.GetTotalHistoryCount()
        $Updates = $Searcher.QueryHistory(0, $historyCount) | Where-Object {$_.Operation -eq 1}
        
        # Output Results
        $Updates | Select-Object Title, Date,
            @{name="Result"; expression={If($_.ResultCode -eq 2){"Success"}else{$_.HResult}}},
            @{name="Category"; expression={$_.Categories[0].Name}}
    }
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}