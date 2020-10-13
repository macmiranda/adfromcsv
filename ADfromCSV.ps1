param ($Filename = $(throw "Filename is required."))
$ADUsers = Import-csv $Filename

foreach ($User in $ADUsers)
{

 $Username = $User.username
 $Password = $User.password
 $Firstname = $User.firstname
 $Lastname = $User.lastname
 $Group = $User.group
 $Description = $User.description
 $Validity = $User.validity
 
 #Check if the user account already exists in AD
 if (Get-ADUser -F {SamAccountName -eq $Username})
 {
  #If user does exist, output a warning message
  Write-Warning "A user account $Username already exists in Active Directory."
 }
 else
 {
  #If a user does not exist then create a new user account

  New-ADUser `
     -SamAccountName $Username `
     -UserPrincipalName "$Username@fictitious.com" `
     -Name "$Firstname $Lastname" `
     -GivenName $Firstname `
     -Surname $Lastname `
     -Enabled $True `
     -AccountExpirationDate (Get-Date).addDays($Validity) `
     -ChangePasswordAtLogon $False `
     -DisplayName "$Lastname, $Firstname" `
     -Description $Description `
     -Path "CN=Users,DC=fictitious,DC=com" `
     -AccountPassword (convertto-securestring $Password -AsPlainText -Force) `
     -PasswordNeverExpires $True `
     -PassThru | % {Add-ADGroupMember -Identity "CN=$Group,CN=Users,DC=fictitious,DC=com" -Members $_}
 }
}