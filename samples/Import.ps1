param (
    [Parameter(Mandatory,ParameterSetName="CrmConnectionNameSet")]
    [ValidateSet('{todo:Local-Name1}','{todo:Online-Name1}')]
    [string]
    $CrmConnectionName,

    [Parameter(Mandatory,ParameterSetName="CrmConnectionParametersSet")]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters,

    # The settings to load for various actions performed during the import.
    [Parameter(Mandatory)]
    [ValidateSet("{todo:Environment1Settings}")]
    [string]
    $ImportSettings,

    [ValidateSet("Managed","Unmanaged")]
    [string]
    $PackageType = "Unmanaged",

    # Whether to overwrite an existing organization during import (i.e. delete then create).
    [switch]
    $OverwriteOrganization
)

$global:ErrorActionPreference = "Stop"

if($CrmConnectionName) {
    $CrmConnectionParameters = & "$PSScriptRoot\CrmConnectionParameters\$CrmConnectionName.ps1"
}

$settings = & "$PSScriptRoot\ImportSettings\$ImportSettings.ps1" -CrmConnectionParameters $CrmConnectionParameters -PackageType $PackageType

if($settings.ExtractedData) {
    $settings.ExtractedData | Compress-CrmData
}

if($settings.ExtractedSolutions) {
    $settings.ExtractedSolutions | Compress-CrmSolution
}

if($settings.CrmPackageDefinition) {
    $settings.CrmPackageDefinition | New-CrmPackage
}

if($settings.CrmOrganizationProvisionDefinition -and $CrmConnectionParameters.ServerUrl -eq 'http://dyn365.contoso.com') {
    $settings.CrmOrganizationProvisionDefinition | Restore-CrmRemoteOrganization -Force:$OverwriteOrganization
}

if($settings.CrmPackageDeploymentDefinition) {
    $settings.CrmPackageDeploymentDefinition | Invoke-ImportCrmPackage
}