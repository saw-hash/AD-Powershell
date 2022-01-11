# Import active directory module for running AD cmdlets
Import-Module activedirectory
  
#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv C:\temp\powershell\script_csv_template\bulk_users1.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
		
	$Username 	= $User.username
	$Password 	= $User.password
	$Firstname 	= $User.firstname -replace ' ',''
	#$Lastname 	= $User.lastname.ToUpper() -replace ' ',''
	$Lastname 	= $User.lastname.ToUpper()
	$OU 		= $User.ou #This field refers to the OU the user account is to be created in
    $email      = $User.email
    $upn        = $user.upn
    $displayname = $User.displayname
    $streetaddress = $User.streetaddress
    $city       = $User.city
    $zipcode    = $User.zipcode
    $state      = $User.state
    $country    = $User.country
    $telephone  = $User.telephone
    $jobtitle   = $User.jobtitle
    $company    = $User.company
    $department = $User.department
    $Password = $User.Password
    $description = $User.description
    $samaccount = $User.SamAccountName

  

	#Check to see if the user already exists in AD
        #OR operator  true OR true = true  | true OR false =false
	if (Get-ADUser -F {(SamAccountName -eq $Username) -or (Emailaddress -eq $email)})
	{
		 #If user does exist, give a warning
		 Write-Warning "A user account with username $Username $email $upn already exist in Active Directory."
	}
	else
	{
		#User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$upn"  `
            -Name "$Firstname $Lastname (ING Partner)" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Firstname $Lastname (ING Partner)" `
            -Path $OU `
            -City $city `
            -Country $country `
            -Company $company `
            -State $state `
            -StreetAddress $streetaddress `
            -OfficePhone $telephone `
            -EmailAddress $email `
            -Title $jobtitle `
            -Department $department `
            -Description $description `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False
           write-host $user.username  $User.firstname $User.lastname created -ForegroundColor Green    
	} 
}

