# windows-bkp

Powershell scripts to drive windows backups using robocopy

# Install

Create the installation folder if necessary

```powershell
$install_path = Join-Path $env:windir System32\config\systemprofile\Scripts
# Optional
mkdir $install_path
```

Download the latest version of the script

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fabiojmendes/windows-bkp/refs/heads/master/backup.ps1 `
    -OutputFile $install_path\backup.ps1
```

Download the sample configuration file if necessary

```powershell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/fabiojmendes/windows-bkp/refs/heads/master/config.sample.ps1 `
    -OutputFile $install_path\config.ps1
```

Edit the configuration file

```powershell
notepad $install_path\config.ps1
```

Create a new scheduled task by importing the BackupHome.xml template.
