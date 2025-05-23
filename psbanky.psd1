@{

    # Arquivo de módulo de script ou módulo binário associado a este manifesto.
    RootModule        = 'psbanky.psm1'

    # Número da versão deste módulo.
    ModuleVersion     = '2.2.0'

    # PSEditions com suporte
    # CompatiblePSEditions = @()

    # ID usada para identificar este módulo de forma exclusiva
    GUID              = '56dfc9ae-c9fb-46fd-8f3a-706236d272c7'

    # Autor deste módulo
    Author            = 'RodCordeiro'

    # Empresa ou fornecedor deste módulo
    CompanyName       = 'Desconhecido'

    # Instrução de direitos autorais para este módulo
    Copyright         = '(c) 2025 RodCordeiro. Todos os direitos reservados.'

    # Descrição da funcionalidade fornecida por este módulo
    Description       = 'A CLI for the Banky Finance Personal Assistant'

    # A versão mínima do mecanismo do Windows PowerShell exigida por este módulo
    # PowerShellVersion = ''

    # Nome do host do Windows PowerShell exigido por este módulo
    # PowerShellHostName = ''

    # A versão mínima do host do Windows PowerShell exigida por este módulo
    # PowerShellHostVersion = ''

    # Versão mínima do Microsoft .NET Framework exigida por este módulo. Este pré-requisito é válido somente para a edição PowerShell Desktop.
    # DotNetFrameworkVersion = ''

    # A versão mínima do CLR (Common Language Runtime) exigida por este módulo. Este pré-requisito é válido somente para a edição PowerShell Desktop.
    # CLRVersion = ''

    # Arquitetura de processador (None, X86, Amd64, IA64) exigida por este módulo
    # ProcessorArchitecture = ''

    # Módulos que devem ser importados para o ambiente global antes da importação deste módulo
    RequiredModules = @('CredentialManager')

    # Assemblies que devem ser carregados antes da importação deste módulo
    # RequiredAssemblies = @()

    # Arquivos de script (.ps1) executados no ambiente do chamador antes da importação deste módulo.
    # ScriptsToProcess = @()

    # Arquivos de tipo (.ps1xml) a serem carregados durante a importação deste módulo
    # TypesToProcess = @()

    # Arquivos de formato (.ps1xml) a serem carregados na importação deste módulo
    # FormatsToProcess = @()

    # Módulos para importação como módulos aninhados do módulo especificado em RootModule/ModuleToProcess
    # NestedModules = @()

    # Funções a serem exportadas deste módulo. Para melhor desempenho, não use curingas e não exclua a entrada. Use uma matriz vazia se não houver nenhuma função a ser exportada.
    FunctionsToExport = '*'

    # Cmdlets a serem exportados deste módulo. Para melhor desempenho, não use curingas e não exclua a entrada. Use uma matriz vazia se não houver nenhum cmdlet a ser exportado.
    CmdletsToExport   = '*'

    # Variáveis a serem exportadas deste módulo
    VariablesToExport = '*'

    # Aliases a serem exportados deste módulo. Para melhor desempenho, não use curingas e não exclua a entrada. Use uma matriz vazia se não houver nenhum alias a ser exportado.
    AliasesToExport   = '*'

    # Recursos DSC a serem exportados deste módulo
    # DscResourcesToExport = @()

    # Lista de todos os módulos empacotados com este módulo
    # ModuleList = @()

    # Lista de todos os arquivos incluídos neste módulo
    # FileList = @()

    # Dados privados para passar para o módulo especificado em RootModule/ModuleToProcess. Também podem conter uma tabela de hash PSData com metadados adicionais do módulo usados pelo PowerShell.
    PrivateData       = @{

        PSData = @{
            Tags         = @('Finances', 'PowerShell', 'Module', 'Personal')
            ReleaseNotes = 'Initial release'
            LicenseUri   = "https://raw.githubusercontent.com/rodcordeiro/psbanky/main/LICENSE"
            ProjectUri   = 'https://github.com/rodcordeiro/psbanky'
            IconUri      = 'https://raw.githubusercontent.com/rodcordeiro/psbanky/main/assets/logo.png'
            # ReleaseNotes deste módulo
            # ReleaseNotes = ''

        } # Fim da tabela de hash PSData
    } # Fim da tabela de hash PrivateData

    # URI de HelpInfo deste módulo
    HelpInfoURI       = 'https://raw.githubusercontent.com/rodcordeiro/psbanky/main/docs/psbanky-help.xml'

    # Prefixo padrão dos comandos exportados deste módulo. Substitua o prefixo padrão usando Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

