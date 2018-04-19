<##How to export the azure sql database backup of the using powershell
# ---- Login to Azure ----
workflow ExportAzureDB-PowerShellWorkflowScript {
inlineScript {
$connectionName = "AzureRunAsConnection"
try
{
# Get the connection "AzureRunAsConnection "
$servicePrincipalConnection=Get-AutomationConnection -Name $connectionName

"Login to Azure"
Add-AzureRmAccount `
-ServicePrincipal `
-TenantId $servicePrincipalConnection.TenantId `
-ApplicationId $servicePrincipalConnection.ApplicationId `
-CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
#}
#>
<#catch {
if (!$servicePrincipalConnection)
{
$ErrorMessage = "Connection $connectionName not found."
throw $ErrorMessage
} else{
Write-Error -Message $_.Exception
throw $_.Exception
}
}#>

$connectionName = "AzureRunAsConnection"

$servicePrincipalConnection = Get-AutomationConnection -Name $connectionName  
       
   "Logging in to Azure..."

    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

# Database to export
$DatabaseName = "dev-mintDB"
$ServerName = "siftgridenterpriseserver"
$ServerAdmin = "bizruntime"
$ResourceGroupName = "siftgridenterpriseserverrgp"
$serverPassword = "vikash@123"
$securePassword = ConvertTo-SecureString -String $serverPassword -AsPlainText -Force
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $serverAdmin, $securePassword

# Generate a unique filename for the BACPAC
$bacpacFilename = $DatabaseName + (Get-Date).ToString("yyyy-MM-dd-HH-mm") + ".bacpac"

# Storage account info for the BACPAC
$BaseStorageUri = "https://siftgridsqlbackup.blob.core.windows.net/daily"
$BacpacUri = $BaseStorageUri + "/Daily/" + $bacpacFilename
$StorageKeytype = "StorageAccessKey"
$StorageKey = "5j4IrBuDqvo434IC+9bbKPtEW8vcmHJ4xsHesgQab1dLqT5wTTUA0lJeZ8W/2TM95VoycCtUtqiLG9BUoQbCZg=="

$exportRequest = New-AzureRmSqlDatabaseExport -ResourceGroupName $ResourceGroupName -ServerName $ServerName `
-DatabaseName $DatabaseName -StorageKeytype $StorageKeytype -StorageKey $StorageKey -StorageUri $BacpacUri `
-AdministratorLogin $creds.UserName -AdministratorLoginPassword $creds.Password

# Check status of the export
$exportStatus = Get-AzureRmSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink

#Write-Output "Azure SQL DB Export Completed at $DatabaseName"

#}
#}