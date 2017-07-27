# TITLE:    PoSH-CM-CreateCollection.ps1
# PLATFORM: Windows 2012 Server R2
# AUTHOR:   Bobbi Trehan-Young
# CREATED:  11/07/2017 10:56
# VERSION:  0.1
# COPYRIGHT (c) eTFLConsultancy. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PURPOSE: This script automates the creation of ConfigMgr 
#          Collections & Maintenance Winddows using a CM_COLLECTIONS.csv file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RUN ONCE TO ESTABLISH CONNECTION TO CONFIGMGR CONSOLE
{<# 
# ~~~~~~~~~~~~~~~~~ IMPORT CONFIGMGR PoSH MODULE ~~~~~~~~~~~~~~~~~ 
    Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")

    # ~~~~ RETIREVE CM SITECODE ~~~~
    $SiteCode = Get-PSDrive -PSProvider CMSITE

    # ~~~~ SET CONNECTION CONTEXT ~~~~
    Set-Location "$($SiteCode.Name):\"
#>}

# ~~~~~~~~~~~~~~~~~ CREATES COLLECTIONS: ~~~~~~~~~~~~~~~~~ 
# IMPORT CSV
    $NEWPATH  = "C:\Users\btyadmin\Documents\PoSH Scripts\CM_COLLECTIONS.csv"
    $CSV      = Import-Csv -Path $NEWPATH

#---- CREATE COLLECTIONS & MOVE TO FOLDERS
    foreach ($item in $CSV) 
    {
    New-CMDeviceCollection -Name $item.COLLECTION -LimitingCollectionName $item.LTDCOLLECTION -RefreshType Periodic -RefreshSchedule (New-CMSchedule -Start (get-date) -RecurInterval Days -RecurCount 7) 
    }

    Start-Sleep -Seconds 5 
    foreach ($item in $CSV) 
    {
    Get-CMDeviceCollection -Name $item.COLLECTION | MOVE-CMObject -FolderPath $item.LOCATION
    }    

#---- CONFIGURE MAINTENANCE WINDOW
    Start-Sleep -Seconds 5 

    foreach ($item in $CSV) 
    {
    $Schedule = New-CMSchedule -DurationCount $item.DURATION -DurationInterval Hours -RecurCount 1 -DayOfWeek $item.WEEKDAY -WeekOrder $item.WEEKORDER -Start ($item.TIME)
    $Collection = Get-CMDeviceCollection -Name $item.COLLECTION
    New-CMMaintenanceWindow -CollectionID $Collection.CollectionID -Schedule $Schedule -Name "Maintenance Window"
    }
