function Invoke-Authentication {
    <#
.SYNOPSIS
    Authenticate to Banky services
.DESCRIPTION
    This function authenticates to Banky services and save the token to environment
.PARAMETER username
    The username to authenticate
.PARAMETER password
    The password secure string to be used
.EXAMPLE
    Invoke-Authentication -username Teste -password Teste
    Authenticate to banky with test user
.INPUTS
    [System.string] username
        The username to authenticate
    [System.SecureString] password
        The password secure string to be used
.NOTES
    Version: 1.0
#>
    [CmdletBinding( )]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)][string]$username,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName)][SecureString]$password
    )
    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }
    process {

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $url = [URI]::EscapeUriString("$BANKY_API_URL/api/v1/auth/login")



        $body = @"
{
 `"username`": `"$($username)`",
 `"password`": `"$(Unprotect-SecureString $password)`"
}
"@
        $response = Invoke-RestMethod $url -Method 'POST' -Headers $headers -Body $body
        New-StoredCredential -Target "BANKY" -UserName $Cred.username -Password $Cred.GetNetworkCredential().password -Persist LocalMachine

        $script:BANKY_AUTH_TOKEN = $response.accessToken
        $env:BANKY_AUTH_TOKEN = $response.accessToken
    }
}
