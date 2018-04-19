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

$VMList.Add("profiling-01", "profiling-01")
$VMList.Add("profiling-02", "profiling-02")
$VMList.Add("profiling-03", "profiling-03")
$VMList.Add("profiling-4", "profiling-4")
$VMList.Add("profiling-05", "profiling-05")
$VMList.Add("qaprofiling-01", "qaprofiling-01")
$VMList.Add("qaprofiling-02", "qaprofiling-02")


#Getting the VM object using Get-AzureRmVM and then starting the VMs

$VMList.Keys | % {Get-AzureRmVM -Name $_ -ResourceGroupName $VMList.Item($_)} | Start-AzureRmVM