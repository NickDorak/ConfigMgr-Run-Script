# ConfigMgr-Run-Script
Scripts to use in SCCM/MEMCM when right-clicking on and choosing "Run Script".
You can use these scripts on individual devices or for a collection of devices. 
Performing remote management on systems without creating an RDP session or inturupting users is always prefered. 
.

## [RunScript - Running Process.ps1](RunScript%20-%20Running%20Process.ps1)
This script allows specifying a process to lookup on devices. It will return PID, CPU Usage (%), RAM Usage (MB) and Start Time for each instance of the proces found. 
You can specify wildcards for process name (i.e. "msedge*") to find multiple processes at once. 

## [RunScript - Update History.ps1](RunScript%20-%20Update%20History.ps1)
This script will get a list of updates installed on the device. You can choose to return **All** (including failed, in progress, success and others), **Successful** (for all past and present updates) and **Current** (for only latests and currently installed updates).
The output will be in JSON format. You can copy/paste the results to a new text file with _.json_ extension, then import to Excel if needed. 

## [RunScript - Internet Speedtest.ps1](RunScript%20-%20Internet%20Speedtest.ps1)
This script will download (only first time) the SpeedtestCLI from Ookla's website, then execute silently. When run again, it will check if the file already exists before downloading again. The output will return up/down speeds and latency for the device. 

## [RunScript - Registry Key Check-Change.ps1](RunScript%20-%20Registry%20Key%20Check-Change.ps1)
This script can check or change existing registry entries on a system. The script only works for **HKEY_LOCAL_MACHINE**, **HKEY_CLASSES_ROOT** or **HKEY_CURRENT_USER** registry hives at this time. HKEY_USERS gets too complicated and since those entries aren't likely applied in bulk, it made more sense to leave off for the time being. 

## [RunScript - Services - Change Startup Type.ps1](RunScript%20-%20Services%20-%20Change%20Startup%20Type.ps1)
This script will change a service start type (between Automatic, AutomicDelay, Manual & Disabled). It will also start, stop or restart the service if required. 

## [RunScript - Services - Stop_Start_Restart.ps1](RunScript%20-%20Services%20-%20Stop_Start_Restart.ps1)
This script will also start, stop or restart a service on the target machine. 

## [RunScript - Last Reboot_Uptime.ps1](RunScript%20-%20Last%20Reboot_Uptime.ps1)
This script outputs the date and time the system was rebooted last

## [RunScript - System UpTime.ps1](RunScript%20-%20System%20UpTime.ps1)
This script checks how long a system has been running for and reports back in Days, Hours, Minutes, etc.