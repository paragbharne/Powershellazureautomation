#login into Azure
$connectionName = "AzureRunAsConnection"

#Get the connection "AzureRunAsConnection "

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

#Provide the subscription Id
$subscriptionId = '60db440f-8d85-4856-92d7-fad59376f2a7'

#Provide the name of your resource group
$resourceGroupName ='Snapshots'

#Provide the name of the snapshot that will be used to create Managed Disks
$snapshotName = 'Alfresco-01_datadisk1_snapshot01'

#Provide the name of the Managed Disk
$diskName = 'Alfresco-01_datadisk1_snapshot01_to_Mangeddisk'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '128'

#Provide the storage type for Managed Disk. PremiumLRS or StandardLRS.
$storageType = 'PremiumLRS'

#Provide the Azure region (e.g. westus) where Managed Disks will be located.
#This location should be same as the snapshot location
#Get all the Azure location using command below:
#Get-AzureRmLocation
$location = 'Canada Central'


#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 
 
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id

New-AzureRmResourceGroup -Name AlfrescoBackup_VM -Location "Canada Central"

$resourceGroupName ='AlfrescoBackup_VM' 

New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName