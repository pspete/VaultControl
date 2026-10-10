# .ExternalHelp VaultControl-help.xml
Function Set-PARConfiguration {
	[CmdletBinding(SupportsShouldProcess)]
	Param(
		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateScript( {Test-Path $_ -PathType Leaf})]
		[ValidateNotNullOrEmpty()]
		[string]$ClientPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[int]$Port
	)

	Begin {

		$Defaults = [pscustomobject]@{}

	}

	Process {

		If($PSBoundParameters.Keys -contains "ClientPath") {

			$Defaults | Add-Member -MemberType NoteProperty -Name ClientPath -Value $ClientPath

		}

		If($PSBoundParameters.Keys -contains "Port") {

			$Defaults | Add-Member -MemberType NoteProperty -Name Port -Value $Port

		}

	}

	End {

		Set-Variable -Name PAR -Value $Defaults -Scope Script

		$Script:PAR | Select-Object -Property * | Export-Clixml -Path "$env:HOMEDRIVE$env:HomePath\PARConfiguration.xml" -Force

	}

}