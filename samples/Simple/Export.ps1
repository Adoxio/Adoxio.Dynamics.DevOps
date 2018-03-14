param (
    # The connection parameter settings file specifying the target environment for importing solutions and data
    [Parameter(Mandatory)]
    [ValidateSet('InternetFacingDeployment','Online','OnPremise')]
    [string]
    $CrmConnectionName,

    # The settings file containing the configuration values for actions performed during the export
    [Parameter(Mandatory)]
    [ValidateSet('Default')]
    [string]
    $Settings,

    # The actions to perform during script execution
    [Parameter(Mandatory)]
    [ValidateSet('All','Solutions','Export-CrmSolutions','Expand-CrmSolutions','Edit-CrmSchemaFile','Expand-CrmData')]
    [string[]]
    $Actions
)

$global:ErrorActionPreference = 'Stop'

$CrmConnectionParameters = & "$PSScriptRoot\CrmConnectionParameters\$CrmConnectionName.ps1"

$exportSettings = & "$PSScriptRoot\Settings\GenerateExportSettings.ps1" -Settings $settings -CrmConnectionParameters $CrmConnectionParameters

if($exportSettings.ExportSolutions -and ('All' -in $Actions -or 'Solutions' -in $Actions -or 'Export-CrmSolutions' -in $Actions)) {
    $exportSettings.ExportSolutions | Export-CrmSolutions
}

if($exportSettings.ExtractSolutions -and ('All' -in $Actions -or 'Solutions' -in $Actions -or 'Expand-CrmSolutions' -in $Actions)) {
    $exportSettings.ExtractSolutions | Expand-CrmSolution
}

# before Set-CrmSchemaFile: manually generate schema file using configuration migration tool (todo: replace with automated Appium)

if($exportSettings.CrmSchemaSettings -and ('Edit-CrmSchemaFile' -in $Actions) -and (Test-Path -Path $exportSettings.CrmSchemaSettings.Path)) {
    $exportSettings.CrmSchemaSettings | Edit-CrmSchemaFile
}

# after Set-CrmSchemaFile: manually export data using configuration migration tool (todo: replace with automated Appium)

if($exportSettings.ExtractData -and  ('All' -in $Actions -or 'Expand-CrmData' -in $Actions) -and (Test-Path -Path $exportSettings.ExtractData.ZipFile)) {
    $exportSettings.ExtractData | Expand-CrmData -Verbose
    .\PostExportScripts\DeleteNonWebfileAnnotations.ps1 -Path $exportSettings.ExtractData.Folder
}