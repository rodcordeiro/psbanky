function New-BankyAuthentication {
    <#
.SYNOPSIS
    Authenticate to banky
.DESCRIPTION
    This function authenticates to banky generating the banky file
.PARAMETER username
    The username to authenticate
.PARAMETER password
    The password secure string to be used
.EXAMPLE
    New-BankyAuthentication -username Teste -password Teste
    Authenticate to banky with test user
.INPUTS
    [System.string] username
        The username to authenticate
    [System.SecureString] password
        The password secure string to be used
.NOTES
    Version: 1.0
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][string]$username,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)][SecureString]$password
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

        $body = @"
{
`"username`": `"$($username)`",
`"password`": `"$(Unprotect-SecureString $password)`"
}
"@

        [BankyAuthenticationResponse]$response = Invoke-RestMethod 'http://82.180.136.148:3338/api/v1/auth/login' -Method 'POST' -Headers $headers -Body $body
        $response.GetExpirationDate()

        if ($PSCmdlet.ShouldProcess("$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky", "Cria o arquivo .banky com as informacoes de autenticação")) {
            New-Item -Type 'File' -Name '.banky' -Path $($(Resolve-Path -Path $env:USERPROFILE).Path) -Value $($response | ConvertTo-Json) -Force:$true -Confirm:$false -WhatIf:$WhatIfPreference -Verbose:$VerbosePreference | Out-Null
        }
    }
    end {}
}
