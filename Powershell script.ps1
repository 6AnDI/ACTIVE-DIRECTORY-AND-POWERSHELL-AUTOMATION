#Make sure the path is pointed correctly to where the csv file Lives....

$csvPath = "C:\Temp\user_accounts_final.csv"
$Domain = "DC=Automation,DC=Com"
$Users = Import-Csv -Path $csvPath

Write-Host "Found $($Users.Count) users in the CSV file. Starting import..." -ForegroundColor Green

foreach ($User in $Users) {
    $SecurePassword = ConvertTo-SecureString $User.password -AsPlainText -Force
    $DepartmentOU = $User.department
    
    if (!(Get-ADOrganizationalUnit -Filter "Name -eq '$DepartmentOU'" -SearchBase $Domain)) {
        New-ADOrganizationalUnit -Name $DepartmentOU -Path $Domain -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $DepartmentOU" -ForegroundColor Yellow
    }
    
    $NameParts = $User.DisplayName -split ' ', 2
    $FirstName = $NameParts[0]
    $LastName = if ($NameParts.Count -gt 1) { $NameParts[1] } else { "" }
    
    New-ADUser -Name $User.DisplayName -GivenName $FirstName -Surname $LastName -SamAccountName $User.username -UserPrincipalName $User.UPN -Path $User.OU -AccountPassword $SecurePassword -Enabled $true -ChangePasswordAtLogon $true
    
    Write-Host "Created User: $($User.username) in $DepartmentOU" -ForegroundColor Cyan
}