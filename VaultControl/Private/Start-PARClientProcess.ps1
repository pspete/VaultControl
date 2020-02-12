Function Start-PARClientProcess {

	<#
    .SYNOPSIS
	Starts PARClient process

    .DESCRIPTION
	Designed to receive PARClient process object from Invoke-PARClient.

	Returns Object containing ExitCode, StdOut & StdErr

	.PARAMETER Process
	System.Diagnostics.Process object containing PARClient parameters

    .EXAMPLE
	Start-PARClientProcess -Process $Process

	Invokes the Start method on the $Process object

    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding(SupportsShouldProcess)]
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSShouldProcess", "", Justification = "ShouldProcess handling is in Invoke-PARClient")]
	param(

		[Parameter(
			Mandatory = $True,
			ValueFromPipelineByPropertyName = $True
		)]
		[System.Diagnostics.Process]$Process
	)

	Begin {

	}

	Process {

		#Start Process
		$Process.start() | Out-Null

		#Read Output Stream First
		$StdOut = $Process.StandardOutput.ReadToEnd()
		$StdErr = $Process.StandardError.ReadToEnd()

		#If you wait for the process to exit before reading StandardOutput
		#the process can block trying to write to it, so the process never ends.
		$Process.WaitForExit()

		[PSCustomObject] @{

			"ExitCode" = $Process.ExitCode
			"StdOut"   = $StdOut
			"StdErr"   = $StdErr

		}

	}

	End {

		$Process.Dispose()

	}

}