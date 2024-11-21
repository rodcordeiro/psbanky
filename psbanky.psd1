@{
    # Module manifest information
    ModuleVersion     = '0.1.0'
    GUID              = '00000000-0000-0000-0000-000000000000'
    Author            = 'Rodrigo Cordeiro'
    Description       = 'Banky Powershell module'
    CompanyName       = 'Rodcordeiro'
    PowerShellVersion = '5.1'
    FunctionsToExport = @()
    CmdletsToExport   = @()
    AliasesToExport   = @()
    # Módulos que devem ser importados para o ambiente global antes da importação deste módulo
    RequiredModules = @("SecurityFever")
    PrivateData       = @{
        PSData = @{
            Tags         = @('Finances', 'PowerShell', 'Module', 'Personal')
            LicenseUri   = ''
            ProjectUri   = ''
            ReleaseNotes = 'Initial release'
        }
    }
}
