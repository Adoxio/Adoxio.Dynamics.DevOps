 param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Settings,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [hashtable]
    $CrmConnectionParameters,

    [ValidateSet("Managed","Unmanaged")]
    [string]
    $PackageType = "Managed",

    # Save the package deployer package in the temp folder instead of copying it to the package deployer folder
    [switch]
    $UsePackageFolder
)

$scriptsRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Split-Path -Parent $scriptsRoot
$solutionExt = if($PackageType -eq "Managed") { "_managed" }
$loadedSettings = & "$scriptsRoot\Settings\$Settings.ps1"

$importSettings = @{
    ExtractedSolutions = $loadedSettings.UnmanagedSolutions | foreach {
        [PSCustomObject]@{
            Folder = "$projectRoot\crm\solutions\$_"
            PackageType = $PackageType
            ZipFile = "$projectRoot\temp\packed\$_$solutionExt.zip"
        }
    }
    CrmPackageDefinition = [PSCustomObject]@{
        SolutionZipFiles = @(
            $loadedSettings.ManagedSolutions | foreach {
                "$projectRoot\crm\solutions\$_.zip"
            }

            $loadedSettings.UnmanagedSolutions | foreach {
                "$projectRoot\temp\packed\$_$solutionExt.zip"
            }
        )
    }
    CrmPackageDeploymentDefinition = [PSCustomObject]@{
        CrmConnectionParameters = $CrmConnectionParameters
    }
}

if($loadedSettings.Data) {
    $importSettings.ExtractedData = [PSCustomObject]@{
        Folder = "$projectRoot\crm\data\$($loadedSettings.Data)"
        ZipFile = "$projectRoot\temp\packed\$($loadedSettings.Data).data.zip"
    }

    $importSettings.CrmPackageDefinition | Add-Member DataZipFile "$projectRoot\temp\packed\$($loadedSettings.Data).data.zip"
}

$importSettings.ExtractedSolutions | foreach {
    if(Test-Path ($_.Folder + ".mappings.xml")) {
        $_.MappingXmlFile = $_.Folder + ".mappings.xml"
    }
}

if($UsePackageFolder) {
    $importSettings.CrmPackageDefinition | Add-Member PackageFolder "$projectRoot\temp\packed\CrmPackage\Adoxio.Dynamics.ImportPackage"
}

if($loadedSettings.CrmOrganizationProvisionSettings) {
    $importSettings.CrmOrganizationProvisionDefinition = & "$scriptsRoot\CrmOrganizationProvisionSettings\$($loadedSettings.CrmOrganizationProvisionSettings).ps1"
}

$importSettings