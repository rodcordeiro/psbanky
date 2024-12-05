function Get-BankyAccount {
    [CmdletBinding()]
    param ()

    process {
        [BankyAccount[]]$response = Invoke-Api 'http://82.180.136.148:3338/api/v1/accounts' -Method 'GET'
        return $response
    }
}
