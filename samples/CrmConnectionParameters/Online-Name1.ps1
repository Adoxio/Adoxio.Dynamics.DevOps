$uniqueName = '{todo:UniqueOrganizationName}' # see Settings > Customizations > Developer Resources > 'Unique Name'

@{
    OrganizationName = $uniqueName
    ServerUrl = "https://$uniqueName.{todo:crm}.dynamics.com"
    Credential = [PSCredential]::new("{todo:name@domain.ext}", ("{todo:password}" | ConvertTo-SecureString -AsPlainText -Force))
}