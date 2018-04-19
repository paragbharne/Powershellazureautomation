param ( 
    [object]$WebhookData
)

if ($WebhookData -ne $null) {  
    # Collect properties of WebhookData.
    $WebhookName    =   $WebhookData.WebhookName
    $WebhookBody    =   $WebhookData.RequestBody
    $WebhookHeaders =   $WebhookData.RequestHeader
       
    # Information on the webhook name that called This
    Write-Output "This runbook was started from webhook $WebhookName."
       
    # Obtain the WebhookBody containing the AlertContext
    $WebhookBody = (ConvertFrom-Json -InputObject $WebhookBody)
    Write-Output "`nWEBHOOK BODY"
    Write-Output "============="
    Write-Output $WebhookBody
    
    # Some selected AlertContext information
    Write-Output "`nALERT CONTEXT DATA"

    $name = $WebhookBody.name
    $subscriptionId = $WebhookBody.subscriptionId
    $resourceGroupName = $WebhookBody.resourceGroupName
    $resourceName = $WebhookBody.resourceName
    $resourceType = $WebhookBody.resourceType
    $resourceId = $WebhookBody.resourceId
    $timestamp = $WebhookBody.timestamp

    Write-Output "==================="
    Write-Output $WebhookBody.name
    Write-Output $WebhookBody.subscriptionId
    Write-Output $WebhookBody.resourceGroupName
    Write-Output $WebhookBody.resourceName
    Write-Output $WebhookBody.resourceType
    Write-Output $WebhookBody.resourceId
    Write-Output $WebhookBody.timestamp

$connectionName = "AzureRunAsConnection"

#Get the connection "AzureRunAsConnection "

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

#Declaring the Dictionary object to store VM Names along with their Resource group names

$VMList = @{}

#Adding VMs to the VM List

#Replace the VM Name and Resource Group name with your environment data

$VMList.Add("Performtest-04", "Performtest-04VM")

#Getting the VM object using Get-AzureRmVM and then starting the VMs

$VMList.Keys | % {Get-AzureRmVM -Name $_ -ResourceGroupName $VMList.Item($_)} | Start-AzureRmVM

}

else 
{
    Write-Error "This runbook is meant to only be started from a webhook." 
}