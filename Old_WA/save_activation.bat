@echo off
setlocal enabledelayedexpansion

:: Set paths for backup and logs
set "ScriptPath=%~dp0"
set "backupDir=%~dp0ActivationBackup"
rem Offline script to save and restore activation for Microsoft Windows and Office licenses by Thelogh
rem Backup and Restore Microsoft Windows and Microsoft Office License Activation Offline
rem For all requests write on the blog
rem REPOSITORY
rem https://github.com/thelogh/save_restore_activation_microsoft_license
rem V.1.0.0


rem Create directories for placing the license and token file.
:: Create backup directory
if not exist "!backupDir!" mkdir "!backupDir!"
if not exist "!backupDir!\license" mkdir "!backupDir!\license"
if not exist "!backupDir!\GenuineTicket" mkdir "!backupDir!\GenuineTicket"

rem Stop the services to get the license and token file
net stop clipsvc
net stop sppsvc

rem Backup the Windows licnese
XCOPY %SystemRoot%\System32\spp\store "!backupDir!\license" /E /H /C /I /Q /Y

rem Backup the activation tokens for Office
XCOPY %ProgramData%\Microsoft\Windows\ClipSVC\tokens.dat "!backupDir!\GenuineTicket" /O /X /H /K /Y

rem Dump the licnese in registry 
"!ScriptPath!\PsExec.exe" -i -s -accepteula reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\{7746D80F-97E0-4E26-9543-26B41FC22F79} .\winactivationkey.reg

copy %SystemRoot%\System32\winactivationkey.reg !backupDir!
del %SystemRoot%\System32\winactivationkey.reg

rem Bring back the services
net start clipsvc
net start sppsvc

echo Your licnese file is located at: "!backupDir!", please keep it safe.
pause
