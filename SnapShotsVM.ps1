$connectionName = "AzureRunAsConnection"

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

$subscriptionId = '60db440f-8d85-4856-92d7-fad59376f2a7'

$resourceGroupName = 'Alfresco-01' 
$location = 'Canada Central' 
$dataDiskName = 'Alfresco-01_OsDisk_1_29946eed8c094597a46b8dd7f16073e6' 
$time =  Get-Date -format d

#$snapshotName = ("Alfresco-01_datadisk1_snapshot01_" + $time)
$snapshotName = $resourceGroupName + (Get-Date).ToString("-yyyy-MM-dd-HH-mm")


$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $dataDiskName

$snapshot =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location

$resourceGroupName = "Snapshots"

New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName