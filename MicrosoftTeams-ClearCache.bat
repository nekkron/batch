@echo off
TITLE Clearing Microsoft Teams Cache
IF EXIST "%LocalAppData%\Microsoft\Teams\current\Teams.exe" (
ECHO Closing Microsoft Teams
TASKKILL /F /IM Teams.exe /T
ECHO.
ECHO Clearing Application Cache 
DEL "%AppData%\Microsoft\Teams\Application Cache\Cache" /S /Q *
ECHO Clearing Blob Storage
DEL "%AppData%\Microsoft\Teams\blob_storage" /S /Q *
ECHO Clearing Teams Cache
DEL "%AppData%\Microsoft\Teams\Cache" /S /Q *
ECHO Clearing Teams Databases
DEL "%AppData%\Microsoft\Teams\databases" /S /Q *
ECHO Clearing Teams GPU Cache
DEL "%AppData%\Microsoft\Teams\GPUcache" /S /Q *
ECHO Clearing Teams IndexedDB
DEL "%AppData%\Microsoft\Teams\IndexedDB" /S /Q *.db
ECHO Clearing Teams Local Storage
DEL "%AppData%\Microsoft\Teams\Local Storage" /S /Q *
ECHO Clearing Teams Temporary Files
DEL "%AppData%\Microsoft\Teams\tmp" /S /Q *
ECHO.
ECHO Microsoft Teams Cache has been deleted. 
ECHO.
ECHO Starting Microsoft Teams
START "" "%LocalAppData%\Microsoft\Teams\current\Teams.exe"
	) ELSE (
ECHO.
ECHO Microsoft Teams is NOT installed.
ECHO.
PAUSE
	)
EXIT