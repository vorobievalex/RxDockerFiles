param(
  [Parameter(Mandatory=$true)][String]$zipPackage
)

$extractFolder = ".\rxTmp\"

Expand-Archive -LiteralPath $zipPackage -DestinationPath $extractFolder -Force

Start-Process -wait ($extractFolder + "vcredist_x64_14_Ranorex\vcredist_x64.exe") -ArgumentList '/quiet', '/install'
Start-Process -wait ($extractFolder + "vcredist_x86_14_Ranorex\vcredist_x86.exe") -ArgumentList '/quiet', '/install'

$msi = Get-ChildItem -Path ($extractFolder + 'Ranorex-*msi')
Start-Process -wait msiexec -ArgumentList '/i', $msi, '/quiet', 'ADDLOCAL="MainFeature"'

Remove-Item $extractFolder -Force -Recurse
