---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: New-PARPassFile
---

# New-PARPassFile

## SYNOPSIS
Creates a PARClient password file

## SYNTAX

```
New-PARPassFile [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Runs PARClient.exe /CreatePassFile to create a file containing an encrypted password, for use with the
PassFile parameter of other module functions.
PARClient prompts for the password interactively in the console; the password cannot be supplied as a
parameter.
PARClient prompts again until the new and confirmed passwords match.
The password is not validated against any vault when the file is created.
An existing file at the specified path is overwritten.
The created file is only valid on the computer on which it was created.
The parent folder of the file is created if it does not exist.

## EXAMPLES

### EXAMPLE 1
```
New-PARPassFile -Path C:\PARClient\vault.pass
```

Prompts for a password and creates encrypted password file C:\PARClient\vault.pass.

### EXAMPLE 2
```
New-PARPassFile -Path C:\PARClient\vault.pass
Get-PARComponent -Server EPV1 -PassFile C:\PARClient\vault.pass -Component Vault
```

Creates a password file, then uses it to get the status of the Vault component on EPV1.

## PARAMETERS

### -Path
The path of the password file to create

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
