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

taskkill /f /t /im FactoryServer-Win64-Shipping-Cmd.exe >nul 2>&1

"%~dp0satisfactoryserver/FactoryServer.exe" -log -unattended -port=7777

setlocal

setlocal EnableDelayedExpansion

set PORT=7777

:check_port
set "found="
for /F "tokens=2 delims=:" %%a in ('netstat -a -n -o -p UDP ^| findstr :%PORT%') do set "found=%%a"
if not defined found (
    echo %date%%time% SatisfactoryDedicatedServer is offline. Restarting the server, please be patient
    nircmd stopprocess "FactoryServer-Win64-Shipping-Cmd.exe"
    timeout /T 10 >nul
    "%~dp0satisfactoryserver/FactoryServer.exe" -log -unattended -port=7777
)
echo %date%%time% SatisfactionDedicatedServer is working properly. QQ:1056484009 QQgroup:264127585

timeout /T 30 >nul
goto check_port
