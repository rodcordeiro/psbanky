function Get-BankyTransaction {
    <#
.SYNOPSIS
    Retrieves the last N transactions
.EXAMPLE
    Get-LastTransactions
.OUTPUTS
    [System.Object[]]
        Returns an array of transactions data.
.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [int]$limit=
    )
    begin {}
    process {
        $url = [URI]::EscapeUriString("$BANKY_API_URL/api/v1/transactions")

        $response = Invoke-Api $url -Method 'GET'
        [BankyTransaction[]]$items = $response.items
        foreach ($transaction in $items) {
            $transaction
        }
    }
}
