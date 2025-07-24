function Get-PaymentType {
    [CmdletBinding()]
    param()
    begin {
        $url = '/api/v1/payments';
    }
    process {
        $response = Invoke-Api $url -Method 'GET'
        return $response
    }
}
 