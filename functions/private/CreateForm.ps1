
function Invoke-ListBox {
    [OutputType([System.Boolean], [string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$title,
        [Parameter(Mandatory)]
        [string]$content,
        [Parameter(Mandatory)]
        [scriptblock]$map
    )
    begin {
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
    }
    process {

        $form = New-Object System.Windows.Forms.Form
        $form.Text = $title
        $form.Size = New-Object System.Drawing.Size(300, 200)
        $form.StartPosition = 'CenterScreen'


        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point(10, 20)
        $label.Size = New-Object System.Drawing.Size(280, 20)
        $label.Text = $content
        $form.Controls.Add($label)

        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(75, 120)
        $okButton.Size = New-Object System.Drawing.Size(75, 23)
        $okButton.Text = 'OK'
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.AcceptButton = $okButton
        $form.Controls.Add($okButton)

        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Location = New-Object System.Drawing.Point(150, 120)
        $cancelButton.Size = New-Object System.Drawing.Size(75, 23)
        $cancelButton.Text = 'Cancel'
        $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.CancelButton = $cancelButton
        $form.Controls.Add($cancelButton)


        $listBox = New-Object System.Windows.Forms.ListBox
        $listBox.Location = New-Object System.Drawing.Point(10, 40)
        $listBox.Size = New-Object System.Drawing.Size(260, 20)
        $listBox.Height = 80


        $map.Invoke($listBox)

        $form.Controls.Add($listBox)
        $form.Topmost = $true

        $result = $form.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            return $listBox.SelectedItem
        }
        else {
            return $false
        }
    }
}