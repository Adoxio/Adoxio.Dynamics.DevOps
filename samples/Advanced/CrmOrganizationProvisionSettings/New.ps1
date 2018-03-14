# a database backup that can be restored to create a new organization
# update the file paths as appropriate
[PSCustomObject]@{
    ComputerName = $CrmConnectionParameters.ServerUrl.Replace("http://", "")
    Credential = $CrmConnectionParameters.Credential
    OrganizationName = $CrmConnectionParameters.OrganizationName
    SqlBackupFile = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\new_MSCRM.bak'
    SqlDataFile = "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\$($CrmConnectionParameters.OrganizationName)_MSCRM.mdf"
    SqlLogFile = "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\$($CrmConnectionParameters.OrganizationName)_MSCRM_log.ldf"
}