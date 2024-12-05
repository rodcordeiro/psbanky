function Get-LastTransaction {
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
    param ()
    begin {}

    process {
        $response = Invoke-Api 'http://82.180.136.148:3338/api/v1/transactions' -Method 'GET'
        [BankyTransaction[]]$items = $response.items
        foreach ($transaction in $items) {
            $transaction
        }
    }
}
