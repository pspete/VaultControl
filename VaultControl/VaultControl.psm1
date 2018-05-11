<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS

.NOTES

.LINK

#>
[CmdletBinding()]
param()

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include "*.ps1" |

ForEach-Object {

	Try {

		#Dot Source each file
		. $_.fullname

	}

	Catch {

		Write-Error "Failed to import function $($_.fullname)"

	}


}

#Read config and make available in script scope
If(Test-Path "$env:HOMEDRIVE$env:HomePath\PARConfiguration.xml") {
	$config = Import-Clixml -Path "$env:HOMEDRIVE$env:HomePath\PARConfiguration.xml"
	Set-Variable -Name PAR -Value $config -Scope Script
}