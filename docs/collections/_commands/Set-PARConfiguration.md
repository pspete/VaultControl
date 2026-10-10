---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Set-PARConfiguration
---

# Set-PARConfiguration

## SYNOPSIS
Sets a variable in the script scope which holds default values for PARClient operations.
Must be run prior to other module functions if path to PARClient has not been previously set.

## SYNTAX

```
Set-PARConfiguration [[-ClientPath] <String>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets properties on an object which is set as the value of a variable in the script scope.
The created variable can be queried and used by other module functions to provide default values.
Creates a file in the logged on users home folder named PARConfiguration.xml.
This file contains the variable
used by the module, and will be imported with the module.

## EXAMPLES

### EXAMPLE 1
```
Set-PARConfiguration -ClientPath D:\Path\To\PARClient.exe
```

Sets default path to PARClient to D:\Path\To\PARClient.exe.
This is accessed via the variable property $Script:PAR.ClientPath
Creates C:\users\user\PARConfiguration.xml file to hold values for persistence.

### EXAMPLE 2
```
Set-PARConfiguration -ClientPath D:\Path\To\PARClient.exe -Port 9023
```

Sets default path to PARClient to D:\Path\To\PARClient.exe.
This is accessed via the variable property $Script:PAR.ClientPath
Sets default PARClient port to 9023
This is accessed via the variable property $Script:PAR.Port
Creates C:\users\user\PARConfiguration.xml file to hold values for persistence.

## PARAMETERS

### -ClientPath
The path to the PARClient.exe utility

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Port
The number of any custom port configured for use between PARClient & a vault

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
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
