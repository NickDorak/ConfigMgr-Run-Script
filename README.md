# ConfigMgr-Run-Script
Scripts to use in SCCM/MEMCM when right-clicking on and choosing "Run Script"

## [RunScript - Running Process.ps1](RunScript%20-%20Running%20Process.ps1)
This script allows specifying a process to lookup on devices. It will return PID, CPU Usage (%), RAM Usage (MB) and Start Time for each instance of the proces found. 
You can specify wildcards for process name (i.e. "msedge*") to find multiple processes at once. 

## [RunScript - Update History.ps1](RunScript%20-%20Update%20History.ps1)
This script will get a list of updates installed on the device. You can choose to return **All** (including failed, in progress, success and others), **Successful** (for all past and present updates) and **Current** (for only latests and currently installed updates).
The output will be in JSON format. You can copy/paste the results to a new text file with _.json_ extension, then import to Excel if needed. 

## [RunScript - Internet Speedtest.ps1](RunScript%20-%20Internet%20Speedtest.ps1)
This script will download (only first time) the SpeedtestCLI from Ookla's website, then execute silently. When run again, it will check if the file already exists before downloading again. The output will return up/down speeds and latency for the device. 