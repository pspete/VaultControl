Function New-PARPassFile {
	<#
	.SYNOPSIS
	Creates a PARClient password file

	.DESCRIPTION
	Runs PARClient.exe /CreatePassFile to create a file containing an encrypted password, for use with the
	PassFile parameter of other module functions.
	PARClient prompts for the password interactively in the console; the password cannot be supplied as a
	parameter. PARClient prompts again until the new and confirmed passwords match.
	The password is not validated against any vault when the file is created.
	An existing file at the specified path is overwritten.
	The created file is only valid on the computer on which it was created.
	The parent folder of the file is created if it does not exist.

	.PARAMETER Path
	The path of the password file to create

	.EXAMPLE
	New-PARPassFile -Path C:\PARClient\vault.pass

	Prompts for a password and creates encrypted password file C:\PARClient\vault.pass.

	.EXAMPLE
	New-PARPassFile -Path C:\PARClient\vault.pass
	Get-PARComponent -Server EPV1 -PassFile C:\PARClient\vault.pass -Component Vault

	Creates a password file, then uses it to get the status of the Vault component on EPV1.
	#>
	[CmdletBinding(SupportsShouldProcess)]
	Param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)

	Begin {

		If(-not $Script:PAR.ClientPath) {

			throw "PARClient.exe not found `nRun Set-PARConfiguration to set path to PARClient"

		}

	}

	Process {

		$FilePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

		$Folder = Split-Path -Path $FilePath -Parent

		If($PSCmdlet.ShouldProcess($FilePath, "Create PARClient Password File")) {

			If(-not (Test-Path -Path $Folder -PathType Container)) {

				$null = New-Item -Path $Folder -ItemType Directory -Force

			}

			$Process = Start-Process -FilePath $Script:PAR.ClientPath -ArgumentList "/CreatePassFile `"$FilePath`"" `
				-WorkingDirectory (Split-Path -Path $Script:PAR.ClientPath -Parent) -NoNewWindow -Wait -PassThru

			If(($Process.ExitCode -eq 0) -and (Test-Path -Path $FilePath -PathType Leaf)) {

				Get-Item -Path $FilePath

			} Else {

				Write-Error -Message "Failed to create password file $FilePath (Exit Code: $($Process.ExitCode))" -ErrorId "PassFileNotCreated"

			}

		}

	}

}
