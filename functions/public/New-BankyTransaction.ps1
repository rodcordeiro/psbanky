function New-BankyTransaction {
    <#
.SYNOPSIS
    Create a transaction
.DESCRIPTION
    This function creates a new transaction entry at banky
.EXAMPLE
    New-BankyTransaction
    Create a new transaction entry at banky

.NOTES
    Version: 1.0
#>
    [CmdletBinding()]
    param (
        # Account to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]    
        [string]$account,
        # Category to be used, if not specified the user will be prompted to select it in a listbox.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]    
        [string]$category,
        # Transaction description
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]    
        [string]$description,
        # Transaction value
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]    
        [decimal]$value,
        # Transaction date at ISO format
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName)]    
        [datetime]$date,
        # If account parameter is specified, the script will search for the account with a similar name, breaking if it returns more than one account. This switch disables the like filter.        
        [switch]$AccountMatchExact
    )
    begin {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }
        [BankyAuthenticationResponse]$bankyAuth = $(Get-Content "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop | ConvertFrom-Json )

        $isExpired = [datetime]::Parse($bankyAuth.expirationDate) -lt [DateTime]::Now

        if ($isExpired) {
            try {
                New-BankyAuthentication @banky
            }
            catch {
                Throw "Login expirado, autentique novamente"
            }
        }

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($bankyAuth.accessToken)")
     
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(75, 120)
        $okButton.Size = New-Object System.Drawing.Size(75, 23)
        $okButton.Text = 'OK'
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK   
        
        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
        $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
        $cancelButton.Text = 'Cancel'
        $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        
        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point(10, 20)
        $label.Size = New-Object System.Drawing.Size(280, 20)
       
        $accounts = $(Get-BankyAccounts)
        $categories = $(Get-BankyCategories)
    }
    process {
        
        if (!$account) {

            $accountForm = New-Object System.Windows.Forms.Form
            $accountForm.Text = 'Select an account'
            $accountForm.Size = New-Object System.Drawing.Size(300, 200)
            $accountForm.StartPosition = 'CenterScreen'
    
            $okButton = New-Object System.Windows.Forms.Button
            $okButton.Location = New-Object System.Drawing.Point(75, 120)
            $okButton.Size = New-Object System.Drawing.Size(75, 23)
            $okButton.Text = 'OK'
            $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK   
        
            $cancelButton = New-Object System.Windows.Forms.Button
            $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
            $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
            $cancelButton.Text = 'Cancel'
            $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        
            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(10, 20)
            $label.Size = New-Object System.Drawing.Size(280, 20)
            $label.Text = 'Por favor, selecione uma conta:'
        
            $accountForm.AcceptButton = $okButton
            $accountForm.Controls.Add($okButton)
            $accountForm.CancelButton = $cancelButton
            $accountForm.Controls.Add($cancelButton)
            

            $accountForm.Controls.Add($label)
    
            $listBox = New-Object System.Windows.Forms.ListBox
            $listBox.Location = New-Object System.Drawing.Point(10, 40)
            $listBox.Size = New-Object System.Drawing.Size(260, 20)
            $listBox.Height = 80
            
            foreach ($item in $accounts) {
                [void] $listBox.Items.Add($item.name)
            }
    
            $accountForm.Controls.Add($listBox)
            $accountForm.Topmost = $true
    
            $result = $accountForm.ShowDialog()
            
            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                $account = $listBox.SelectedItem
                $selectedAccount = $($accounts | Where-Object { $_.name -eq $account })
            }
            else { 
                throw "Account cancelled" 
            }
        }
        else {
            $selectedAccount = if ($AccountMatchExact) { $accounts | Where-Object { $_.name -eq $account } } else { $accounts | Where-Object { $_.name -like "*$account*" } }
        }
        
        if (!$selectedAccount) { throw "Account not found" }
        if (($selectedAccount | Measure-Object).Count -gt 1) { throw "Account filter returned more than one value. Please be more specific." }
        
        if (!$category) {
            
            
            $categoriesForm = New-Object System.Windows.Forms.Form
            $categoriesForm.Text = 'Select an category'
            $categoriesForm.Size = New-Object System.Drawing.Size(300, 200)
            $categoriesForm.StartPosition = 'CenterScreen'
        
            
            $cancelButton = New-Object System.Windows.Forms.Button
            $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
            $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
            $cancelButton.Text = 'Cancel'
            $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        
            $okButton = New-Object System.Windows.Forms.Button
            $okButton.Location = New-Object System.Drawing.Point(75, 120)
            $okButton.Size = New-Object System.Drawing.Size(75, 23)
            $okButton.Text = 'OK'
            $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK   
            
            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(10, 20)
            $label.Size = New-Object System.Drawing.Size(280, 20)
            $label.Text = 'Por favor, selecione uma categoria:'
            $categoriesForm.Controls.Add($label)

            $listBox = New-Object System.Windows.Forms.ListBox
            $listBox.Location = New-Object System.Drawing.Point(10, 40)
            $listBox.Size = New-Object System.Drawing.Size(260, 20)
            $listBox.Height = 80

            $categoriesForm.AcceptButton = $okButton
            $categoriesForm.Controls.Add($okButton)
            $categoriesForm.CancelButton = $cancelButton
            $categoriesForm.Controls.Add($cancelButton)

            foreach ($item in $categories) {
                [void] $listBox.Items.Add("$(if($item.positive){"(+)"}else{"(-)"}) $($item.name)")
                if ($category.subcategories) {
                    foreach ($subcategory in $category.subcategories) {
                        [void] $listBox.Items.Add("$(if($subcategory.positive){"(+)"}else{"(-)"}) $($subcategory.name)")
                    }
                }
            }

            $categoriesForm.Controls.Add($listBox)
            $categoriesForm.Topmost = $true        
            $result = $categoriesForm.ShowDialog()

            if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                $category = $listBox.SelectedItem
                $category = $category.Split(' ')
                foreach ($cat in $categories) {
                    if ($cat.name -eq $category[1]) { $selectedCategory = $cat }
                    if ($cat.subcategories) {
                        foreach ($subcategory in $cat.subcategories) {
                            if ($subcategory.name -eq $category[1]) { $selectedCategory = $subcategory }
                        }
                    }
                }
            }
            else {
                throw "Category cancelled"
            }

        }
        else {
            
            foreach ($cat in $categories) {
                if ($cat.name -like "*$category*") { $selectedCategory = $cat }
                if ($cat.subcategories) {
                    foreach ($subcategory in $cat.subcategories) {
                        if ($subcategory.name -like "*$category*") { $selectedCategory = $subcategory }
                    }
                }
            }
        }
        
        if (!$selectedCategory) { throw "Category not found" }
        if (($selectedCategory | Measure-Object).Count -gt 1) { throw "Category filter returned more than one value. Please be more specific." }
        
        $transaction = [CreateBankyTransaction]::new()
        $transaction.category = $selectedCategory.id
        $transaction.account = $selectedAccount.id
        $transaction.description = if ($description) { $description } else { Read-Host "Informe a descricao da transacao" }
        $transaction.value = if ($value) { $value } else { Read-Host "Informe o valor da transacao" }
        $transaction.date = if ($date) { get-date -Format 'yyyy-MM-ddTHH:mm:ss' -Date $date } else { $(get-date -Format 'yyyy-MM-ddTHH:mm:ss') }

        if ($transaction.value -eq 0) {
            throw "O valor da transacao nao pode ser zero"
        }

        $body = $($transaction | ConvertTo-Json)

        $response = Invoke-RestMethod 'http://82.180.136.148:3338/api/v1/transactions' -Method 'POST' -Headers $headers -Body $body
        $response
    }
}

