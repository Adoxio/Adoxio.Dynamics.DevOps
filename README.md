# Adoxio.Dynamics.DevOps

Adoxio.Dynamics.DevOps is a PowerShell module for performing DevOps activities for Dynamics 365 CE.

## Installation for Dynamics 365 v9.x

- Open Windows PowerShell and install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Adoxio.Dynamics.DevOps/)
  ```PowerShell
  Install-Module -Name Adoxio.Dynamics.DevOps -Scope CurrentUser
  ```
- Download and install the [Dynamics 365 v9.x SDK](https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/download-tools-nuget#download-tools-using-powershell)
- Create an environment variable named `CRM_SDK_PATH` and set it to the folder path of the downloaded tools. The folder path to use is the `Tools` folder containing the `ConfigurationMigration`, `CoreTools`, `PackageDeployment`, and `PluginRegistration` folder. This can be done in PowerShell by executing this code:
  ```PowerShell
  [Environment]::SetEnvironmentVariable("CRM_SDK_PATH", "C:\Path\To\Tools", "User")
  ```
- Restart PowerShell for the new environment variable to take effect

## Installation for Dynamics 365 v8.x

Walkthrough instructions are available in the blog post [Installing Adoxio.Dynamics.DevOps](https://alanmervitz.com/2017/09/09/installing-adoxio-dynamics-devops/).

An abbreviated version is as follows:

- Open Windows PowerShell and install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/Adoxio.Dynamics.DevOps/)
  ```PowerShell
  Install-Module -Name Adoxio.Dynamics.DevOps -Scope CurrentUser
  ```
- Download and install the [Dynamics 365 v8.x SDK](https://www.microsoft.com/en-us/download/details.aspx?id=50032)
- Create an environment variable named `CRM_SDK_PATH` and set it to the folder path of the extracted Dynamics 365 SDK folder on your computer. The folder path to use is the `SDK` folder containing the `Bin`, `Resources`, `SampleCode`, `Schemas`, `Templates`, and `Tools` folders. This can be done in PowerShell by executing this code:
  ```PowerShell
  [Environment]::SetEnvironmentVariable("CRM_SDK_PATH", "C:\Path\To\SDK", "User")
  ```
- Restart PowerShell for the new environment variable to take effect

## Functions

This module includes the following functions that can be used individually to implement tailored scripting needs.

### [Compress-CrmData](docs/functions/Compress-CrmData.md)

Packs and zips a folder of Configuration Migration tool generated files previously created from the `Expand-CrmData` cmdlet.

### [Compress-CrmSolution](docs/functions/Compress-CrmSolution.md)

Packages an unpacked CRM solution folder using the SolutionPackager tool.

### [Edit-CrmSchemaFile](docs/functions/Edit-CrmSchemaFile.md)

Modifies a Configuration Migration tool schema file to control the list of entities and fields that are included during an export, and the settings to use when importing the records using the Configuration Migration tool and Package Deployer.

### [Expand-CrmData](docs/functions/Expand-CrmData.md)

Extracts a Configuration Migration tool generated zip file and unpacks the .xml files into separate files and folders, where each entity is stored in its own folder and each record is stored in its own .xml file inside the entity folder.

### [Expand-CrmSolution](docs/functions/Expand-CrmSolution.md)

Extracts a CRM solution file to its individual components using the SolutionPackager tool included in the Dynamics 365 SDK.

### [Export-CrmData](docs/functions/Export-CrmData.md)

Extracts configuration data using the Configuration Migration Tool PowerShell module.

### [Export-CrmSolutions](docs/functions/Export-CrmSolutions.md)

Exports a list of solutions from a CRM organization.

### [Invoke-ImportCrmPackage](docs/functions/Invoke-ImportCrmPackage.md)

Imports a package to a Microsoft Dynamics CRM instance.

### [New-AppSourcePackage](docs/functions/New-AppSourcePackage.md)

Creates an AppSource package.

### [New-CrmPackage](docs/functions/New-CrmPackage.md)

This function creates a package for use with the Dynamics CRM Package deployer included in the Dynamics 365 SDK.

### [Remove-CrmOrganization](docs/functions/Remove-CrmOrganization.md)

Deletes an existing on-premise CRM organization from a local CRM server.

### [Remove-CrmRemoteOrganization](docs/functions/Remove-CrmRemoteOrganization.md)

Deletes an existing on-premise CRM organization from a remote CRM server.

### [Restore-CrmOrganization](docs/functions/Restore-CrmOrganization.md)

Creates a new on-premise CRM organization on a local CRM server by restoring from a backup.

### [Restore-CrmRemoteOrganization](docs/functions/Restore-CrmRemoteOrganization.md)

Creates a new on-premise CRM organization on a remote server by restoring from a backup.

## Prescriptive Scripting Usage

This project includes prescriptive samples for defining a series of actions that manage the full lifecyle of exporting and importing customizations and data from Dynamics 365 organizations. The samples are a combination of declaritive configuration files and scripts that use the configuration files to execute exports and imports.

Walkthrough instructions are available in the following blog posts:
- [Adding Adoxio.Dynamics.DevOps Scripts to a Project](https://alanmervitz.com/2018/10/15/adding-adoxio-dynamics-devops-scripts-to-a-project/)
- [Scripted Solution Exports with Adoxio.Dynamics.DevOps](https://alanmervitz.com/2018/10/22/scripted-solution-exports-with-adoxio-dynamics-devops/)
- [Configuration Migration Tool Schema File Preparation using Adoxio.Dynamics.DevOps](https://alanmervitz.com/2018/11/05/configuration-migration-tool-schema-file-preparation-using-adoxio-dynamics-devops/)

An abbreviated version is as follows:

- Copy and rename the `samples/Advanced` folder from this project to the root of your own project with the name `scripts`
- Edit or create files inside the `CrmConnectionParameters`, `ExportSettings` and `ImportSettings` folders to describe the environments, solutions, and data that will be used during exports and imports
- Update the parameters at the top of the `Export.ps1` and `Import.ps1` files to refer to the file names used in the previous step
- Invoke the `Export.ps1` and `Import.ps1` scripts to execute exports and imports

## Project Development

To load this project for making changes to the PowerShell module and samples, ensure that you have [Git](https://git-scm.com/downloads) installed to obtain the source code, and [Visual Studio 2017](https://docs.microsoft.com/en-us/visualstudio/welcome-to-visual-studio) with the [PowerShell Tools for Visual Studio 2017](https://marketplace.visualstudio.com/items?itemName=AdamRDriscoll.PowerShellToolsforVisualStudio2017-18561) extension to easily view and edit the code.

- Clone the repository using Git:
  ```sh
  git clone https://github.com/Adoxio/Adoxio.Dynamics.DevOps.git
  ```
- Open the `Adoxio.Dynamics.DevOps.sln` solution file in Visual Studio

### Project Structure

The primary folders in this repository are:

- [/src/Adoxio.Dynamics.DevOps](src/Adoxio.Dynamics.DevOps) - the main PowerShell module implemented using advanced functions

- [/src/Adoxio.Dynamics.ImportPackage](src/Adoxio.Dynamics.ImportPackage) - a generic [CRM Package](https://msdn.microsoft.com/en-us/library/dn688182.aspx) used to import solutions and data with the Dynamics 365 SDK's [Package Deployer](https://technet.microsoft.com/en-us/library/dn647420.aspx)

- [/samples](samples) - sample code for PowerShell scripts that perform imports and exports using the module

## Support

Support is available by [submitting issues](https://github.com/Adoxio/xRM-Portals-Community-Edition/issues) to this GitHub project.

## License

This project uses the [MIT license](https://opensource.org/licenses/MIT).

## Contributions

This project accepts community contributions through GitHub, following the [inbound=outbound](https://opensource.guide/legal/#does-my-project-need-an-additional-contributor-agreement) model as described in the [GitHub Terms of Service](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license):
> Whenever you make a contribution to a repository containing notice of a license, you license your contribution under the same terms, and you agree that you have the right to license your contribution under those terms.

Please submit one pull request per issue so that we can easily identify and review the changes.
