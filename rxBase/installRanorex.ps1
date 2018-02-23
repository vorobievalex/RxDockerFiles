param(
  [Parameter(Mandatory=$true)][String]$zipPackage
)

$extractFolder = ".\rxTmp\"
Expand-Archive -LiteralPath $zipPackage -DestinationPath $extractFolder -Force

# Install dependencies
#######################

$Packages = 'vcredist2008','vcredist2010','vcredist2013'

ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

# Install Ranorex
#######################

Write-Host "Installing Ranorex..."
$msi = Get-ChildItem -Path ($extractFolder + 'Ranorex-*msi')
Start-Process -wait msiexec -ArgumentList '/i', $msi, '/quiet', 'ADDLOCAL="MainFeature"'

Remove-Item $extractFolder -Force -Recurse
