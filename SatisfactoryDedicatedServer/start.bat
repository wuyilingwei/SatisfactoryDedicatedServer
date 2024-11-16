@echo off

title checking for admin rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
title waiting for admin rights
mode con cols=20 lines=1
goto UACPrompt
) else ( goto start )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:start

title FactoryServerDaemon
echo You are starting the SatisfactoryDedicatedServer in daemon mode
echo Please do not close this window

echo first author is Frostmushrooms QQ:1056484009 QQgroup:264127585

echo v1.1 edited by Wuyilingwei

taskkill /f /t /im FactoryServer-Win64-Shipping-Cmd.exe >nul 2>&1

echo [INFO] %date:~0,11%%time% Starting Server
start "" "%~dp0satisfactoryserver/FactoryServer.exe" -log -unattended -port=7777

setlocal

set PORT=7777

echo [INFO] %date:~0,11%%time% Daemon Online

:check

timeout /T 30 >nul

set found=0
:: set restarting_grace depending on your computer performance, n*30 seconds
set restarting_grace_default = 2
set restarting_grace = %restarting_grace_default%

for /f "tokens=*" %%i in ('netstat -a -b -n -o -p UDP ^| findstr "FactoryServer-Win64-Shipping-Cmd.exe"') do (
    set "line=%%i"
    for /f "tokens=2,3" %%a in ("!line!") do (
        if %%b==0.0.0.0:%port% (
            set found=1
            goto :break
        )
    )
)

if !found! == 0 (
    if !restarting_grace! != 0 (
        set /a restarting_grace = !restarting_grace! - 1
        echo [Warning] %date:~0,11%%time% Cannot find FactoryServer-Win64-Shipping-Cmd.exe listening on UDP port %port%. Remaining restarting_grace: %restarting_grace%
        goto check
    )
    echo [ERROR] %date:~0,11%%time% SatisfactoryDedicatedServer UDP listen is accident offline.
    echo [Warning] %date:~0,11%%time% Sent closeprocess command to FactoryServer-Win64-Shipping-Cmd.exe, waiting 30 seconds for it to close
    nircmd closeprocess "FactoryServer-Win64-Shipping-Cmd.exe"
    timeout /T 30 >nul
    if tasklist /fi "imagename eq FactoryServer-Win64-Shipping-Cmd.exe" | find ":" >nul (
        echo [ERROR] %date:~0,11%%time% FactoryServer-Win64-Shipping-Cmd.exe is still running. Force kill it.
        taskkill /f /t /im FactoryServer-Win64-Shipping-Cmd.exe >nul 2>&1
    )
    echo [INFO] %date:~0,11%%time% Restarting Server
    start "" "%~dp0satisfactoryserver/FactoryServer.exe" -log -unattended -port=7777
    set restarting_grace = %restarting_grace_default%
) else (
    echo [INFO] %date:~0,11%%time% SatisfactionDedicatedServer is working properly. Next check in 30 seconds
    set restarting_grace = 0
)


goto check
