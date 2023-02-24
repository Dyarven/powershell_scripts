Import-Module ActiveDirectory

#Define the Domain Controller
$dc = "Sample"

#searchbase specifies to Get-ADComputer where to start. In this case it will look inside the OU=Desktops, which is inside the OU=Devices, in the domain Sample.whatever.com
#If you are checking for devices inside the default Computers OU, you could omit using searchbase and just specify the domain within a variable. Then look for $device.$domain using the Get-ADComputer cmdlet.
$ou = "OU=Desktops,OU=Devices,DC=Sample,DC=whatever,DC=com"

#csv file needs 2 columns: oldDevice and newDevice
$file = "dispositivos.csv"
$devices = Import-Csv $file

$total = $devices.Count
$counter = 0

Write-Progress -Activity "Actualizando información de dispositivos en Active Directory" -Status "Progreso" -PercentComplete 0

foreach ($device in $devices) {
    $device1 = Get-ADComputer -Filter {Name -eq $device.oldDevice} -Properties Description, Location -Server $dc -SearchBase $ou -ErrorAction SilentlyContinue
    $device2 = Get-ADComputer -Filter {Name -eq $device.newDevice} -Properties Description, Location -Server $dc -SearchBase $ou -ErrorAction SilentlyContinue

    if (!$device1) {
        Write-Host "Dispositivo '$($device.oldDevice)' no encontrado en AD."
        continue
    }

    if (!$device2) {
        Write-Host "Dispositivo '$($device.newDevice)' no encontrado en AD."
        continue
    }

    Set-ADComputer -Identity $device2 -Location $device1.Location -Description $device1.Description
    Set-ADComputer -Identity $device1 -Clear Location,Description

    $counter++
    $percentComplete = [int](($counter / $total) * 100)
    Write-Progress -Activity "Actualizando información de dispositivos en Active Directory" -Status "Progreso" -PercentComplete $percentComplete
}

Write-Progress -Activity "Actualizando información de dispositivos en Active Directory" -Status "Progreso" -Completed
Write-Host "Información actualizada correctamente."