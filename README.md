# ConfigMgr-Run-Script
Scripts to use in SCCM/MEMCM when right-clicking on and choosing "Run Script"

## RunScript - Running Process.ps1
This script allows specifying a process to lookup on devices. It will return PID, CPU Usage (%), RAM Usage (MB) and Start Time for each instance of the proces found. 
You can specify wildcards for process name (i.e. "msedge*") to find multiple processes at once. 