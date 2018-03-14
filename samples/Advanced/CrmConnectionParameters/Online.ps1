# a connection to a Dynamics 365 Online deployment
# update the values as appropriate
@{
    OrganizationName = "orgfab51ca3" # see Settings > Customizations > Developer Resources > "Unique Name"
    ServerUrl = "https://fabrikam.crm.dynamics.com" # the online organization URL
    Credential = (Get-Credential) # prompt for credentials
}