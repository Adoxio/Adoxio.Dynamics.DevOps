param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Settings,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters
)

$scriptsRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Split-Path -Parent $scriptsRoot
$loadedSettings = & "$scriptsRoot\Settings\$Settings.ps1"

$exportSettings = @{
    ExportSolutions = [PSCustomObject]@{
        CrmConnectionParameters = $CrmConnectionParameters
        Solutions = $loadedSettings.UnmanagedSolutions | foreach {
            [PSCustomObject]@{
                SolutionName = $_
                Managed = $false
                ZipFile = "$projectRoot\temp\export\$_.zip"
            }
            [PSCustomObject]@{
                SolutionName = $_
                Managed = $true
                ZipFile = "$projectRoot\temp\export\$($_)_managed.zip"
            }
        }
    }
    ExtractSolutions = $loadedSettings.UnmanagedSolutions | foreach {
        [PSCustomObject]@{
            ZipFile = "$projectRoot\temp\export\$_.zip"
            PackageType = 'Both'
            Folder = "$projectRoot\crm\solutions\$_"
        }
    }
    CrmSchemaSettings = & "$scriptsRoot\CrmSchemaSettings\Default.ps1" -Data $loadedSettings.Data
    ExtractData = [PSCustomObject]@{
        ZipFile = "$projectRoot\crm\data\$($loadedSettings.Data).data.zip"
        Folder = "$projectRoot\crm\data\$($loadedSettings.Data)"
    }
}

$exportSettings.ExtractSolutions | foreach {
    if(Test-Path ($_.Folder + ".mappings.xml")) {
        $_.MappingXmlFile = $_.Folder + ".mappings.xml"
    }
}

$exportSettings