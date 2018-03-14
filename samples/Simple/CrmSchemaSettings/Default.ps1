param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Data
)

[PSCustomObject]@{
    Path = "$projectRoot\temp\export\schema.xml"
    Destination = "$projectRoot\crm\data\$Data.schema.xml"
    EntityFilter = { # include these entities
        ($_.name -like 'abs_*') -or
        ($_.name -like 'adx_*' -and $_.name -notin  'adx_invitation',
                                                    'adx_inviteredemption',
                                                    'adx_urlhistory',
                                                    'adx_websitebinding',
                                                    'adx_webformsession') -or
        ($_.name -in 'account',
                        'annotation',
                        'contact',
                        'pricelevel')
    }
    DisableEntityPluginsFilter = { # disable plugins on all entities except...
        $_.name -notin 'abs_interactiontype',
                        'abs_autonumberedentity',
                        'abs_autonumberingdefinition'
    }
    UpdateComparePrimaryIdFilter = { # entities that will match on primary id during import
        $_.name -like '*'
    }
    UpdateComparePrimaryNameFilter = {$_.name -in 'uom','uomschedule'} # only uom and uomschedule will be set to match on their primaryname field during import
    EntityUpdateCompareFields = @{ # array of field names to match each entity on during import
        abs_autonumberedentity = 'abs_entitylogicalname'
        incident = 'title',
                    'ticketnumber'
    }
    FieldFilter = { # include all but these fields on all entities
        $_.name -notin 'createdby',
                        'createdon',
                        'createdonbehalfby',
                        'importsequencenumber',
                        'modifiedby',
                        'modifiedon',
                        'modifiedonbehalfby',
                        'organizationid',
                        'overriddencreatedon',
                        'ownerid',
                        'owningbusinessunit',
                        'owningteam',
                        'owninguser',
                        'timezoneruleversionnumber',
                        'utcconversiontimezonecode',
                        'versionnumber'
    }
    EntityFieldFilters = @{
        abs_applicationsetting = {$_.name -notin 'abs_value'}
        abs_connect365setting = {$_.name -notin 'abs_value'}
        adx_sitesetting = {$_.name -notin 'adx_value'}
        adx_website = {$_.name -notin 'adx_primarydomainname'}
        contact = {$_.name -notin 'address1_addressid',
                                    'address2_addressid',
                                    'address3_addressid',
                                    'adx_identity_securitystamp',
                                    'adx_profilemodifiedon'}
        role = {$_.name -notin 'businessunitid'}
    }
}