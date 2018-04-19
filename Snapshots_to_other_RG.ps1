$connectionName = "AzureRunAsConnection"

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

$subscriptionId = '60db440f-8d85-4856-92d7-fad59376f2a7'

$resourceGroupName = 'websocket03' 
$location = 'Canada Central' 
$dataDiskName = 'websocket03_websocket03' 
$snapshotName = 'websocket03_websocket03_snapshot'

$disk = Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $dataDiskName

$snapshot =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -CreateOption Copy -Location $location

New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $resourceGroupName