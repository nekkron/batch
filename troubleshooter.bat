@echo off

REM All-in-one Troubleshooting Script. COPY THIS FILE TO YOUR DESKTOP AND RUN FROM DESKTOP
REM This troubleshooter was designed for Windows 7 and older.
REM This file was created by James K (v 1.1)

%systemdrive%
set troublepath=%temp%\troubleshooter
set LOG=%userprofile%\Desktop\%COMPUTERNAME%.txt
set PCclass=%COMPUTERNAME:~0,2%

title Computer Troubleshooting Assistant - DO NOT CLOSE THIS WINDOW

echo This file is collecting information about your system. 
echo When this window disappears, please email the file on your desktop labeled: "%COMPUTERNAME%.txt" 
echo to your helpdesk along with a description of the problem you are having.
echo.
echo Computer Name: %COMPUTERNAME% 
echo.
echo %USERNAME% is running this script.
echo.

echo Generating Time Stamp 
echo DATE and TIME: > %LOG%
echo %date% >> %LOG%
echo %time% >> %LOG%
echo. >> %LOG%

wmic /OUTPUT:%troublepath%\1SERVICETAG.txt Bios get SerialNumber
type %troublepath%\1SERVICETAG.txt >> %LOG%
echo. >> %LOG%

echo ===============================SYSTEM INFO================================ >> %LOG%
echo Collecting System Information 
systeminfo >> %LOG% 
echo. >> %LOG%

echo Hard Disk Drive Information >> %LOG%
echo --------------------------- >> %LOG%
wmic /OUTPUT:%troublepath%\1HDD_INFO.txt DiskDrive get Name,Size,Model
wmic /OUTPUT:%troublepath%\1HDD_SN.txt path Win32_PhysicalMedia get SerialNumber
type %troublepath%\1HDD_INFO.txt >> %LOG%
echo. >> %LOG%
type %troublepath%\1HDD_SN.txt >> %LOG%
echo. >> %LOG%

echo Printers Installed >> %LOG%
echo ------------------ >> %LOG%
wmic /OUTPUT:%troublepath%\1PRINTERS.txt Printer list Status
type %troublepath%\1PRINTERS.txt >> %LOG%
rem Add in a way instead of giving an error on the CMD window, to 'ignore' the null
echo. >> %LOG%

echo Recent or Active Print Jobs >> %LOG%
echo --------------------------- >> %LOG%
wmic /OUTPUT:%troublepath%\1PRINTJOB.txt PrintJob get Document,PagesPrinted,JobStatus,Owner,Size
type %troublepath%\1PRINTJOB.txt >> %LOG%
rem Add in a way instead of giving an error on the CMD window, to 'ignore' the null
echo. >> %LOG%

REM echo Active Share Drives >> %LOG%
REM echo ------------------- >> %LOG%
REM wmic /OUTPUT:%troublepath%\1SHARE.txt Share list Brief
REM type %troublepath%\1SHARE.txt >> %LOG%
REM echo. >> %LOG%

echo ==============================USER ACCOUNTS=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Users on System

dir "%systemdrive%\Users" >> %LOG%
echo. >> %LOG%

echo ===============================SYSTEM DUMPS=============================== >> %LOG%
echo. >> %LOG%
echo Collecting Information on System Dumps (Blue Screens)

dir "%windir%\MiniDump" >> %LOG% 
echo. >> %LOG%

echo =================================AV INFO================================== >> %LOG%
echo Collecting AntiVirus Information

