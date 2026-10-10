---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Set-PARComponentConfig
---

# Set-PARComponentConfig

## SYNOPSIS
Sets values set in component configuration files

## SYNTAX

### Password
```
Set-PARComponentConfig -Server <String> -Password <SecureString> -Component <String> -Parameter <String>
 -Value <String> -Mode <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Credential
```
Set-PARComponentConfig -Server <String> -Credential <PSCredential> -Component <String> -Parameter <String>
 -Value <String> -Mode <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PassFile
```
Set-PARComponentConfig -Server <String> -Component <String> -PassFile <String> -Parameter <String>
 -Value <String> -Mode <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets values contained in component configuration files DBPARM.ini or PADR.ini on remote vault server.

## EXAMPLES

### EXAMPLE 1
```
Set-PARComponentConfig -Server EPV1 -Credential $credential -Component Vault -Parameter DefaultTimeout -Value 300
```

## PARAMETERS

### -Server
The name or address of the remote Vault server to target with PARClient

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Password
The password for remote operations via PARClient as a secure string

```yaml
Type: SecureString
Parameter Sets: Password
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
The password for remote operations via PARClient held in a credential object

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Component
The name of the component to query.
Vault or PADR are the accepted values

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PassFile
The path to a "password" file created by PARClient.exe, containing the encrypted password value used for remote
operations via PARClient

```yaml
Type: String
Parameter Sets: PassFile
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Parameter
The name of the Parameter to set the value for.
For Vault Components, valid parameter names are:
"DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling"
For Disaster Recovery Components, valid parameter names are:
"EnableCheck", "EnableReplicate", "EnableFailover", "EnableDBSync", "FailoverMode"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Value
The value to set for the parameter in the configuration file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Mode
Specify how or when the paramater value change will take effect.
For Vault parameter value changes "Temporary", "Permanent" or "Immediate" modes can be specified.

For Disaster Recovery  parameter value changes only "Permanent" mode can be specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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
