---
external help file: psbanky-help.xml
Module Name: psbanky
online version:
schema: 2.0.0
---

# Get-BankyTransaction

## SYNOPSIS
Retrieves the last N transactions

## SYNTAX

```
Get-BankyTransaction [[-limit] <Int32>] [[-page] <Int32>] [[-category] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXEMPLO 1
```
Get-LastTransactions
```

## PARAMETERS

### -limit
Limits the amount of returning rows

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 10
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -page
filters the *n* page based on the limit of rows returned

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 1
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -category
filter transactions by category

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Object[]]
###     Returns an array of transactions data.
## NOTES
Version: 1.0

## RELATED LINKS
