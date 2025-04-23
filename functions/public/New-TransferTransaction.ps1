# "description",
# "origin",
# "destiny",
# "date",
# "value"
function New-TransferTransaction {
    param(
        # Origin account of the transfer
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        # [ValidatePattern("^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$")]
        [string]
        $Origin,
        # Destiny account of the transfer
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        # [ValidatePattern("^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$")]
        [string]
        $Destiny,
        # Description of the transfer
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [string]
        $Description,
        # Value of the transfer
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [decimal]
        $Value,
        # Date of the transfer
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [AllowNull()]
        [datetime]
        $Date
    )
    begin {
        $url = "/api/v1/transactions/transfer"
    }
    process {
        if ($null -ne $PSItem) {
            $Origin = $PSItem.Origin
            $Destiny = $PSItem.Destiny
            $Description = $PSItem.Description
            $Value = $PSItem.Value
            if ($null -ne $PSItem.date) {
                $Date = $PSItem.Date
            }
        }

        if (-not [guid]::TryParse($Origin, [ref]([guid]::Empty))) { throw "Origin is not a valid guid" }
        if (-not [guid]::TryParse($Destiny, [ref]([guid]::Empty))) { throw "Destiny is not a valid guid" }
        if ([String]::IsNullOrEmpty($Description)) { throw "Description must be passed" }
        $transaction = [CreateBankyTransferTransaction]::new()
        $transaction.Origin = $Origin
        $transaction.Destiny = $Destiny
        $transaction.Description = $Description
        $transaction.Value = $Value
        $transaction.Date = if ($date) { get-date -Format 'yyyy-MM-ddTHH:mm:ss' -Date $date } else { get-date -Format 'yyyy-MM-ddTHH:mm:ss' }

        $body = $transaction | Remove-Null | ConvertTo-Json -Depth 1

        $response = Invoke-Api $url -Method 'POST'  -Body $body
        $response
    }
}