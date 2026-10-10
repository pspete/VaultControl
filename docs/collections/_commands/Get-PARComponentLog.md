---
external help file: VaultControl-help.xml
Module Name: VaultControl
online version:
schema: 2.0.0
title: Get-PARComponentLog
---

# Get-PARComponentLog

## SYNOPSIS
Returns events from remote component log.

## SYNTAX

### Password
```
Get-PARComponentLog -Server <String> -Password <SecureString> -Component <String> [-LogFile <String>]
 [-TimeFrom <DateTime>] [-Lines <Int32>] [<CommonParameters>]
```

### Credential
```
Get-PARComponentLog -Server <String> -Credential <PSCredential> -Component <String> [-LogFile <String>]
 [-TimeFrom <DateTime>] [-Lines <Int32>] [<CommonParameters>]
```

### PassFile
```
Get-PARComponentLog -Server <String> -PassFile <String> -Component <String> [-LogFile <String>]
 [-TimeFrom <DateTime>] [-Lines <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Gets events from logs for remote Vault, PADR, CVM or ENE.

## EXAMPLES

### EXAMPLE 1
```
Get-PARComponentLog -Server EPV1 -Password $SecureString -Component Vault -TimeFrom (Get-Date).AddDays(-1)
```

Show events from the ITALOG file on Vault EPV1 from the last 24 hours

### EXAMPLE 2
```
Get-PARComponentLog -Server EPV1 -Password $SecureString -Component ENE -LogFile Trace
```

Show events from the ENE Trace log on vault EPV1

### EXAMPLE 3
```
Get-PARComponentLog -Server EPV1 -Password $SecureString -Component Vault -Lines 10
```

Show the last 10 lines of the ITALOG file on vault EPV1

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
Vault, PADR, CVM or ENE are the accepted values

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

### -LogFile
For ENE & CVM Logs, the log file to return must be specified.
Accepted values are "Console" or "Trace"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Console
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -TimeFrom
For Vault or PADR log queries, optionally provide a datetime from which to return the logs from.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Lines
For Vault log queries, optionally provide the number of log lines to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
