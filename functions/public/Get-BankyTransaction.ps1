function Get-BankyTransaction {
    <#
.SYNOPSIS
    Retrieves the last N transactions
.EXAMPLE
    Get-LastTransactions
.PARAMETER limit
    Limits the amount of returning rows
.PARAMETER page
    filters the *n* page based on the limit of rows returned
.PARAMETER category
    filter transactions by category
.OUTPUTS
    [System.Object[]]
        Returns an array of transactions data.
.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [int]$limit = 10,
        [Parameter(Mandatory = $false, ValueFromPipeline)]
        [int]$page = 1,
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]
        [ValidatePattern("^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$")]
        [string]$category
    )
    begin {}
    process {
        $url = "/api/v1/transactions?page=$page&limit=$limit"

        if ([String]::IsNullOrEmpty($category) -eq $false) {
            $url += "&category=$category"
        }

        $response = Invoke-Api $url -Method 'GET'
        [BankyTransaction[]]$items = $response.items
        foreach ($transaction in $items) {
            $transaction
        }
    }
}
