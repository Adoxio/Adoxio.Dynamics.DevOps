param (
    [Parameter(Mandatory,ParameterSetName="CrmConnectionNameSet")]
    [ValidateSet('{todo:Local-Name1}','{todo:Online-Name1}')]
    [string]
    $CrmConnectionName,

    [Parameter(Mandatory,ParameterSetName="CrmConnectionParametersSet")]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters,

    # The settings to load for various actions performed during the export.
    [Parameter(Mandatory)]
    [ValidateSet("{todo:Environment1Settings}")]
    [string]
    $ExportSettings,

    [Parameter(Mandatory)]
    [ValidateSet("Data","Solutions")]
    [string[]]
    $Components
)

$global:ErrorActionPreference = "Stop"

if($CrmConnectionName) {
    $CrmConnectionParameters = & "$PSScriptRoot\CrmConnectionParameters\$CrmConnectionName.ps1"
}

$settings = & "$PSScriptRoot\ExportSettings\$ExportSettings.ps1" -CrmConnectionParameters $CrmConnectionParameters

if($settings.ExportSolutions -and $Components -contains 'Solutions') {
    $settings.ExportSolutions | Export-CrmSolutions
}

if($settings.ExtractSolutions -and $Components -contains 'Solutions') {
    $settings.ExtractSolutions | Expand-CrmSolution
}

# before Set-CrmSchemaFile: manually generate schema file using configuration migration tool (todo: replace with automated Appium)

if($settings.CrmSchemaSettings -and $Components -contains 'Data' -and (Test-Path -Path $settings.CrmSchemaSettings.Path)) {
    $settings.CrmSchemaSettings | Edit-CrmSchemaFile
}

# after Set-CrmSchemaFile: manually export data using configuration migration tool: (todo: replace with automated Appium)

if($settings.ExtractData -and $Components -contains 'Data' -and (Test-Path -Path $settings.ExtractData.ZipFile)) {
    $settings.ExtractData | Expand-CrmData
}