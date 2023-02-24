#script is set up to perform a complete MSSQL removal from registry executing every MsiExec.exe entry related to the program

$key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
$folderPath = 'C:\install\reg_temp'

#deletes folder and files if they already exist preventing errors
if (Test-Path $folderPath) {
    Remove-Item $folderPath -Force  -Recurse -ErrorAction SilentlyContinue
}

#fetch subkey data into object
$installs = Get-ChildItem -Path $key
$uninstallResults = foreach ($singleInstall in $installs)
    {
    $Properties = $singleInstall | Get-ItemProperty 
    [PSCustomobject]@{
        Displayname = $Properties.displayname
        #Version     = $Properties.displayversion
        #Publisher   = $Properties.publisher
        Uninstall   = $Properties.UninstallString
        }
    }

#dump subkey values line by line into a text file
New-Item $folderPath -itemType Directory
$uninstallResults | Where-Object Uninstall -match 'MsiExec.exe' | Where-Object DisplayName -match 'SQL' >> $folderPath\regValues.txt

#clean the text file 
(Get-Content $folderPath\regValues.txt | Where-Object {$_.readcount -lt 1 -or $_.readcount -gt 3}) | Set-Content $folderPath\regValues.txt
(Get-Content $folderPath\regValues.txt) -replace ".+.exe ","" | Set-Content $folderPath\regValues.txt

#run script with the values taken out of the registry
$file = (Get-ChildItem $folderPath\regValues.txt).Argument
foreach ($argument in $file) {
    $process = Start-Process MsiExec.exe -ArgumentList "$argument" -Wait
    Invoke-Expression $process
    if ($process.exitCode -ne 0) {
        $process >> $folderPath\regValuesRetry.txt
    }
}

#runs the script again with the values taken out of the registry that couldn't be uninstalled because they required for some packages to be uninstalled before)
$file = (Get-ChildItem $folderPath\regValuesRetry.txt).Argument
foreach ($argument in $file) {
    $process = Start-Process MsiExec.exe -ArgumentList "$argument" -Wait
}

#delete script files
Remove-Item $folderPath -Force  -Recurse -ErrorAction SilentlyContinue
