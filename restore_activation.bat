@echo off
setlocal enabledelayedexpansion

:: Set backup directory
set "ScriptPath=%~dp0"
set "backupDir=%~dp0ActivationBackup"
set "logFile=%backupDir%\restore_log.txt"

rem Offline script to save and restore activation for Microsoft Windows and Office licenses by Thelogh
rem Backup and Restore Microsoft Windows and Microsoft Office License Activation Offline
rem For all requests write on the blog
rem REPOSITORY
rem https://github.com/thelogh/save_restore_activation_microsoft_license
rem V.2.0.0

echo Do not connect your PC or SERVER to the internet until the license has been restored!!!
echo Please make sure the internet is disconnected before you continue.
pause

rem Stop the services
net stop clipsvc
net stop sppsvc


:: Restore Windows activation files
if exist "!backupDir!\WindowsActivation" (
    echo Restoring Windows activation...
XCOPY "!backupDir!\WindowsActivation\2.0" %SystemRoot%\System32\spp\store\2.0 /O /X /E /H /K /Y
    echo Windows activation restored from !backupDir!\WindowsActivation >> "!logFile!"
) else (
    echo Windows activation backup not found.
)

:: Restore Office activation files
if exist "!backupDir!\OfficeActivation" (
    echo Restoring Office activation...
XCOPY "!backupDir!\OfficeActivation\tokens.dat" %ProgramData%\Microsoft\Windows\ClipSVC /O /X /H /K /Y
        echo Office activation restored to your system >> "!logFile!"
    )
) else (
    echo Office activation backup not found.
)

:: Import registry keys (if backup exists)
if exist "!backupDir!\winactivationkey.reg" (
    echo Importing registry keys...
    
copy /Y "!backupDir!\winactivationkey.reg" %SystemRoot%\System32\winactivationkey.reg
"!ScriptPath!\PsExec.exe" -i -s -accepteula reg import %SystemRoot%\System32\winactivationkey.reg
del %SystemRoot%\System32\winactivationkey.reg
    echo Registry keys imported >> "!logFile!"
)

echo Restoring license is finished. You may need to check whether there is some errors in the output above.
echo You computer will reboot after you press any key.
pause >nul
shutdown /r /t 0
