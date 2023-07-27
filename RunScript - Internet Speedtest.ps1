# Internet Speedtest
# Tests internet connection for each device

# Download EXE if not already existing
$DownloadLocation = "$($Env:ProgramData)\SpeedtestCLI"
Try {
    If (!(Test-Path "$DownloadLocation\speedtest.exe")) {
        #Latest version can be found at: https://www.speedtest.net/nl/apps/cli
        $DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip"
        New-Item $DownloadLocation -ItemType Directory -Force | Out-Null
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12    #Required for Win2012
        Invoke-WebRequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\speedtest.zip" | Out-Null
        # Expand-Archive "$($DownloadLocation)\speedtest.zip" -DestinationPath $DownloadLocation -Force | Out-Null   #Not working in Win2012
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::OpenRead($DownloadLocation + "\speedtest.zip").Entries.FullName | ForEach-Object {Remove-Item -Path ($DownloadLocation +"\"+ $_) -Force -ErrorAction Ignore}
        [System.IO.Compression.ZipFile]::ExtractToDirectory(($DownloadLocation + "\speedtest.zip"), $DownloadLocation)
    } 
} Catch {  
    Write-Output "The download/unzip of SpeedtestCLI failed. Error: $_"
    Exit 1
}

Try {
    #$PreviousResults = if (test-path "$($DownloadLocation)\LastResults.txt") { get-content "$($DownloadLocation)\LastResults.txt" | ConvertFrom-Json }
    $SpeedtestOutput = & "$($DownloadLocation)\speedtest.exe"  @('--format=json', '--accept-license', '--accept-gdpr')  #'--format=json-pretty' doesn't work in Win2012
    $SpeedtestOutput | Out-File "$($DownloadLocation)\LastResults.json" -Force
    $SpeedtestResults = $SpeedtestOutput | ConvertFrom-Json
    
    #creating object
    [PSCustomObject]$SpeedtestObj = @{
        downloadspeed = [math]::Round($SpeedtestResults.download.bandwidth / 1000000 * 8, 2)
        uploadspeed   = [math]::Round($SpeedtestResults.upload.bandwidth / 1000000 * 8, 2)
        packetloss    = [math]::Round($SpeedtestResults.packetLoss)
        isp           = $SpeedtestResults.isp
        ExternalIP    = $SpeedtestResults.interface.externalIp
        InternalIP    = $SpeedtestResults.interface.internalIp
        UsedServer    = $SpeedtestResults.server.host
        ResultsURL    = $SpeedtestResults.result.url
        Jitter        = [math]::Round($SpeedtestResults.ping.jitter)
        Latency       = [math]::Round($SpeedtestResults.ping.latency)
    }

    $ScriptOut = $SpeedtestObj.downloadspeed.ToString()  + " Mbps Down / " + $SpeedtestObj.uploadspeed.ToString() + " Mbps Up / " + $SpeedtestObj.Latency + " ms Latency"
    Write-Output $ScriptOut.ToString()
} Catch {
    Write-Output "Failed: $_"
    Exit 1
}