Function Set-PARConfiguration {
	<#
	.SYNOPSIS
	Sets a variable in the script scope which holds default values for PARClient operations.
	Must be run prior to other module functions if path to PARClient has not been previously set.

	.DESCRIPTION
	Sets properties on an object which is set as the value of a variable in the script scope.
	The created variable can be queried and used by other module functions to provide default values.
	Creates a file in the logged on users home folder named PARConfiguration.xml. This file contains the variable
	used by the module, and will be imported with the module.

	.PARAMETER ClientPath
	The path to the PARClient.exe utility

	.PARAMETER Port
	The number of any custom port configured for use between PARClient & a vault

	.EXAMPLE
	Set-PARConfiguration -ClientPath D:\Path\To\PARClient.exe

	Sets default path to PARClient to D:\Path\To\PARClient.exe.
	This is accessed via the variable property $Script:PAR.ClientPath
	Creates C:\users\user\PARConfiguration.xml file to hold values for persistence.

	.EXAMPLE
	Set-PARConfiguration -ClientPath D:\Path\To\PARClient.exe -Port 9023

	Sets default path to PARClient to D:\Path\To\PARClient.exe.
	This is accessed via the variable property $Script:PAR.ClientPath
	Sets default PARClient port to 9023
	This is accessed via the variable property $Script:PAR.Port
	Creates C:\users\user\PARConfiguration.xml file to hold values for persistence.
	#>
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