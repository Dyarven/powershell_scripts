Import-Module ActiveDirectory

$deviceName = Read-Host "Introduce un dispositivo"
$ou = "OU=Desktops,OU=Devices,DC=Sample,DC=whatever,DC=com"
$dc = "Sample"

try {
    $device = Get-ADComputer -Filter {Name -eq $deviceName} -Properties Description, Location -Server $dc -SearchBase $ou -ErrorAction Stop
    if ($device) {
        Write-Host "Location: $($device.Location)"
        Write-Host "Description: $($device.Description)"
    }
    else {
        Write-Host "Dispositivo '$deviceName' no encontrado en el AD"
    }
}
catch {
    Write-Host "Error buscando dispositivo: $($_.Exception.Message)"
}