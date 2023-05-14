$logFile = "C:\program\logs\logname.log"

$cap = 2147483648 # 2GB

if ((Get-Item $logFile).length -gt $cap) {
    $timestamp = Get-Date -Format "ddMMyyyyHHmmss"
    $rotatedLog = "C:\program\logs\logname_$timestamp.log"
    Rename-Item $logFile $rotatedLog
    Start-Sleep -Seconds 5
    # sometimes programs regenerate their logs when they need to register a new entry so we wouldn't need to create one:
    $logFile = Get-ChildItem -Path "C:\program\logs" -Filter "logname.log" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($logFile -ne $null) {
        $logFile = $logFile.FullName
    } else {
        # uf the program doesn't generate a new log file we do so
        New-Item $logFile -ItemType File
    }
}
