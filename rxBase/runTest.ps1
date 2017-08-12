function Invoke-Command() {
    param ( [string]$program = $(throw "Please specify a program" ),
            [string]$argumentString = "")

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $program
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $argumentString

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    Write-Host "exit code: " + $p.ExitCode
}


# Remove arguments affecting the report to ensure the report
# file is always placed in the correct folder
$remainingArgs = @()
foreach ($arg in $args) 
{
	$rfMatch         = ($arg -match "/rf:\w+")
	$reportfileMatch = ($arg -match "/reportfile:\w+")

    If(!($rfMatch -Or $reportfileMatch))
    {
        $remainingArgs += $arg
    }
}

Invoke-Command  C:\rxTestFiles\test.exe "/hideprogressdialog /rf:C:\reports\report.html /zrf:C:\reports\report.rxzlog $args"
