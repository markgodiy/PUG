
$secretfilename = "Secrets.json"
$Script:secretfilepath = Join-Path $env:APPDATA $secretfilename

Add-Type -AssemblyName PresentationFramework


$xamlfile = @"
<Window x:Class="PsPasswordManager.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PsPasswordManager"
        mc:Ignorable="d"
        Title="PsPasswordManager" Height="450" Width="597">
    <Grid HorizontalAlignment="Center" Width="597">
        <Label x:Name="lblSystemName" Content="SystemName" HorizontalAlignment="Left" Margin="17,19,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="txtSystemName" HorizontalAlignment="Left" Margin="97,23,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="195"/>
        <Label x:Name="lblIpAddress" Content="IPAddress" HorizontalAlignment="Left" Margin="299,19,0,0" VerticalAlignment="Top"/>
        <TextBox x:Name="txtIpAddress" HorizontalAlignment="Left" Margin="367,23,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="195"/>
        <Button x:Name="btnAdd" Content="Add" HorizontalAlignment="Left" Margin="63,68,0,0" VerticalAlignment="Top" Width="104" />
        <Button x:Name="btnEdit" Content="Edit" HorizontalAlignment="Left" Margin="180,68,0,0" VerticalAlignment="Top" Width="104" />
        <Button x:Name="btnRefresh" Content="Refresh" HorizontalAlignment="Left" Margin="300,68,0,0" VerticalAlignment="Top" Width="104" />
        <Button x:Name="btnDelete" Content="Delete" HorizontalAlignment="Left" Margin="420,68,0,0" VerticalAlignment="Top" Width="104" />
        <DataGrid x:Name="dgSecrets" HorizontalAlignment="Left" Height="291" Margin="31,107,0,0" VerticalAlignment="Top" Width="529"/>
        <Label Content="View Secret File" HorizontalAlignment="Left" Margin="31,398,0,0" VerticalAlignment="Top" FontSize="8"/>
    </Grid>
</Window>
"@

$inputXAML = $xamlFile -replace 'mc:Ignorable="d"', '' -replace "x:Name", "Name" -replace '^<Win.*', '<Window'
[XML]$XAML = $inputXAML
$reader = New-Object System.Xml.XmlNodeReader $XAML
$form = [Windows.Markup.XamlReader]::Load($reader)
$XAML.SelectNodes("//*[@Name]") | ForEach-Object {try {Set-Variable -Name "var_$($_.Name)" -Value $form.FindName($_.Name) -ErrorAction Stop} catch {throw}}

$xamlfile_edit = @"
<Window x:Class="PsPasswordManager.Window1"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:PsPasswordManager"
        mc:Ignorable="d"
        Title="Edit Secret" Height="230" Width="320">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="83*"/>
            <ColumnDefinition Width="267*"/>
        </Grid.ColumnDefinitions>
        <Label x:Name="lblEditSystemName" Content="SystemName" HorizontalAlignment="Left" Margin="21,18,0,0" VerticalAlignment="Top" Grid.ColumnSpan="2"/>
        <TextBox x:Name="txtEditSystemName" HorizontalAlignment="Left" Margin="20,22,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="1"/>
        <Label x:Name="lblEditIpAddress" Content="IPAddress" HorizontalAlignment="Left" Margin="21,50,0,0" VerticalAlignment="Top" Grid.ColumnSpan="2"/>
        <TextBox x:Name="txtEditIpAddress" HorizontalAlignment="Left" Margin="20,54,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="1"/>
        <Label x:Name="lblEditUsername" Content="UserName" HorizontalAlignment="Left" Margin="21,82,0,0" VerticalAlignment="Top" Grid.ColumnSpan="2"/>
        <TextBox x:Name="txtEditUserName" HorizontalAlignment="Left" Margin="20,86,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="1"/>
        <Label x:Name="lblSystemNameEdit_Copy2" Content="Password" HorizontalAlignment="Left" Margin="21,114,0,0" VerticalAlignment="Top" Grid.ColumnSpan="2"/>
        <TextBox x:Name="lblEditPassword" HorizontalAlignment="Left" Margin="20,118,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="190" Grid.Column="1"/>
        <Button x:Name="btnUpdate" Content="Update" HorizontalAlignment="Left" Margin="81,159,0,0" VerticalAlignment="Top" Width="129" Grid.Column="1"/>

    </Grid>
</Window>
"@

$inputXAML = $xamlfile_edit -replace 'mc:Ignorable="d"', '' -replace "x:Name", "Name" -replace '^<Win.*', '<Window'
[XML]$XAML = $inputXAML
$reader = New-Object System.Xml.XmlNodeReader $XAML
$formEdit = [Windows.Markup.XamlReader]::Load($reader)
$XAML.SelectNodes("//*[@Name]") | ForEach-Object {try {Set-Variable -Name "var_$($_.Name)" -Value $formEdit.FindName($_.Name) -ErrorAction Stop} catch {throw}}


$Columns = @('SystemName', 'IPAddress', 'UserName',"Password")
$SecretDataTable = New-Object System.Data.DataTable
[void]$SecretDataTable.Columns.AddRange($Columns)

$Secrets = Get-Content $Script:SecretFile -raw | ConvertFrom-Json

foreach ($secret in $Secrets) {
    $Entry = @()
    foreach ($Column in $Columns) {
        $Entry += $secret.$Column
    }
    [void]$SecretDataTable.Rows.Add($Entry)
}

$var_dgSecrets.ItemsSource = $SecretDataTable.DefaultView
$var_dgSecrets.IsReadOnly = $false
$var_dgSecrets.GridLinesVisibility = "None"

$form.ShowDialog()

$var_btnEdit.Add_Click({
    $formEdit.ShowDialog()
})
