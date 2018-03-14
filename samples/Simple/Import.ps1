param (
    # The connection parameter settings file specifying the target environment for importing solutions and data
    [Parameter(Mandatory)]
    [ValidateSet('InternetFacingDeployment','Online','OnPremise')]
    [string]
    $CrmConnectionName,

    # The settings file containing the configuration values for actions performed during the import
    [Parameter(Mandatory)]
    [ValidateSet('Default')]
    [string]
    $Settings,

    # The type of solutions to generate during solution packager packing
    [ValidateSet('Managed','Unmanaged')]
    [string]
    $PackageType = 'Managed',

    # Overwrite an existing organization during import (i.e. delete then create, typically only used with local VM development)
    [switch]
    $OverwriteOrganization,

    # The actions to perform during script execution
    [ValidateSet('All','Compress-CrmData','Compress-CrmSolution','New-CrmPackage','Restore-CrmRemoteOrganization','Invoke-ImportCrmPackage')]
    [string[]]
    $Actions = 'All'
)

$global:ErrorActionPreference = 'Stop'

$CrmConnectionParameters = & "$PSScriptRoot\CrmConnectionParameters\$CrmConnectionName.ps1"

$importSettings = & "$PSScriptRoot\Settings\GenerateImportSettings.ps1" -Settings $Settings -CrmConnectionParameters $CrmConnectionParameters -PackageType $PackageType

if($importSettings.CrmOrganizationProvisionDefinition -and $CrmConnectionParameters.ServerUrl -eq 'http://dyn365.contoso.com' -and ('All' -in $Actions -or 'Restore-CrmRemoteOrganization' -in $Actions)) {
    $importSettings.CrmOrganizationProvisionDefinition | Restore-CrmRemoteOrganization -Force:$OverwriteOrganization
}

if($importSettings.ExtractedData -and ('All' -in $Actions -or 'Compress-CrmData' -in $Actions)) {
    $importSettings.ExtractedData | Compress-CrmData
}

if($importSettings.ExtractedSolutions -and ('All' -in $Actions -or 'Compress-CrmSolution' -in $Actions)) {
    $importSettings.ExtractedSolutions | Compress-CrmSolution
}

if($importSettings.CrmPackageDefinition -and ('All' -in $Actions -or 'New-CrmPackage' -in $Actions)) {
    $importSettings.CrmPackageDefinition | New-CrmPackage
}

if($importSettings.CrmPackageDeploymentDefinition -and ('All' -in $Actions -or 'Invoke-ImportCrmPackage' -in $Actions)) {
    $importSettings.CrmPackageDeploymentDefinition | Invoke-ImportCrmPackage
}