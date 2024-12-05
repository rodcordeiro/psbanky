function Get-BankyCategory {
    [CmdletBinding()]
    param ()


    process {
        [BankyCategory[]]$response = Invoke-Api 'http://82.180.136.148:3338/api/v1/categories' -Method 'GET'
        return $response
    }
}
