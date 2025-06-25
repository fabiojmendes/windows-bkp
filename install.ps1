$install_path = Join-Path $env:windir System32\config\systemprofile\Scripts
Write-Host "Installing scripts to $install_path"

if (-not (Test-Path -Type Container -Path $install_path)) {
  New-Item -ItemType  Directory -Path $install_path
}

if (-not (Test-Path -Type Leaf -Path $install_path\config.ps1)) {
  Write-Host "First time installation, config file needs to be populated"
    try {
      Copy-Item -Path config.ps1 -Destination $install_path\config.ps1
    } catch {
      Write-Error "Create a copy of config.sample.ps1 named config.ps1 before continuing with the installation"
      exit 1
    }
}

Copy-Item -Path backup.ps1 -Destination $install_path

$backup_task_name = "BackupHome"
$backup_task = Get-ScheduledTask $backup_task_name -ErrorAction SilentlyContinue
if(-not ($backup_task)) {
  try {
    Register-ScheduledTask -TaskName $backup_task_name -Xml $(Get-Content BackupHome.xml | Out-String) 
  } catch {
    Write-Error "Setting up backup task schedule failed: $_"
  }
} else {
  Write-Warning "Backup task not scheduled: there is already a task with the name '$backup_task_name'."
}
