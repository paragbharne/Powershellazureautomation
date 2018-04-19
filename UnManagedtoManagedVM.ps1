$connectionName = "AzureRunAsConnection"

#Get the connection "AzureRunAsConnection "

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 


$rgName = "websocket03"

$vmName = "websocket03"

Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName -Force

ConvertTo-AzureRmVMManagedDisk -ResourceGroupName $rgName -VMName $vmName

Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName