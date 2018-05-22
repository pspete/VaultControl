# VaultControl

[![Build status](https://ci.appveyor.com/api/projects/status/svnyleaaupspfk1q/branch/master?svg=true)](https://ci.appveyor.com/project/pspete/vaultcontrol/branch/master)
[![AppVeyor tests](https://img.shields.io/appveyor/tests/pspete/vaultcontrol.svg)](https://ci.appveyor.com/project/pspete/vaultcontrol)
[![Coverage Status](https://coveralls.io/repos/github/pspete/VaultControl/badge.svg)](https://coveralls.io/github/pspete/VaultControl)
[![license](https://img.shields.io/github/license/pspete/vaultcontrol.svg)](https://github.com/pspete/VaultControl/blob/master/LICENSE.md)

Invoke CyberArk PARClient.exe Utility with PowerShell

**A work in progress - changes probable prior to a Version 1.0 release**

Feedback, Issues and Pull Requests are more than welcome.

## Getting Started

- `import-module VaultControl`
- Run `Set-PARConfiguration` to set the path to the `PARClient.exe` utility and any non-default port used for PARClient operations.

### List of Commands

- `Get-PARServer` - Gets resource and component information from a vault
- `Get-PARComponent` - Gets vault component status
- `Get-PARComponentLog` - Gets component log content
- `Get-PARComponentConfig` - Gets DBParm/PADR parameter values
- `Get-PARServerLog` - Gets OS event logs from vault server
- `Get-PARService` - Gets status of monitored Operating System services
- `Restart-PARComponent` - Restarts CyberArk Vault/PADR/ENE/CVM component
- `Restart-PARServer` - Initiates reboot of Vault server
- `Set-PARComponentConfig` - Updates DBParm/PADR parameter values
- `Start-PARComponent` - Starts CyberArk Vault/PADR/ENE/CVM component
- `Stop-PARComponent` - Stops CyberArk Vault/PADR/ENE/CVM component
- `Set-PARConfiguration` - Sets default values for path to PARClient.exe & PARClient Port

## Installation

### Prerequisites

- Requires Powershell v3 (minimum)
- CyberArk PARClient.exe utility
- CyberArk Vault/PADR/ENE

### Install Options

This repository contains a folder named ```VaultControl```.

The folder needs to be copied to one of your PowerShell Module Directories.

#### Manual Install

Find your PowerShell Module Paths with the following command:

```powershell

$env:PSModulePath.split(';')

```

[Download the ```master``` branch](https://github.com/pspete/VaultControl/archive/master.zip)

Extract the archive

Copy the ```VaultControl``` folder to your "Powershell Modules" directory of choice.
