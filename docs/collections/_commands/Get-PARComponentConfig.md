---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARComponentConfig
---

# Get-PARComponentConfig

## SYNOPSIS
Gets values set in component configuration files

## SYNTAX

### Password
```
Get-PARComponentConfig -Server <String> -Password <SecureString> -Component <String> -Parameter <String>
 [<CommonParameters>]
```

### Credential
```
Get-PARComponentConfig -Server <String> -Credential <PSCredential> -Component <String> -Parameter <String>
 [<CommonParameters>]
```

### PassFile
```
Get-PARComponentConfig -Server <String> -PassFile <String> -Component <String> -Parameter <String>
 [<CommonParameters>]
```

## DESCRIPTION
Queries remote vault server for values contained in component configuration files DBPARM.ini or PADR.ini.

## EXAMPLES

### EXAMPLE 1
```
Get-PARComponentConfig -Server EPV1 -Credential $credential -Component Vault -Parameter DebugLevel
```

Returns the DebugLevel parameter value configured in the dbparm.ini file on vault server EPV1

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

### -Parameter
The name of the Parameter to get the value of.
For Vault Components, the valid parameter names are:
"DefaultTimeout", "MTU", "SecurityNotification", "DebugLevel", "DisableExceptionHandling"
For Disaster Recovery Components, the valid parameter names are:
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
