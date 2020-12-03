param(
    [System.Collections.Hashtable] $EdFiParamTable = @{ Ods="Server=.; Database=EdFi_Ods_Demo_v320; Trusted_Connection=True;" }
)
Import-Module SQLServer
$OdsConnectStr=$EdFiParamTable.Ods
Invoke-Sqlcmd -InputFile "C:\Ed-Fi\ParentPortal\Student1.ParentPortal.Data\Scripts\edFi31\1CreateParentPortalSupportingDatabaseSchema.sql"  -ConnectionString $OdsConnectStr
Invoke-Sqlcmd -InputFile "C:\Ed-Fi\ParentPortal\Student1.ParentPortal.Data\Scripts\edFi31\2ODSExtensions.sql"  -ConnectionString $OdsConnectStr
Invoke-Sqlcmd -InputFile "C:\Ed-Fi\ParentPortal\Student1.ParentPortal.Data\Scripts\edFi31\99SampleDataNeededForDemo.sql"  -ConnectionString $OdsConnectStr
