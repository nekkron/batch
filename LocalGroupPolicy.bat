@echo off
REM Force Admin Mode
:CheckAdmin
REM Checking permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM If error flag set, we do not have admin
if '%errorlevel%' NEQ '0' (
	echo Requesting admin permissions
	goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
	echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	echo UAC.ShellExecute "%~s0","","","runas", 1 >> %temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	exit /B

:gotAdmin
	if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
	pushd "%CD%"
	CD /D "%~dp0"
REM Continuing with rest of script	

ECHO Importing Local Group Policy preventing Microsoft Account Login
ECHO.
cmd /c C:\support\LGPO\LGPO.exe /g "C:\support\LGPO\Win10-Troop"
ECHO.
ECHO You must restart the computer for settings to take affect.
TIMEOUT /T 3
ECHO This computer will restart in 60 seconds. 
shutdown -r -f -t 60
TIMEOUT /T 58
rd C:\support\LGPO\ /s /q
exit
