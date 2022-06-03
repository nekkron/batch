@echo off
cls

:elevate script to admin rights
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

 
:Check windows version for OS specific items
@echo off
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" set OS="10"
if "%version%" == "6.3" set OS="8.1"
if "%version%" == "6.2" set OS="8"
if "%version%" == "6.1" set OS="7"
endlocal

:if "%OS%" == "10" echo win10test

:Ask the tech what machine type this is
CLS
ECHO 1.Staff Non-domain Machine
ECHO 2.Staff Domain Machine
ECHO 3.Troop Machine
ECHO.

CHOICE /C 12345 /M "Enter your choice:"

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 3 GOTO Troop
IF ERRORLEVEL 2 GOTO Staffdomain
IF ERRORLEVEL 1 GOTO Staffnondomain


Troop:
:check clean slate version
@echo off
FOR /F "tokens=2 delims==" %%I IN (
  'wmic datafile where "name='C:\\Program Files (x86)\\Common Files\\Company\\Product\\Version12\\Product.exe'" get version /format:list') DO SET "RESULT=%%I"
ECHO %RESULT%
:CleanSlate removal code
:CleanSlate install code
:CleanSlate Settings install code
:uninstall old clean slate version

:install new clean slate version
csv10bXXXX.exe /qb-! REBOOT=FORCE FGC_STORAGETYPE=1 FGC_STORAGEINFO=XXXXX FSI_PASSWORD=XXXXXX FGC_SERIALNUMBER=XXXXX-XXXXXXXXXX FGC_INSTALLDEMO=0




:Staffdomain
:Staffnondomain



:Rename Machine
:Coming Soon


:Change Windows 7 Product Key
slmgr.vbs -ipk "INSERT-YOUR-PRODUCT-KEY"
:Activate
slmgr.vbs –ato

:Activate Office
cd C:\Program Files\Microsoft Office\Office16
cscript ospp.vbs /act

:Dump List of time zones
:tzutil /l
tzutil /s "W. Europe Standard Time"
reg query HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation

:Firefox Removal per Patrick

:Firefox (32-bit) 
IF EXIST "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" -ms

:Firefox (64-bit)
IF EXIST "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" -ms

:Firefox 3.x (32-bit) 
IF EXIST "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" "%ProgramFiles%\Mozilla Firefox\uninstall\helper.exe" /s

:Firefox 3.x (64-bit)
IF EXIST "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" "%ProgramFiles(x86)%\Mozilla Firefox\uninstall\helper.exe" /s

:Silent install installroot
:todo
:Install DoD Certs
%ProgramFiles%\DoD-PKE\InstallRoot4\InstallRoot.exe –-insert

:Install Java
:https://www.java.com/en/download/help/silent_install.xml

:: On-Demand Flash Autoupdate
:: Author: Karl Horky
:: Date: 22 June 2012
:: Version: 0.2
:: Homepage: http://www.karlhorky.com/2012/06/manually-run-autoupdate-for-adobe-flash.html

:Update Flash
cd C:\Windows\System32\Macromed\Flash\
rem if exist *ActiveX.exe (
rem echo Updating Flash Player Plugin for Internet Explorer
rem for /f "tokens=*" %%f in ('dir /b *ActiveX.exe') do set last=%%f
rem )
rem if defined last (
rem %last% -update plugin
rem set last=
rem echo Complete!
rem )
if exist *Plugin.exe (
echo Updating Flash Player Plugin for Firefox, Safari, Opera
for /f "tokens=*" %%f in ('dir /b *Plugin.exe') do set last=%%f
)
if defined last (
%last% -update plugin
echo Complete!
)
pause



:install BCM Silently
rem BMCAgent.exe -silent
:Make file read only
attrib +r %ProgramFiles%\BMC Software\Client Management\Client\config\mtxagent.ini

:end

