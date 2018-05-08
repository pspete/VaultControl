Function Set-PARConfiguration {
	<#

	#>
	[CmdletBinding(SupportsShouldProcess)]
	Param(
		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateScript( {Test-Path $_})]
		[ValidateNotNullOrEmpty()]
		[string]$ClientPath,

		[Parameter(
			Mandatory = $false,
			ValueFromPipelineByPropertyName = $true
		)]
		[ValidateNotNullOrEmpty()]
		[int]$Port
	)

	$Defaults = [pscustomobject]@{}

	If($PSBoundParameters.Keys -contains "ClientPath") {

		$Defaults | Add-Member -MemberType NoteProperty -Name ClientPath -Value $ClientPath

	}

	If($PSBoundParameters.Keys -contains "Port") {

		$Defaults | Add-Member -MemberType NoteProperty -Name Port -Value $Port

	}

	Set-Variable -Name PAR -Value $Defaults -Scope Script

	$Script:PAR | Select-Object -Property * | Export-Clixml -Path "$env:HOMEDRIVE$env:HomePath\PARConfiguration.xml" -force

}