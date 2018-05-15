Function Start-PARClientProcess {

	<#
    .SYNOPSIS
	Executes specified PARClient command and arguments

    .DESCRIPTION
	Designed to start PARClient process with arguments required for specific command.

	Returns Object containing ExitCode, StdOut & StdErr

	.PARAMETER PARClient
	The Path to PARClient.exe.
	Defaults to value of $Script:PAR.ClientPath, which is set during module import or via Set-PARConfiguration.

	.PARAMETER Server
	The name or address of the Vault server to target

	.PARAMETER Password
	SecureString of password used for PARClient operations

	.PARAMETER Credential
	A credential object containing the password used for PARClient operations

	.PARAMETER PassFile
	The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
	operations via PARClient

	.PARAMETER CommandParameters
	The PARClient command to execute

	.PARAMETER PAROptions
	Additional command parameters. By default specifies /Q /C and /StateFileName.
	StateFileName is set to a file named after the process ID of the script, and with the local temp directory path

	.PARAMETER RemainingArgs
	A catch all parameter, accepts any remaining values from pipeline.
	Intended to suppress errors when piping in an object.

    .EXAMPLE
	Invoke-PARClient -Server EPV1 -Password $SecureString -CommandParameters "GetParm Vault DebugLevel"

	Invokes the GetParm action against the Vault on EPV1 and returns the DebugLevel parameter value.

    .NOTES
    	AUTHOR: Pete Maan

    #>

	[CmdLetBinding()]
	param(

		[Parameter(
			Mandatory = $False,
			ValueFromPipelineByPropertyName = $True
		)]
		[ValidateScript( {Test-Path $_})]
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

		Write-Debug "Exit Code: $($Process.ExitCode)"

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