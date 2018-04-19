######################################################Create a managed disk from the snashots#################################################
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

New-AzureRmResourceGroup -Name Alfresco_test -Location "Canada Central"

$resourceGroupName ='Alfresco_test' 

New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName

#########################################################Create a VM from the managhed disk #############################################

$subscriptionId = '60db440f-8d85-4856-92d7-fad59376f2a7'

$resourceGroupName ='Alfresco_test'

$diskName = 'Alfresco-01_datadisk1_snapshot01_to_Mangeddisk'

$location = 'Canada Central'

$virtualNetworkName = 'Alfresco_test_Vnet'

$virtualMachineName = 'Alfresco_test'

$virtualMachineSize = 'Standard_DS3'

$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24 

$vnet = New-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName -location $location -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

$publicIp = New-AzureRmPublicIpAddress -Name ($VirtualMachineName.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Static

$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location `
  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP

$nic = New-AzureRmNetworkInterface -Name($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id

$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id


$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Windows
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

# Not using this right now but we can use this one also in future
#$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize Set-AzureRmVMOSDisk -VM $VirtualMachine -#ManagedDiskId $disk.Id -CreateOption Attach -Windows Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $location