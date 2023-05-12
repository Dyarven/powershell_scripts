$logfile = "C:\path\to\log\file.log"

if(Test-Path $logfile) {
    Get-Content $logfile -Wait
} else {
    Write-Host "O arquivo '$logFilePath' non existe."
}
