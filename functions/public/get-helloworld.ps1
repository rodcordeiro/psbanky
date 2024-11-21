function Get-HelloWorld {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

   
    Write-Output "Hello, $Name!"
}
