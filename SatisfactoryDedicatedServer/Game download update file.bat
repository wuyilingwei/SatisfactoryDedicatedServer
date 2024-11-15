if not exist "%~dp0steamcmd" (
    mkdir "%~dp0steamcmd"
    copy /Y "%~dp0steamcmd.exe" "%~dp0steamcmd\steamcmd.exe"
)
taskkill /IM FactoryServer-Win64-Shipping-Cmd.exe /F
"%~dp0steamcmd/steamcmd.exe" +force_install_dir "%~dp0SatisfactoryServer" +login anonymous +app_update 1690800 -beta public validate +quit