
# Edit-CrmSchemaFile

## Synopsis
Modifies a Configuration Migration tool schema file.

## Description
This function takes a Configuration Migration tool schema file and modifies its contents to control the list of entities and fields that are included during an export, and the settings to use when importing the records uusing the Configuration Migration tool and Package Deployer.

## Parameters
| Parameter  | Type | Description | Required? | Default Value |
|---|---|---|---|---|
| Path | String | The path to an existing Configuration Migration tool schema file. | true | |
| Destination | String | The path to store the modified Configuration Migration tool schema file. | true | |
| EntityFilter | ScriptBlock | A predicate for choosing whether an entity should be exported. A comparison will be performed against every `<entity>` XmlNode, with a result of `$true` causing the `<entity>` XmlNode to be retained and resulting in the entity being exported. | false | |
| DisableAllEntityPlugins | SwitchParameter | Use to disable all plugins on all entities during import. | false | False |
| DisableEntityPluginsFilter | ScriptBlock | A predicate for choosing whether an entity should have its plugins disabled during import. A filter result of `$true` will cause the entity's plugins to be disabled. | false | |
| UpdateComparePrimaryIdFilter | ScriptBlock | Specifies the script block that is used to filter the entities that will match on their primaryid field during import. A filter result of $true will cause the entity to be matched on its primaryid field. | false | |
| UpdateComparePrimaryNameFilter | ScriptBlock | Specifies the script block that is used to filter the entities that will match on their primaryname field during import. A filter result of `$true` will cause the entity to be matched on its primaryname field. | false | |
| UpdateCompareEntityFields | Hashtable | Specifies a hashtable of entity names and field names to indicate one or more fields each entity will be matched on during import. | false | |
| FieldFilter | ScriptBlock | Specifies the script block that is used to filter the fields that will be included from all entities during export. A filter result of `$true` will cause the field to be included from all entities during export. This will primarily be used to exclude certain fields though negation comparision operators (e.g. `-notin`). | false | |
| EntityFieldFilters | Hashtable | Specifies the hashtable of entity names and scriptblocks that are used to filter the fields that will be included from specified entities during export. A filter result of `$true` will cause the field to be included from the specified entity during export. | false | |

## Examples

## Example 1
This example modifies a schema file using the `-EntityFilter` parameter to specify only the account and contact entities should be included in the destination file. All other entities are removed from the schema file.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -EntityFilter {$_.name -in 'account,'contact'}
```

## Example 2
This example modifies a schema file using the `-DisableAllEntityPlugins` parameter to specify all entities should have plugins disabled on them during import.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -DisableAllEntityPlugins
```

## Example 3
This example modifies a schema file using the `-DisableAllEntityPlugins` parameter to specify all entities should have plugins disabled on them during import.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -DisableAllEntityPlugins
```

## Example 4
This example modifies a schema file using the `-DisableEntityPluginsFilter` parameter to specify only the account and contact entities should have plugins disabled on them during import.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -DisableEntityPluginsFilter {$_.name -in 'account','contact'}
```

## Example 5
This example modifies a schema file using the `-UpdateComparePrimaryIdFilter` parameter to specify all entities, except for account and contact, should match on their primaryid field during import.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -UpdateComparePrimaryIdFilter {$_.name -notin 'account','contact'}
```

## Example 6
This example modifies a schema file using the `-UpdateComparePrimaryNameFilter` parameter to specify that the uom and uomschedule entities should match on their primaryname field during import. The Configuration Migration tool and Package Deployer match on primaryname by default, making this parameter unnecessary unless wanting to explicity define the entities that will be matched by their primaryname.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -UpdateComparePrimaryNameFilter {$_.name -in 'uom','uomschedule'}
```

## Example 7
This example modifies a schema file using the `-EntityUpdateCompareFields` parameter to specify that the abs_autonumberedentity entity should match records using the `abs_entitylogicalname` field, and the incident entity should match records using both the title and ticketnumber fields.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -EntityUpdateCompareFields @{abs_autonumberedentity = 'abs_entitylogicalname'; incident = 'title','ticketnumber'}
```

## Example 8
This example modifies a schema file using the `-FieldFilter` parameter to specify that all entities should include all their fields except for the ones listed in the array. This technique is useful for excluding fields where there are common fields across multipel entities where their data is unnecessary to store in a source control system because the values are system generated, not meaningful, or not desirable to ever be imported into a target system.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -FieldFilter {$_.name -notin 'createdby','createdon','createdonbehalfby','importsequencenumber','modifiedby','modifiedon','modifiedonbehalfby'}
```

## Example 9
This example modifies a schema file using the `-EntityFieldFilters` parameter to specify that the contact and team entities should only include specific fields. The contact entity matches on a wildcard to include fields that start with abs_ or the fields named contactid and createdon. The team entity uses the `-notin` comparison to include all fields except for the ones listed in the array.
```powershell
Edit-CrmSchemaFile -Path C:\temp\schema-original.xml -Destination C:\temp\schema-modified.xml -EntityFieldFilters @{contact = {$_.name -like 'abs_*' -or $_.name -in 'contactid','createdon'}; team = {$_ -notin 'businessunitid','teamid','name','isdefault'} }
```
