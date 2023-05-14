$logFile = "C:\program\logs\logname.log"
$cap = 2147483648 # 2GB

if ((Get-Item $logFile).length -gt $cap) {
    $timestamp = Get-Date -Format "ddMMyyyyHHmmss"
    $rotatedLog = "C:\program\logs\rotated_logname_$timestamp.log"
    Rename-Item $logFile $rotatedLog
    Start-Sleep -Seconds 5
    # if the program doesn't generate a new log file we do so
    $logFile = Get-ChildItem -Path "C:\program\logs" -Filter "logname.log" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($logFile -ne $null) {
        $logFile = $logFile.FullName
    } else {
        New-Item $logFile -ItemType File
    }
}
