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
       
    # Obtain the AlertContext
    $AlertContext = [object]$WebhookBody.context

    # Some selected AlertContext information
    Write-Output "`nALERT CONTEXT DATA"
    Write-Output "==================="
    Write-Output $AlertContext.name
    Write-Output $AlertContext.subscriptionId
    Write-Output $AlertContext.resourceGroupName
    Write-Output $AlertContext.resourceName
    Write-Output $AlertContext.resourceType
    Write-Output $AlertContext.resourceId
    Write-Output $AlertContext.timestamp
      
    # Act on the AlertContext data, for example, restart the VM.
       
    # Authenticate to your Azure subscription using OrganizationId to be able to restart that Virtual Machine. For authenticating to Azure using Azure Active Directory, please see the blog.
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

#$VMList = @{}

#Adding VMs to the VM List

#Replace the VM Name and Resource Group name with your environment data

#$VMList.Add("$AlertContext.resourceGroupName", "$AlertContext.resourceName")

#Getting the VM object using Get-AzureRmVM and then starting the VMs

#$VMList.Keys | % {Get-AzureRmVM -Name $_ -ResourceGroupName $VMList.Item($_)} | Start-AzureRmVM
}
#else 
{
    Write-Error "This runbook is meant to only be started from a webhook." 
}