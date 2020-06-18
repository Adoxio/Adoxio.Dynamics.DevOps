﻿param (
    # The connection parameters for the target organization
    [Parameter(Mandatory)]
    [ValidateSet('Online','OnPremise','InternetFacingDeployment')] # update this list based on files in the CrmConnectionParameters folder
    [string]
    $CrmConnectionName,

    # The settings for the actions performed during the export
    [Parameter(Mandatory)]
    [ValidateSet('Full')] # update this list based on files in the ExportSettings folder
    [string]
    $ExportSettings,

    # The available actions to perform during the export
    [ValidateSet('All','Solutions','Data','Export-CrmSolutions','Expand-CrmSolutions','Edit-CrmSchemaFile','Expand-CrmData')]
    [string[]]
    $Actions = 'All'
)

$global:ErrorActionPreference = 'Stop'

$CrmConnectionParameters = & "$PSScriptRoot\CrmConnectionParameters\$CrmConnectionName.ps1"

$settings = & "$PSScriptRoot\ExportSettings\$ExportSettings.ps1" -CrmConnectionParameters $CrmConnectionParameters

if($settings.ExportSolutions -and ('All' -in $Actions -or 'Solutions' -in $Actions -or 'Export-CrmSolutions' -in $Actions)) {
    $settings.ExportSolutions | Export-CrmSolutions
}

if($settings.ExtractSolutions -and ('All' -in $Actions -or 'Solutions' -in $Actions -or 'Expand-CrmSolutions' -in $Actions)) {
    $settings.ExtractSolutions | Expand-CrmSolution
}

if($settings.CrmSchemaSettings -and ('All' -in $Actions -or 'Edit-CrmSchemaFile' -in $Actions) -and (Test-Path -Path $settings.CrmSchemaSettings.Path)) {
    $settings.CrmSchemaSettings | Edit-CrmSchemaFile
}

if($settings.ExportData -and ('All' -in $Actions -or 'Data' -in $Actions -or 'Export-CrmData' -in $Actions) -and (Test-Path -Path $settings.ExportData.SchemaFile)) {
    $settings.ExportData | Export-CrmData
}

if($settings.ExtractData -and  ('All' -in $Actions -or 'Data' -in $Actions -or 'Expand-CrmData' -in $Actions) -and (Test-Path -Path $settings.ExtractData.ZipFile)) {
    $settings.ExtractData | Expand-CrmData -Verbose
}