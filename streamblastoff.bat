@echo off
title streamblastoff pre21.3 by letivalo
:: Find my Twitch at KaolinnLive 

:: Minimizes cmd window for batch file; ends killsnaz task if already active
powershell -window minimized -command ""
schtasks /delete /tn killsnaz /f

::Kills Spotify process before starting Snip to prevent snip.txt readback error
taskkill /f /im spotify.exe

:: Locates and starts Snip.exe; Minimizes all windows to hide snip browser pop-up
cd /d "%userprofile%\Desktop\streamblastoff\libraries\binaries\Snip"
start Snip.exe
timeout /t 1 /nobreak
powershell -command "(new-object -com shell.application).minimizeall()"

:: Locates and starts a new instance of Spotify.exe; Minimizes all windows since Spotify cannot be minimized using powershell "-window minimized"
cd %appdata%\Spotify
start spotify.exe
powershell -command "(new-object -com shell.application).minimizeall()"

:: Locates and starts Snaz.exe; Minimizes Snaz application on start
:: NOTICE - Set ChronosDwn to autostart in Snaz settings; Configure ChronosDwn to preference
cd /d "C:\Snaz"
powershell -window minimized -command "start Snaz.exe"

:: Locates and starts lumacros.exe, telling it to read the luastreamkeys.lua
cd /d %userprofile%\Desktop\streamblastoff\libraries\binaries\luamacros
start luamacros.exe luastreamkeys.lua

:: Locates and starts SLOBS; sets SLOBS to current active window using switch.vbs in batch mode
cd /d "C:\Program Files\Streamlabs OBS"
start "" "Streamlabs OBS.exe"
powershell  %userprofile%\Desktop\streamblastoff\libraries\switch.vbs //b /ilc "Streamlabs OBS.exe"

:: Fetches current systime, adds on top specified minutes at .AddMinutes(here), saves as variable %endtime%
for /f "delims=" %%G IN ('powershell "(get-date %time%).AddMinutes(15).ToString('HH:mm:ss')"') do set endtime=%%G

:: Creates a onetime system task to kill Snaz.exe at time given in %endtime% to  corrispond with when chronosdwn is done
schtasks /create /sc once /ST %endtime% /TN killsnaz /TR "taskkill /f /im Snaz.exe"

exit