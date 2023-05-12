$logfile = "C:\folderx\foldery\file.log"

if(Test-Path $logfile) {
    Get-Content $logfile -Wait
} else {
    Write-Host "O arquivo '$logfile' non existe."
}
