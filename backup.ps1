param (
  [switch]$debug
)

if ($debug) {
  Start-Transcript -path $env:TEMP\backup_script.log
}

Write-Host "Script root: $PSScriptRoot, profile: $env:UserProfile"

try {
  . "$PSScriptRoot\config.ps1"
} catch {
  Write-Error "Config file not found"
  exit 1
}

if (!$Source -or !$Destination -or !$BackupBase) {
  Write-Error "Mandatory fields are missing! Review your config
    Source: $Source
    Destination: $Destination
    BackupBase: $BackupBase"
  exit 1
}

Write-Host "Connecting to the network share $Destination"
net use $Destination /user:$ShareUsername $SharePassword

Write-Host "Backing up $Source to $Destination\$BackupBase"

robocopy $Source "$Destination\$BackupBase" `
  /mir /zb /fft /xj /r:5 /mt /np `
  /log:$env:TEMP\backup.log `
  /xd $Source\AppData `
  /xd $Source\OneDrive `
  /xf "ntuser.*"

$ExitCode = $LastExitCode

Write-Host "robocopy returned $LastExitCode"
$status = if ($LastExitCode -le 3) { "up" } else { "down" }
$msg = "Return=$LastExitCode"

$pushURL = "https://uptime.juzam.pro/api/push/${MonitorId}?status=${status}&msg=${msg}"
$res = Invoke-WebRequest -UseBasicParsing -Uri $pushURL
Write-Host $res

if ($debug) {
  Stop-Transcript
}

robocopy $env:TEMP $Destination\${BackupBase}-logs backup*.log /r:1 | Out-Null
