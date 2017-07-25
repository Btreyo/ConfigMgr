# TITLE:    PoSH-ADUserCreation.ps1
# PLATFORM: Windows 2012 Server R2
# AUTHOR:   Bobbi Trehan-Young
# CREATED:  20/07/2015 09:47
# MODIFIED: 24/07/2017 17:24
# VERSION:  0.1
# COPYRIGHT (c) eTech Consultancy. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PURPOSE: This script automates the creation of the following:
#          AD User Accounts via a CSV file named: AD_USERINPUT.csv
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Import-Module ActiveDirectory

# IMPORT CSV
$NEWPATH  = "C:\Users\btyadmin\Downloads\AD_USERINPUT.csv"
$CSV      = Import-Csv -Path $NEWPATH

# GET DOMAIN BASE
$SEARCHBASE = Get-ADDomain | ForEach {  $_.DistinguishedName }

# LOOP ITEMS FROM CSV
ForEach ($item In $CSV)
{ #Check if the OU exists
  $CHECK = [ADSI]::Exists("LDAP://$($item.Location)")
  
    If ($CHECK -eq $True)
    {
        Try
        { # CHECK IF OBJECT ALREADY EXISTS 
        $EXISTS = Get-ADUser -Identity $item.UserName
        Write-Host "User $($item.UserName) already exists! Account creation skipped!"
        }
            Catch
            { # CREATE THE OBJECT IF IT DOES NOT EXIST
              $CREATE = New-ADUser -Name $item.USERNAME -Description $item.DESCRIPTION -DisplayName $item.DISPLAYNAME -Path $item.LOCATION -SamAccountName $item.SAMNAME
              Write-Host "User $($item.GroupName) created!"
        }
        }
    Else
    { Write-Host "Target OU can't be found! Account creation skipped!"}
    }

