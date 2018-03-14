# the file contains the settings for:
#   - packing individual data files into a Configuration Migration Tool data zip file
#   - packing individual solution files into a zip file using the CRM SDK's solution packager tool
#   - creating a package of a data zip file and solution zip files for import using the CRM SDK's package deployer tool
#   - provisioning an organization in a local development environment from a database backup
# this file typically does not need to be modified, but the files it refers to would be, including:
#   - CrmDataPackages\Default.ps1
#   - CrmSolutions\Managed.ps1
#   - CrmSolutions\Unmanaged.ps1
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters,

    [ValidateSet("Managed","Unmanaged")]
    [string]
    $PackageType = "Unmanaged"
)

$scriptsRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Split-Path -Parent $scriptsRoot
$solutionExt = if($PackageType -eq "Managed") { "_managed" }

@{
    ExtractedData = [PSCustomObject]@{
        Folder = "$projectRoot\crm\data\FabrikamFiber"
        ZipFile = "$projectRoot\temp\packed\FabrikamFiberData.zip"
    }
    ExtractedSolutions = @(
        [PSCustomObject]@{
            Folder = "$projectRoot\crm\solutions\AdventureWorks"
            MappingXmlFile = "$projectRoot\crm\solutions\AdventureWorks.mappings.xml"
            PackageType = $PackageType
            ZipFile = "$projectRoot\temp\packed\AdventureWorks$solutionExt.zip"
        },
        [PSCustomObject]@{
            Folder = "$projectRoot\crm\solutions\Contoso"
            MappingXmlFile = "$projectRoot\crm\solutions\Contoso.mappings.xml"
            PackageType = $PackageType
            ZipFile = "$projectRoot\temp\packed\Contoso$solutionExt.zip"
        }
    )
    CrmPackageDefinition = @(
        [PSCustomObject]@{
            DataZipFile = "$projectRoot\temp\packed\FabrikamFiberData.zip"
            SolutionZipFiles = @(
                "$projectRoot\crm\solutions\Northwind_managed.zip",
                "$projectRoot\temp\packed\AdventureWorks$solutionExt.zip",
                "$projectRoot\temp\packed\Contoso$solutionExt.zip"
            )
        }
    )
    CrmOrganizationProvisionDefinition = [PSCustomObject]@{
        ComputerName = 'dyn365.contoso.com'
        Credential = [PSCredential]::new('contoso\administrator', ('pass@word1' | ConvertTo-SecureString -AsPlainText -Force))
        OrganizationName = $CrmConnectionParameters.OrganizationName
        SqlBackupFile = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\new_MSCRM.bak'
        SqlDataFile = "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\$($CrmConnectionParameters.OrganizationName)_MSCRM.mdf"
        SqlLogFile = "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\$($CrmConnectionParameters.OrganizationName)_MSCRM_log.ldf"
    }
    CrmPackageDeploymentDefinition = [PSCustomObject]@{
        CrmConnectionParameters = $CrmConnectionParameters
    }
}