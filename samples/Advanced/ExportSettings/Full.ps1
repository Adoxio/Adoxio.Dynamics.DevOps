# this file contains the settings for:
#   - exporting solutions
#   - unpacking solutions
#   - modifying a Configuration Migration Tool (CMT) schema file
#   - unpacking a Configuration Migration Tool (CMT) generated data zip file to individual files
# this file typically does not need to be modified, but the files it refers to would be, including:
#   - CrmDataPackages\Default.ps1
#   - CrmSchemaSettings\Default.ps1
#   - CrmSolutions\Unmanaged.ps1
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters
)

$scriptsRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Split-Path -Parent $scriptsRoot

@{
    ExportSolutions = [PSCustomObject]@{
        CrmConnectionParameters = $CrmConnectionParameters
        Solutions = @(
            [PSCustomObject]@{
                SolutionName = 'AdventureWorks'
                Managed = $false
                ZipFile = "$projectRoot\temp\export\AdventureWorks.zip"
            },
            [PSCustomObject]@{
                SolutionName = 'AdventureWorks'
                Managed = $true
                ZipFile = "$projectRoot\temp\export\AdventureWorks_managed.zip"
            },
            [PSCustomObject]@{
                SolutionName = 'Contoso'
                Managed = $false
                ZipFile = "$projectRoot\temp\export\Contoso.zip"
            },
            [PSCustomObject]@{
                SolutionName = 'Contoso'
                Managed = $true
                ZipFile = "$projectRoot\temp\export\Contoso_managed.zip"
            }
        )
    }
    ExtractSolutions = @(
        [PSCustomObject]@{
            ZipFile = "$projectRoot\temp\export\AdventureWorks.zip"
            MappingXmlFile = "$projectRoot\crm\solutions\AdventureWorks.mappings.xml"
            PackageType = 'Both' # Unmanaged, Managed, Both
            Folder = "$projectRoot\crm\solutions\AdventureWorks"
        },
        [PSCustomObject]@{
            ZipFile = "$projectRoot\temp\export\Contoso.zip"
            MappingXmlFile = "$projectRoot\crm\solutions\Contoso.mappings.xml"
            PackageType = 'Both' # Unmanaged, Managed, Both
            Folder = "$projectRoot\crm\solutions\Contoso"
        }
    )
    CrmSchemaSettings = [PSCustomObject]@{
        Path = "$projectRoot\temp\export\schema.xml"
        Destination = "$projectRoot\temp\export\schema.xml"
        EntityFilter = {$_.name -in 'account','contact'} # only export account and contact
        DisableAllEntityPlugins = $true # disable all plugins on all entities (or use DisableEntityPluginsFilter, don't use both)
        DisableEntityPluginsFilter = {$_.name -in 'account','contact'} # only disable plugins on account and contact during import
        UpdateComparePrimaryIdFilter = {$_.name -notin 'account','contact'} # all entities except for account and contact will be set to match on their primaryid field during import
        UpdateComparePrimaryNameFilter = {$_.name -in 'uom','uomschedule'} # only uom and uomschedule will be set to match on their primaryname field during import
        EntityUpdateCompareFields = @{
            abs_autonumberedentity = 'abs_entitylogicalname' # array of field names to match on
            incident = 'title','ticketnumber' # array of field names to match on
        }
        FieldFilter = {$_.name -notin 'createdby','createdon','createdonbehalfby','importsequencenumber','modifiedby','modifiedon','modifiedonbehalfby','organizationid','overriddencreatedon','ownerid','owningbusinessunit','owningteam','owninguser','timezoneruleversionnumber','utcconversiontimezonecode','versionnumber'} # include all but these fields on all entities
        EntityFieldFilters = @{
            contact = {$_.name -like 'adx_*' -or $_ -in 'contactid','createdon'} # export all fields that start with adx_ or the fields contactid and createdon
            team = {$_.name -notin 'businessunitid','teamid','name','isdefault'} # exclude all fields except businessunitid, teamid, name, and isdefault'
            businessunit = {$_.name -notin 'businessunitid','name'} # exclude all fields except businessunitid and name
            account = {$_ -in 'accountid','parentaccountid'} #  only export accountid and parentaccountid fields
        }
    }
    ExtractData = [PSCustomObject]@{
        ZipFile = "$projectRoot\temp\export\FabrikamFiberData.zip"
        Folder = "$projectRoot\crm\data\FabrikamFiber"
    }
}