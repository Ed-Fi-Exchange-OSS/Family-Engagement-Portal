param(
    [System.Collections.Hashtable] $EdFiParamTable = @{ Ods="Server=.; Database=EdFi_Ods_Demo_v340; Trusted_Connection=True;"; SolutionPath="C:\Ed-Fi\FamilyPortal"}
)
Import-Module SQLServer
$OdsConnectStr=$EdFiParamTable.Ods
$DbScriptPath="C:\Ed-Fi\FamilyPortal\Student1.ParentPortal.Data\Scripts\edFi31"
Invoke-Sqlcmd -InputFile "$DbScriptPath\1CreateParentPortalSupportingDatabaseSchema.sql"  -ConnectionString $OdsConnectStr
Invoke-Sqlcmd -InputFile "$DbScriptPath\2ODSExtensions.sql"  -ConnectionString $OdsConnectStr
Invoke-Sqlcmd -InputFile "$DbScriptPath\3StudentDetails.sql"  -ConnectionString $OdsConnectStr
Invoke-Sqlcmd -InputFile "$DbScriptPath\4SampleDataDemo.sql"  -ConnectionString $OdsConnectStr