REM x86 AntiVirus Information (32-bit)
REM IF %processor_architecture% == x86 (
REM 		REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatVersion >> %LOG%
REM 		REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatDate >> %LOG%
REM 		REG QUERY HKLM\Software\McAfee\AvEngine /v EngineVersion32Major >> %LOG%
REM 		REG QUERY HKLM\Software\McAfee\AvEngine /v EngineVersion32Minor >> %LOG% 
REM 	) OR (
REM 	IF EXIST "%programfiles%\McAfee.com\Agent\mcagent.exe (	
REM 		REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatVersion >> %LOG%
REM echo. >> %LOG%

REM x64 AntiVirus Information (64-bit)
IF %processor_architecture% == AMD64 (
	IF EXIST "%programfiles%\McAfee.com\Agent\mcagent.exe
echo... McAfee Information >> %LOG%
echo... ------------------ >> %LOG%
echo. >> %LOG%
REG QUERY HKLM\Software\Wow6432Node\McAfee\AVEngine /v AVDatVersion >> %LOG%
REG QUERY HKLM\Software\Wow6432Node\McAfee\AVEngine /v AVDatDate >> %LOG%
REG QUERY HKLM\Software\Wow6432Node\McAfee\AvEngine /v EngineVersion32Major >> %LOG%
REG QUERY HKLM\Software\Wow6432Node\McAfee\AvEngine /v EngineVersion32Minor >> %LOG% 	
REG QUERY HKLM\Software\Wow6432Node\McAfee\AvEngine /v EngineVersion64Major >> %LOG%
REG QUERY HKLM\Software\Wow6432Node\McAfee\AvEngine /v EngineVersion64Minor >> %LOG% 	
	) ELSE (
REM x86 AntiVirus Information (32-bit)
REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatVersion >> %LOG%
REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatDate >> %LOG%
REG QUERY HKLM\Software\McAfee\AvEngine /v EngineVersion32Major >> %LOG%
REG QUERY HKLM\Software\McAfee\AvEngine /v EngineVersion32Minor >> %LOG% 	
	)
echo. >> %LOG%

echo... Symantec Information >> %LOG%
echo... -------------------- >> %LOG%
echo. >> %LOG%

REM x64 AntiVirus Information (64-bit)
REM IF %processor_architecture% == AMD64 (
REM REG QUERY HKLM\Software\Wow6432Node\McAfee\AVEngine /v AVDatVersion >> %LOG%
REM 	) ELSE (

echo. >> %LOG%

echo... Microsoft Security Essentials >> %LOG%
echo... ----------------------------- >> %LOG%
echo. >> %LOG%

REM x64 AntiVirus Information (64-bit)
REM IF %processor_architecture% == AMD64 (
REM REG QUERY HKLM\Software\Wow6432Node\McAfee\AVEngine /v AVDatVersion >> %LOG%
REM 	) ELSE (
REM x86 AntiVirus Information (32-bit)
REM REG QUERY HKLM\Software\McAfee\AVEngine /v AVDatVersion >> %LOG%
echo. >> %LOG%

echo ==============================SOFTWARE INFO=============================== >> %LOG%
echo Collecting Software Information

echo InstallDate  Product Name							Vendor				Version >> %LOG%
wmic Product get Name,Version,Vendor,InstallDate | more +1 | sort /+14 >> %LOG%
echo. >> %LOG%

echo Mozilla Firefox >> %LOG%
echo --------------- >> %LOG%
REM x64 (64-bit)
IF %processor_architecture% == AMD64 (
REG QUERY "HKLM\Software\Wow6432Node\Mozilla\Mozilla Firefox" /v CurrentVersion >> %LOG%
	) ELSE (
REM x86 (32-bit)
REG QUERY "HKLM\Software\Mozilla\Mozilla Firefox" /v CurrentVersion >> %LOG%
	)
echo. >> %LOG%

echo Google Chrome >> %LOG%
echo ------------- >> %LOG%
REG QUERY "HKCU\Software\Google\Chrome\BLBeacon" /v version >> %LOG%
echo. >> %LOG%

echo Internet Explorer >> %LOG%
echo ----------------- >> %LOG%
REG QUERY "HKLM\Software\Microsoft\Internet Explorer" /v svcVersion >> %LOG%
REM $ieVersion=[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $args[0]).OpenSubKey('SOFTWARE\Microsoft\Internet Explorer').GetValue('SvcVersion')
echo. >> %LOG%

echo Microsoft Edge >> %LOG%
echo -------------- >> %LOG%
REM REG QUERY "HKLM\Software\Microsoft\Internet Explorer" /v svcVersion >> %LOG%
REM Get-AppxPackage -Name Microsoft.MicrosoftEdge | Foreach Version
echo. >> %LOG%

echo PowerShell >> %LOG%
echo ---------- >> %LOG%
REG QUERY HKLM\Software\Microsoft\PowerShell\1\PowerShellEngine /v PowerShellVersion >> %LOG%
echo. >> %LOG%

echo =================================IPCONFIG================================= >> %LOG%
echo Collecting IP information 

ipconfig /all >> %LOG% 
echo. >> %LOG%

echo ===================================DNS==================================== >> %LOG%
echo Pinging DNS

ipconfig /all | find /i "dns servers">"%troublepath%\dns.txt"
	for /f "usebackq delims=: tokens=2" %%a in ("%troublepath%\dns.txt") do set dns=%%a
ping %dns% >> %LOG%
echo. >> %LOG%

echo ===============================TRACE ROUTE================================ >> %LOG%
echo Collecting Trace Route Information

set lsvr=%logonserver:~2,16%
tracert %lsvr% >> %LOG%
echo. >> %LOG%

echo ================================NETSTAT -A================================ >> %LOG%
echo Netstat Extended Information >> %LOG%
echo ---------------------------- >> %LOG%
netstat -n -o -a >> %LOG%
echo. >> %LOG%

echo Tasklist >> %LOG%
echo -------- >> %LOG%
tasklist /v >> %LOG%
echo. >> %LOG%

echo =============================SERVICES RUNNING============================= >> %LOG%
echo Collecting Computer Service Information

echo. >> %LOG%
net start >> %LOG%
echo. >> %LOG%

echo ========================================================================== >> %LOG%
REM Clean-up the temporary files
rd /S /Q %troublepath%
ECHO. 
ECHO Copying %COMPUTERNAME%.txt to the share drive.
xcopy %LOG% "\\InternalServer\LOGS$\Troubleshooter" /Q /R /Y /Z
TIMEOUT /t 5
