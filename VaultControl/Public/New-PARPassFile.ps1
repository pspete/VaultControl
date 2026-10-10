# .ExternalHelp VaultControl-help.xml
Function New-PARPassFile {
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
