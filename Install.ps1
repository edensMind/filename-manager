$mod_paths = $env:PSModulePath
$mod_path  = $mod_paths.Split(";")[2]
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

Copy-Item -Recurse -Path $ScriptPath -Destination $mod_path -Force

Remove-Module PhotoScripts
Import-Module PhotoScripts

# Add Suffix to all files in path 
Add-Suffix -Path "C:\Users\Eden\Desktop\New folder (2)" -Suffix "_2000x2000"
Remove-Suffix -Path "C:\Users\Eden\Desktop\New folder (2)" -Suffix "_2000x2000"