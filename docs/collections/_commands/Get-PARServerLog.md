---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARServerLog
---

# Get-PARServerLog

## SYNOPSIS
Returns events from Server Event Logs

## SYNTAX

### Password
```
Get-PARServerLog -Server <String> -Password <SecureString> -LogName <String> [-TimeFrom <DateTime>]
 [<CommonParameters>]
```

### Credential
```
Get-PARServerLog -Server <String> -Credential <PSCredential> -LogName <String> [-TimeFrom <DateTime>]
 [<CommonParameters>]
```

### PassFile
```
Get-PARServerLog -Server <String> -PassFile <String> -LogName <String> [-TimeFrom <DateTime>]
 [<CommonParameters>]
```

## DESCRIPTION
Queries remote vault server and returns events from specified OS Logs.

## EXAMPLES

### EXAMPLE 1
```
Get-PARServerLog -Server EPV1 -Credential $Cred -LogName Application
```

Get events logged in the last 24 hours from Application log on vault EPV1

### EXAMPLE 2
```
Get-PARServerLog -Server zEPV1 -Credential $Cred -LogName System -TimeFrom (Get-Date 5/5/2018)
```

Get all events from the System log since Cinco de Mayo 2018 on vault EPV1

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

### -LogName
The name of the event log to return events from.
Application, Security & System are the accepted values.

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

### -TimeFrom
A date time to return events from.
Defaults to 24 hours before the current time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
