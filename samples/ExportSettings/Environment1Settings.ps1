param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters
)

$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

@{
    ExportSolutions = [PSCustomObject]@{
        CrmConnectionParameters = $CrmConnectionParameters
        Solutions = @(
            [PSCustomObject]@{
                SolutionName = '{todo:Solution1}'
                Managed = $false
                ZipFile = "$projectRoot\temp\export\{todo:Solution1}.zip"
            },
            [PSCustomObject]@{
                SolutionName = '{todo:Solution1}'
                Managed = $true
                ZipFile = "$projectRoot\temp\export\{todo:Solution1}_managed.zip"
            },
            [PSCustomObject]@{
                SolutionName = 'Solution2'
                Managed = $false
                TargetVersion = "8.0"
                ZipFile = "$projectRoot\temp\export\{todo:Solution2}.zip"
            }
        )
    }
    ExtractSolutions = @(
        [PSCustomObject]@{
            ZipFile = "$projectRoot\temp\export\{todo:Solution1}.zip"
            MappingXmlFile = "$projectRoot\crm\solutions\{todo:Solution1}.mappings.xml"
            PackageType = 'Both' # Unmanaged, Managed, Both
            Folder = "$projectRoot\crm\solutions\{todo:Solution1}"
        },
        [PSCustomObject]@{
            ZipFile = "$projectRoot\temp\export\{todo:Solution2}.zip"
            PackageType = 'Unmanaged' # Unmanaged, Managed, Both
            Folder = "$projectRoot\crm\solutions\{todo:Solution2}"
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
        ZipFile = "$projectRoot\temp\export\{todo:FeatureName}Data.zip"
        Folder = "$projectRoot\crm\data\{todo:FeatureName}"
    }
}