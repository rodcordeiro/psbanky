<#
.SYNOPSIS
    A simple but yet powerful financial personal assistant cli
.DESCRIPTION
    Banky is a finance personal assistant focused on tracking financial spendments and growing a financial health habit. This PSModule focus on working as a CLI for Banky
.EXAMPLE
    Import-Module psbanky
    Use examples of commands provided by the module.
.NOTES
    Created by [RodCordeiro](https://github.com/rodcordeiro)
#>

# Import private and public functions
$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\functions\public" -Filter *.ps1
$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\functions\private" -Filter *.ps1
$publicClasses = Get-ChildItem -Path "$PSScriptRoot\classes\public" -Filter *.ps1
$privateClasses = Get-ChildItem -Path "$PSScriptRoot\classes\private" -Filter *.ps1

# Dot-source all Public Functions
foreach ($file in $publicFunctions) {
    try {
        . $file.FullName
    }
    catch {
        Write-Host "Error loading $($file.Name): $($file.Exception)"
    }
}

# Dot-source all Private Functions
foreach ($file in $privateFunctions) {
    try {
        . $file.FullName
    }
    catch {
        Write-Host "Error loading $($file.Name): $($file.Exception)"
    }
}
# Dot-source all Private Functions
foreach ($file in $publicClasses) {
    try {
        . $file.FullName
    }
    catch {
        Write-Host "Error loading $($file.Name): $($file.Exception.Message)"
    }
}# Dot-source all Private Functions
foreach ($file in $privateClasses) {
    try {
        . $file.FullName
    }
    catch {
        Write-Host "Error loading $($file.Name): $($file.Exception)"
    }
}

(Get-ChildItem -Path "$PSScriptRoot\functions\public" -Filter *.ps1 | ForEach-Object { $_.BaseName })
# Export only public functions
Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot\functions\public" -Filter *.ps1 | ForEach-Object { $_.BaseName })