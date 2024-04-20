# this script looks for devices that meet the criteria of location and name and lists them to the user so he can delete their locations so they are not displayed on certain apps that work with LDAP.

Import-Module ActiveDirectory

# define the Domain Controller
$dc = "Sample"

# define where to start searching (Get-ADComputer defaults to OU=computers)
$ou = "OU=Desktops,OU=Devices,DC=Sample,DC=whatever,DC=com"

function UpdateDeviceInAD {
    $location = Read-Host "Enter the device location (2 to 5 digits): "
    $fixedLocation = '*' + $location.PadLeft(5, '0') + '*'

    # search for devices that match the location and have a name starting with D
    $devices = Get-ADComputer -Filter {Location -like $fixedLocation -and Name -like "D*"} -Properties Description, Location -Server $dc -SearchBase $ou -ErrorAction SilentlyContinue

    if (!$devices) {
        Write-Host "Ningún dispositivo encontrado con Location '$location'"
        return
    }

    # displays the list of devices
    Write-Host "Dispositivos encontrados:"
    $index = 1
    foreach ($device in $devices) {
        Write-Host "$index. Name: $($device.Name)"
        Write-Host "   Location: $($device.Location)"
        Write-Host "   Description: $($device.Description)"
        Write-Host "--------------------------------------------------------------------------"
        $index++
    }

    # ask the user which devices to delete
    $deviceNumbers = Read-Host "Introduce los dispositivos a los que quieres borrarles el Location, separados por comas (ej. 1,4,5): "
    $deviceNumbers = $deviceNumbers -split ','

    # delete the selected devices
    foreach ($deviceNumber in $deviceNumbers) {
        $device = $devices[$deviceNumber - 1]
        Write-Host "Borrando Location en el dispositivo antiguo: '$($device.Name)'..."
        Set-ADComputer -Identity '$device' -Clear Location
        Write-Host "Location borrado con éxito"
    }
}

while ($true) {
    $devices = $null
    UpdateDeviceInAD
    $continue = Read-Host "Quieres realizar otra búsqueda? (S/N): "
    if ($continue -eq "N") {
        break
    }
}
