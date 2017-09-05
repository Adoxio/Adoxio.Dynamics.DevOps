@{
    OrganizationName = '{todo:OrganizationName}'
    ServerUrl = 'http://dyn365.contoso.com'
    Credential = [PSCredential]::new("contoso\administrator", ("pass@word1" | ConvertTo-SecureString -AsPlainText -Force))
}