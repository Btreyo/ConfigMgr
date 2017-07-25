# TITLE:    PoSH-ADGroupCreation.ps1
# PLATFORM: Windows 2012 Server R2
# AUTHOR:   Bobbi Trehan-Young
# CREATED:  20/07/2015 09:47
# MODIFIED: 27/08/2015 17:24
# VERSION:  0.1
# COPYRIGHT (c) eTech Consultancy. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PURPOSE: This script automates the creation of the following:
#          AD Groups via a CSV file named: AD_GROUPINPUT.csv
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Import-Module ActiveDirectory

# IMPORT CSV
$NEWPATH  = "C:\Users\btyadmin\Downloads\AD_GROUPINPUT.csv"
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
        { # CHECK IF GROUP ALREADY EXISTS 
        $EXISTS = Get-ADGroup $item.GroupName
        Write-Host "Group $($item.GroupName) already exists! Group creation skipped!"
        }
            Catch
            { # CREATE THE GROUP IF IT DOES NOT EXIST
              $CREATE = New-ADGroup -GroupScope $item.GROUPTYPE -Name $item.GROUPNAME -Description $item.DESCRIPTION -DisplayName $item.DISPLAYNAME -GroupCategory $item.GROUPCATEGORY -Path $item.LOCATION
              Write-Host "Group $($item.GroupName) created!"
        }
        }
    Else
    { Write-Host "Target OU can't be found! Group creation skipped!"}
    }

