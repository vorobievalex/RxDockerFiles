function Invoke-Command() {
    param ( [string]$program = $(throw "Please specify a program" ),
            [string]$argumentString = "")

    Write-Host "Running $($program) with arguments $($argumentString)"

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
        $rfMatch         = ($arg -match "/(z)?rf:\w+")
        $reportfileMatch = ($arg -match "/(zipped)?reportfile:\w+")

    If(!($rfMatch -Or $reportfileMatch))
    {
        $remainingArgs += $arg
    }
}

Set-PSDebug -Trace 1
dir C:\rxTestFiles\
Write-Host "$($args)"
Invoke-Command  "C:\rxTestFiles\$($args[0])" "/hideprogressdialog /ju /rf:C:\report\report.html /zr /zrf:C:\report\report.rxzlog $($args[1 .. -1])"
