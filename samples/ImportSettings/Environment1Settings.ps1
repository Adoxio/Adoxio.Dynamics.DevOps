param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters,

    [ValidateSet("Managed","Unmanaged")]
    [string]
    $PackageType = "Unmanaged"
)

$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$solutionExt = if($PackageType -eq "Managed") { "_managed" }

@{
    ExtractedData = [PSCustomObject]@{
        Folder = "$projectRoot\crm\data\{todo:FeatureName}"
        ZipFile = "$projectRoot\temp\packed\{todo:FeatureName}Data.zip"
    }
    ExtractedSolutions = @(
        [PSCustomObject]@{
            Folder = "$projectRoot\crm\solutions\{todo:Solution1}"
            MappingXmlFile = "$projectRoot\crm\solutions\{todo:Solution1}.mappings.xml"
            PackageType = $PackageType
            ZipFile = "$projectRoot\temp\packed\{todo:Solution1}$solutionExt.zip"
        },
        [PSCustomObject]@{
            Folder = "$projectRoot\crm\solutions\{todo:Solution2}"
            PackageType = 'Unmanaged'
            ZipFile = "$projectRoot\temp\packed\{todo:Solution2}.zip"
        }
    )
    CrmPackageDefinition = @(
        [PSCustomObject]@{
            DataZipFile = "$projectRoot\temp\packed\{todo:FeatureName}Data.zip"
            SolutionZipFiles = @(
                "$projectRoot\crm\solutions\{todo:ExternalManagedSolution}.zip",
                "$projectRoot\temp\packed\{todo:Solution1}$solutionExt.zip",
                "$projectRoot\temp\packed\{todo:Solution2}.zip"
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