# TITLE:    PoSH-CM-CreateCollection.ps1
# PLATFORM: Windows 2012 Server R2
# AUTHOR:   Bobbi Trehan-Young
# CREATED:  11/07/2017 10:56
# VERSION:  0.1
# COPYRIGHT (c) eTFLConsultancy. All rights reserved.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PURPOSE: This script automates the creation of ConfigMgr 
#          Collections using a .CSV file 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RUN ONCE TO ESTABLISH CONNECTION TO CONFIGMGR CONSOLE
{<# 
    $SiteCode = 'ETF:'
    Set-Location -Path 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin'
    Import-Module .\ConfigurationManager.psd1
    Set-Location $SiteCode

    Get-CMCmdletUpdateCheck #if enabled disable
    Set-CMCmdletUpdateCheck -CurrentUser -IsUpdateCheckEnabled 0
    
    Get-Module -Name ConfigurationManager | Select-Object -Property Name,Version

#>}

# ~~~~~~~~~~~~~~~~~ CREATES COLLECTIONS: ~~~~~~~~~~~~~~~~~ 
# IMPORT CSV
    $NEWPATH  = "C:\Users\btyadmin\Documents\PoSH Scripts\CM_COLLECTIONS.csv"
    $CSV      = Import-Csv -Path $NEWPATH

#---- CREATE COLLECTIONS & MOVE TO FOLDERS
    foreach ($item in $CSV) 
    {
    New-CMDeviceCollection -Name $item.COLLECTION -LimitingCollectionName $item.LTDCOLLECTION #-RefreshType ConstantUpdate, Periodic -RefreshSchedule (New-CMSchedule -Start (get-date) -RecurInterval Days -RecurCount 7)}
    }

    Start-Sleep -Seconds 5 
    foreach ($item in $CSV) 
    {
    Get-CMDeviceCollection -Name $item.COLLECTION | MOVE-CMObject -FolderPath $item.LOCATION
    }    

    
