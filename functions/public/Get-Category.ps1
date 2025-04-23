function Get-Category {
    [CmdletBinding()]
    param ()
    process {
        $url = '/api/v1/categories';
        $response = Invoke-Api $url -Method 'GET'
        return $response
    }
}
