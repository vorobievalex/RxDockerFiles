param(
  [Parameter(Mandatory=$true)][String]$zipPackage
)


function installVCRedist()
{
  param ( [string]$exe = $(throw "Specify the vcredist exe" ))
  Write-Host "Installing: " $exe
  Start-Process -Wait ($exe) -ArgumentList '/quiet', '/install'
}

$extractFolder = ".\rxTmp\"

Expand-Archive -LiteralPath $zipPackage -DestinationPath $extractFolder -Force


# Install dependencies
#######################

#$vcredistPattern = $extractFolder + "vcredist*\*.exe"
#$vcredistInstallers = Get-ChildItem $vcredistPattern -Recurse | Select-Object FullName

#$vcredistInstallers | ForEach-Object {installVCRedist($($_.FullName))}


#.\installChoco.ps1

$Packages = 'vcredist2008','vcredist2010','vcredist2013'

ForEach ($PackageName in $Packages)
{choco install $PackageName -y}

# Install Ranorex
#######################

Write-Host "Installing Ranorex..."
$msi = Get-ChildItem -Path ($extractFolder + 'Ranorex-*msi')
Start-Process -wait msiexec -ArgumentList '/i', $msi, '/quiet', 'ADDLOCAL="MainFeature"'

Remove-Item $extractFolder -Force -Recurse
