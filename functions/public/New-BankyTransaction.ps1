function New-BankyTransaction {
    [CmdletBinding()]
    param ()
    begin {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        if (!(Test-Path "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop)) {
            throw "Banky not found. Please configure it."
        }
        [BankyAuthenticationResponse]$bankyAuth = $(Get-Content "$($(Resolve-Path -Path $env:USERPROFILE).Path)\.banky" -ErrorAction Stop | ConvertFrom-Json )

        $isExpired = [datetime]::Parse($bankyAuth.expirationDate) -lt [DateTime]::Now

        if ($isExpired) {
            Throw "Login expirado, autentique novamente"
        }

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Content-Type", "application/json")
        $headers.Add("Authorization", "Bearer $($bankyAuth.accessToken)")
     
        
    }
    process {
        
        $accounts = $(Get-Accounts)
        $categories = $(Get-Categories)
        
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
        
        
        $accountForm.AcceptButton = $okButton
        $accountForm.Controls.Add($okButton)
        $accountForm.CancelButton = $cancelButton
        $accountForm.Controls.Add($cancelButton)
        
        
        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point(10, 20)
        $label.Size = New-Object System.Drawing.Size(280, 20)
        $label.Text = 'Por favor, selecione uma conta:'
        $accountForm.Controls.Add($label)

        $listBox = New-Object System.Windows.Forms.ListBox
        $listBox.Location = New-Object System.Drawing.Point(10, 40)
        $listBox.Size = New-Object System.Drawing.Size(260, 20)
        $listBox.Height = 80

        foreach ($account in $accounts) {
            [void] $listBox.Items.Add($account.name)
        }

        $accountForm.Controls.Add($listBox)
        $accountForm.Topmost = $true

        $result = $accountForm.ShowDialog()

        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $account = $listBox.SelectedItem
            $account = $accounts | Where-Object { $_.name -eq $account }
        }

        $categoriesForm = New-Object System.Windows.Forms.Form
        $categoriesForm.Text = 'Select an category'
        $categoriesForm.Size = New-Object System.Drawing.Size(300, 200)
        $categoriesForm.StartPosition = 'CenterScreen'

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
        $label.Text = 'Por favor, selecione uma categoria:'
        $categoriesForm.Controls.Add($label)

        $listBox = New-Object System.Windows.Forms.ListBox
        $listBox.Location = New-Object System.Drawing.Point(10, 40)
        $listBox.Size = New-Object System.Drawing.Size(260, 20)
        $listBox.Height = 80

        foreach ($category in $categories) {
            [void] $listBox.Items.Add("$(if($category.positive){"(+)"}else{"(-)"}) $($category.name)")
            if ($category.subcategories) {
                foreach ($subcategory in $category.subcategories) {
                    [void] $listBox.Items.Add("$(if($subcategory.positive){"(+)"}else{"(-)"}) $($subcategory.name)")
                }
            }
        }

        $categoriesForm.Controls.Add($listBox)
        $categoriesForm.AcceptButton = $okButton
        $categoriesForm.Controls.Add($okButton)
        $categoriesForm.CancelButton = $cancelButton
        $categoriesForm.Controls.Add($cancelButton)
        $categoriesForm.Topmost = $true

        $result = $categoriesForm.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $category = $listBox.SelectedItem
            $category = $category.Split(' ')
            foreach ($cat in $categories) {
                if ($cat.name -eq $category[1]) { $category = $cat }
                if ($cat.subcategories) {
                    foreach ($subcategory in $cat.subcategories) {
                        if ($subcategory.name -eq $category[1]) { $category = $subcategory }
                    }
                }
            }
        }
        $category
        $transaction = [CreateBankyTransaction]::new()
        $transaction.category = $category.id
        $transaction.account = $account.id
        $transaction.description = Read-Host "Informe a descricao da transacao"
        $transaction.value = Read-Host "Informe o valor da transacao" 
        $transaction.date = $(get-date -Format 'yyyy-MM-ddTHH:mm:ss')

        if ($transaction.value -eq 0) {
            throw "O valor da transacao nao pode ser zero"
        }
        $transaction
        $body = $($transaction | ConvertTo-Json)
        $body
        $response = Invoke-RestMethod 'http://82.180.136.148:3338/api/v1/transactions' -Method 'POST' -Headers $headers -Body $body
        $response
    }
}
