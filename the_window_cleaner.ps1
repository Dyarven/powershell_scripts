#makes windows less of a pain after a clean install

#bye bye my dear cortana 
Get-AppxPackage -Name Microsoft.549981C3F5F10 | Remove-AppxPackage

#why would i want the weather forecast
Get-AppxPackage -Name Microsoft.BingWeather | Remove-AppxPackage -ErrorAction Stop

#disables xbox game bar
Get-AppxPackage -Name Microsoft.XboxGamingOverlay | Remove-AppxPackage -ErrorAction Stop
Set-Service XboxGipSvc -StartupType Disabled

#disables uac
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLUA -Value 0

#show file extensions
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0

#dark theme for my eyes
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Type DWord

#godmode shortcut on taskbar
$GodModePath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
New-Item -ItemType Directory -Force -Path $GodModePath

#update powershell
$latestVer = Invoke-WebRequest -Uri "https://github.com/PowerShell/PowerShell/releases/latest" -UseBasicParsing
$downloadLink = $latestVer.Links | Where-Object { $_.href -like '*powershell-*-win-x64.msi' } | Select-Object -First 1 -ExpandProperty href
Invoke-WebRequest -Uri $downloadLink -OutFile "$env:USERPROFILE\Downloads\PowerShell-latest-win-x64.msi"
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i ""$env:USERPROFILE\Downloads\PowerShell-latest-win-x64.msi"" /quiet /norestart" -Wait
$PowerShellPath = "C:\Program Files\PowerShell\pwsh.exe"
$WindowsPowerShellPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$PathValue = [Environment]::GetEnvironmentVariable("Path", "Machine")
$PathValue = $PathValue -replace [regex]::Escape($WindowsPowerShellPath), $PowerShellPath
[Environment]::SetEnvironmentVariable("Path", $PathValue, "Machine")

#refresh env vars
Stop-Process -Name explorer