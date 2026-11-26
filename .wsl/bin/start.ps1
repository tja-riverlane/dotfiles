#!/usr/bin/env wsl-powershell

param($t)

if ($args.Count -eq 0) {
	Start-Process $t -Wait -PassThru | % ExitCode | % { exit $_ }
} else {
	Start-Process $t -ArgumentList $args -Wait -PassThru | % ExitCode | % { exit $_ }
}
